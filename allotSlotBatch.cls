global class allotSlotBatch implements Database.Batchable<sObject>, Database.Stateful{ //called only once
   DateTime currentSlot , endSlot ;
   global Database.QueryLocator start(Database.BatchableContext BC){
      String query = 'select ID, Slot__c from User where ProfileId in (Select ID from Profile where Name = \'Platform Voter\')';
      currentSlot = DateTime.newInstance(2018,06,03,09,00,00);//dateTime for 3rd June 2018, 9 am. Can be made configurable
      endSlot     = DateTime.newInstance(2018,06,03,18,00,00);//dateTime for 3rd June 2018, 6 pm. Can be made configurable
      return Database.getQueryLocator(query);
   }
   global void execute(Database.BatchableContext info, List<User> scope){//executes for every batch
       
       List<User> usersToUpdate = new List<User>();
       for(User usr : scope){
           usr.Slot__c = currentSlot;
           usersToUpdate.add(usr);
           if(currentSlot.addMinutes(20) < endSlot){
               currentSlot = currentSlot.addMinutes(20);//voting slot of 20 min and can be made configurable
           }
       } 
       update usersToUpdate;
   }
   global void finish(Database.BatchableContext info){ //to send email to admin in case of errors while alloting slots    
   } 
}