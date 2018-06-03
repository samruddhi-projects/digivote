public with sharing class VotingHelper{
	private static User VoterInfo {
		get{
			if(VoterInfo==null){
				VoterInfo = [Select Id, Slot__c,Has_Voted__c, isActive FROM User WHERE Id=: UserInfo.getUserId() LIMIT 1];
			}
			return VoterInfo;
		} 
		set;}
	
	public User getVoter(){
		return VoterInfo;
	} 	
    
    public String preVotingValidation(Id userId){
        //TODO check for voting enabled
        
       if(VoterInfo!=null && VoterInfo.isActive && VoterInfo.Slot__c!=null){
             DateTime slotStartTime = VoterInfo.Slot__c;
             DateTime slotEndTime = getEndTimeForSlot();
            
            if(hasVoted()){
            	return VoteConstants.ALREADY_VOTED;
            }
            else if(system.now() < slotStartTime ){
                return VoteConstants.SLOT_NOT_STARTED;
            }
            else if(system.now() > slotEndTime ){
                return VoteConstants.SLOT_ENDED;
            }/*
            else if(system.now() > slotEndTime ){
                return VoteConstants.SLOT_NOT_STARTED;
            }*/
        }
        else{
            return VoteConstants.INVALID_USER;
        }
        
        return null;
    }
    
    
    public List<Candidate__c> getCurrentWardCandidates(){
    	List<Candidate__c> candidates = new List<Candidate__c>();
    	if(VoterInfo!=null && VoterInfo.Id!=null){
    		candidates = [SELECT Name,Party__c,Party__r.Party_Icons__c, Ward__c, Ward__r.Name 
    						FROM Candidate__c where Ward__c in 
    						( SELECT Ward__c  FROM User_Ward__c 
    							where Voter__c = :String.escapeSingleQuotes(VoterInfo.Id))
    				];
    	}
    	system.debug(LoggingLevel.DEBUG, 'VotingHelper.getCurrentWardCandidates-candidates:'+candidates);
    	return candidates;
    }
    public Decimal getExpirationTimer(){
    	DateTime endTime = getEndTimeForSlot();
    	Long difference = endTime.getTime()-system.now().getTime();
    	Decimal expirationTime = difference/60000;
    	system.debug(LoggingLevel.DEBUG, 'VotingHelper.getExpirationTimer-expirationTime:'+expirationTime);
    	if(expirationTime<=0){
    		expirationTime = 0;
    	}
    	return expirationTime;
    }
    
    private DateTime getEndTimeForSlot(){
        if(VoterInfo!=null && VoterInfo.Slot__c!=null){
            SysProperties__c slotDurationProperty = SysProperties__c.getValues('SlotDuration');
            Integer slotDurationMins = Integer.valueOf(slotDurationProperty.value__c);
            system.debug(LoggingLevel.DEBUG, 'VotingHelper.getExpirationTimer-slotDurationMins:'+slotDurationMins);
            
            DateTime slotEndTime = VoterInfo.Slot__c.addMinutes(slotDurationMins);
			return slotEndTime;
        }
        
        return null;
    }
	public Boolean submitVote(Id selectedCandidateId){
		Boolean isSuccess = false;
		
		//before updating in DB cross check if the time is still valid
		if(isValidVoteTime(VoterInfo.Slot__c)){
			//update whether user has voted in encrypted form
			VoterInfo.Has_Voted__c = getVotingStatusEncrypted(VoterInfo.Id,'yes');
			update VoterInfo;
			
			//increment candidate's vote count anonymously in system user context
			updateCandidateCountAnonymous(selectedCandidateId);
			isSuccess= true;
		}
		return isSuccess;
	} 
	
	public String getVotingStatusEncrypted(Id userId, String status){
		String key = userId+ '-'+ status;
		Blob requestBlob = Blob.valueOf(key+VoteConstants.SECRET_KEY);
		Blob hash = Crypto.generateDigest('MD5', requestBlob);
		String requestSignature = EncodingUtil.convertToHex(hash);
		return requestSignature; // returns the encrypted value
		
		
	} 
	
	
    private Boolean isValidVoteTime(DateTime slotStartTime){
        Boolean isValidTime = false;
        
        if(VoterInfo!=null && VoterInfo.isActive && VoterInfo.Slot__c!=null){
            DateTime slotEndTime = getEndTimeForSlot();
            
            if(system.now() > slotStartTime && system.now() < slotEndTime ){
                isValidTime = true;
            }
        }
        system.debug(LoggingLevel.DEBUG, 'VotingHelper.isValidVoteTime-isValidTime:'+isValidTime);
        
        return isValidTime;
    }
    
    
	
	private Boolean hasVoted(){
		if(String.isNotBlank(VoterInfo.Has_Voted__c)){
			String key = VoterInfo.Id + '-yes';
			Blob requestBlob = Blob.valueOf(key+VoteConstants.SECRET_KEY);
			Blob hash = Crypto.generateDigest('MD5', requestBlob);
			String validVoteKey = EncodingUtil.convertToHex(hash);
			if(VoterInfo.Has_Voted__c.equals(validVoteKey)){
				system.debug(LoggingLevel.DEBUG, 'VotingHelper.hasVoted-true');
				return true;
			}
		}
		return false; 
		
		
	}
	
	private void updateCandidateCountAnonymous(Id candidateId){
		Vote__c addedVote = new Vote__c();
		//update all audit trail fields to system user to avoid identifying which voter cast the vote for the candidate
        addedVote.Candidate__c = candidateId;
        addedVote.CreatedById = VoteConstants.SYSTEM_USER;
        addedVote.LastModifiedById = VoteConstants.SYSTEM_USER;
        insert addedVote;
	}
	 
	
}
