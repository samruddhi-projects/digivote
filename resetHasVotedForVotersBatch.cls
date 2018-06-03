global class resetHasVotedForVotersBatch implements Database.Batchable<sObject>, Database.Stateful{ //called only once
   global Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'select ID, Has_Voted__c from User where ProfileId in (Select ID from Profile where Name = \'Platform Voter\')';
      return Database.getQueryLocator(query);
   }
   global void execute(Database.BatchableContext info, List<User> scope){//executes for every batch
       
       List<User> usersToUpdate = new List<User>();
       for(User usr : scope){
           VotingHelper voteHelp = new VotingHelper();
           usr.Has_Voted__c = voteHelp.getVotingStatusEncrypted(usr.ID, 'no');//reset has_voted status to MD5Encryption($userID-no)
           //has_voted is in turn encrypted by Salesforce and masked
           usersToUpdate.add(usr);
       }
       update usersToUpdate;
   }
   global void finish(Database.BatchableContext info){ //to send email to admin in case of errors while resetting voter status  
   }
}