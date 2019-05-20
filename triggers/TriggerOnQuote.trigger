trigger TriggerOnQuote on SBQQ__Quote__c (before insert,after insert,before update,after update) {
    
    List<SBQQ__SolutionGroup__c> SolutionGroups = new List<SBQQ__SolutionGroup__c>();
    List<SBQQ__QuoteLineGroup__c> QuoteGroupingToBeInserted = new List<SBQQ__QuoteLineGroup__c>();
    SolutionGroups = [select id,Name from SBQQ__SolutionGroup__c where Name ='Subscription products' or Name ='Perpetual Products' or Name ='Services Products' ORDER BY Name ASC];
         
    if(Trigger.isInsert && Trigger.isBefore) {
        map<ID,ID> mapofquoteandopp = new map<ID,ID>();
       for(SBQQ__Quote__c Quotes : Trigger.new) {
            Quotes.SBQQ__LineItemsGrouped__c = true;
            if(Quotes.Legal_Notes__c != NULL)
                Quotes.Contains_Legal_Notes__c = true; 
           mapofquoteandopp.put(Quotes.Id,Quotes.SBQQ__Opportunity2__c);
        }
        map<Id,String> mapofoppandcurrency = new map<Id,String>();
        for(Opportunity opp: [Select Id,Name,CurrencyIsoCode from Opportunity where ID in : mapofquoteandopp.values()]){
            mapofoppandcurrency.put(opp.Id, opp.CurrencyIsoCode);
        }
        for(SBQQ__Quote__c Quotes : Trigger.new) {
            Quotes.CurrencyIsoCode = mapofoppandcurrency.get(Quotes.SBQQ__Opportunity2__c);
        }
      }
      
    if(Trigger.isInsert && Trigger.isAfter) {
        if(!SolutionGroups.isEmpty()){
            for(SBQQ__Quote__c Quote : Trigger.new) {
                QuoteGroupingToBeInserted.add(new SBQQ__QuoteLineGroup__c(SBQQ__Number__c=1, Name='Perpetual Product', SBQQ__Quote__c=Quote.id, SBQQ__SolutionGroup__c=SolutionGroups[0].id));
                QuoteGroupingToBeInserted.add(new SBQQ__QuoteLineGroup__c(SBQQ__Number__c=2, Name='Subscription product', SBQQ__Quote__c=Quote.id, SBQQ__SolutionGroup__c=SolutionGroups[1].id));
            QuoteGroupingToBeInserted.add(new SBQQ__QuoteLineGroup__c(SBQQ__Number__c=3, Name='Services Product', SBQQ__Quote__c=Quote.id, SBQQ__SolutionGroup__c=SolutionGroups[2].id));
           
            }
        }
        Insert QuoteGroupingToBeInserted;  
     }
    
     if(Trigger.isUpdate && Trigger.isBefore) {
        
       TriggerOnQuote_Handler.TriggerHandler_BeforeUpdate(Trigger.new);   
     }
    if(Trigger.isUpdate && Trigger.isAfter){
        TriggerOnQuote_Handler.triggerhandler_AfterUpdate(Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
}