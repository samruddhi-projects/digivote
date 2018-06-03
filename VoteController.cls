public with sharing class VoteController{

     public Decimal expirationTimer {get; set;}
     public String candidateJSON {get; set;}
     VotingHelper helper = new VotingHelper();
     public List<Candidate__c> Candidates {get; set;}
     public string candidatesLists{get; set;}
     public map<String,Object> candidatesMap{get; set;}
     public Id candidateId {get; set;}
     public String inputValue {get; set;}
     public String UID {get; set;}
     public String OTP {get; set;}
    
     private class propertyBean{
        public String recordId {get; set;}
        public String imgUrl {get; set;}
        public String name {get; set;}
        public String key {get; set;}
        
    }
    public List<propertyBean> propertyBeanList{get; set;}
    
    public VoteController(){
        expirationTimer = helper.getExpirationTimer();
        system.debug(LoggingLevel.DEBUG, 'VoteController-expirationTimer:'+expirationTimer);
        propertyBeanList= candidatesMap();
        
    }
    
   /* private List<map<String,Object>> candidatesList(){ 
        Candidates = helper.getCurrentWardCandidates();
        List<map<String,Object>> userList = new List<map<string,object>>();
        for(Candidate__c userRec:Candidates ){
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            String pwd = key.substring(0,5);
            userList.add((new Map<String,Object>{
                'Name' => userRec.Name,
                'Id' => userRec.Id,
                'Image' => userRec.Party__r.Party_Icons__c,
                'Party' => userRec.Party__c,
                'Ward' => userRec.Ward__r.Name,
                'key' => pwd 

            }));
        
        }
        return userList;
        
     }*/
     
     
     
    private List<propertyBean> candidatesMap(){ 
        Candidates = helper.getCurrentWardCandidates();
        List<propertyBean> userList = new List<propertyBean>();
        for(Candidate__c userRec:Candidates ){
            Blob blobKey = crypto.generateAesKey(128);
            String key = EncodingUtil.convertToHex(blobKey);
            String secretId = key.substring(0,5);
            propertyBean pBean = new propertyBean();
            pBean.recordId = userRec.Id;
            pBean.imgUrl = userRec.Party__r.Party_Icons__c;
            pBean.name= userRec.Name;
            pBean.key = secretId;
           userList.add(pBean);

        }
        return userList;
     }
     
    public pageReference preValidation(){
        VotingHelper helper = new VotingHelper();
        //validate current user's time slot
        String validationErrorId = helper.preVotingValidation(UserInfo.getUserId());
        //in case of error redirect to error page
        if(String.isNotBlank(validationErrorId)){
            return new PageReference('/apex/VotingError?errorId='+validationErrorId);
        }
        else{
            return new PageReference('/apex/AadharAuthentication');
        }
    }
    
    public pageReference postAadharValidation(){
        VotingHelper helper = new VotingHelper();
        if(validateAadharSandbox(UID,OTP)){
            UID = null;
            OTP=null;
            return new PageReference('/apex/CandidateListPage');
        }
        else{
            return new PageReference('/apex/VotingError?errorId=INVALID_USER');
        }
    }
    
    @RemoteAction
    public static Map<String,String> initVotingData(){
        Map<String,String> result = new Map<String,String>();
        VotingHelper helper = new VotingHelper();
        result.put('UserInfo',JSON.serialize(helper.getVoter()));
        result.put('ExpirationTime',String.valueOf(helper.getExpirationTimer()));
        result.put('CandidateInfo',JSON.serialize(helper.getCurrentWardCandidates()));
        return result;
    }
    
    public PageReference submitVote(){
        //before updating in DB cross check if the time is still valid
        
        Id recId;
        boolean flag = false;
        
        for(propertyBean rec: propertyBeanList){
          if(rec.key == inputValue){
              recId = rec.recordId ;
              flag = true;
              break;
          }
          
        }
        if(!flag)
            return new PageReference('/apex/VotingError?errorId='+VoteConstants.WRONGKEY);
            
        VotingHelper helper = new VotingHelper();
        if(helper.submitVote(recId)){
            return new PageReference('/apex/VotingSuccess');
        }
        else{
            return new PageReference('/apex/VotingError?errorId='+VoteConstants.SLOT_TIMEOUT);
        }
    }


	public Boolean validateAadharSandbox(String uid, String otp) {
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://ext.digio.in:1200/test/otpkyc');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json');
        request.setHeader('Authorization', 'No');
        // Set the body as a JSON object
        request.setBody('{"aadhaar_id": "'+UID+'","otp": "'+OTP+'","txn_id": "547039586626"}');
        System.debug('**** Request:'+request);
        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug('**** Response:'+response.getBody());
        // Parse the JSON response
        if(response.getBody().contains('"status": true,')){
            System.debug('**** AADHAR AUTHENTICATED!');
            return true;
        }
        
        return false;

    }
}
