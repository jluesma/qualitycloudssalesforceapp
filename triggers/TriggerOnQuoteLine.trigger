trigger TriggerOnQuoteLine on SBQQ__QuoteLine__c (after insert, after update, before delete) {

     boolean isDelete = false;
     
     if( (Trigger.isAfter && Trigger.isInsert) || (Trigger.isAfter && Trigger.isUpdate) ){
         isDelete = false;
         TriggerOnQuoteLine_Handler.TriggerHandler(isDelete, Trigger.new);   
     }

     if(Trigger.isBefore && Trigger.isDelete){
         isDelete = true;
         TriggerOnQuoteLine_Handler.TriggerHandler(isDelete, Trigger.old);
     }
}