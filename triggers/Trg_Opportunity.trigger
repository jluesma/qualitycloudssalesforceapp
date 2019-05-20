/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Title           : Trg_Opportunity
Author          : Lister Technologies
Description     : This is a trigger on opportunity for before update
Test Class      : 
Handler Class   : Opportunitytriggerhandler
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
trigger Trg_Opportunity on Opportunity (before update,after insert, before insert,after update) 
{
    //Code to handle currency update for currency convertion fields
    CurrencyConvHandler_Opp Cur_conv;
    List<Opportunity> modOpp;
    if(trigger.isBefore) {
        Cur_conv = new CurrencyConvHandler_Opp();
        if(trigger.isInsert)
        {
            CurrencyConvHandler_Opp.handleCurrencyConversion(trigger.new );
            
        }
        else
            if(trigger.isUpdate)
            {
                modOpp = new List<Opportunity>();
                for(Opportunity opp: trigger.new){
                    Opportunity oldOpp = Trigger.oldMap.get(opp.Id);
                    if((oldOpp.StageName != opp.StageName) || (oldOpp.Annual_contract_value__c != opp.Annual_contract_value__c) || 
                           (oldOpp.ACV_mgmt_commit_in_Euro__c != opp.ACV_mgmt_commit_in_Euro__c) || 
                          (oldOpp.ACV_in_Euro__c != opp.ACV_in_Euro__c) ||  (oldOpp.CurrencyIsoCode != opp.CurrencyIsoCode) || (oldOpp.isenable__c != opp.isenable__c && opp.isenable__c == true) || (oldOpp.License_Type__c != opp.License_Type__c) || (oldOpp.Subscription_Term__c != opp.Subscription_Term__c) || (oldOpp.Total_contract_value__c != opp.Total_contract_value__c) || (oldOpp.TCV__c != opp.TCV__c && opp.TCV__c == true))
                        
                        modOpp.add(opp);
                }   
                if(modOpp!= null && modOpp.size()>0)
                    CurrencyConvHandler_Opp.handleCurrencyConversion(modOpp);
        }
    }
    
    if(trigger.isUpdate && trigger.isBefore)
    {
        system.debug('Before Update'+Opportunitytriggerhandler.displayBooleanValue());
        try
        {
         Opportunitytriggerhandler.beforeUpdateLogic(trigger.new,trigger.old,trigger.newMap,trigger.oldMap);
        }
        Catch(Exception e)
        {
            trigger.new[0].addError('Updation not possible because '+ e.getMessage());
        } 
    }
    if(trigger.isInsert && trigger.isAfter)
    {
        system.debug('After Insert'+Opportunitytriggerhandler.displayBooleanValue());
        Opportunitytriggerhandler.stopUpdateOnInsert();
    }
    if(trigger.isUpdate && trigger.isAfter)
        Opportunitytriggerhandler.UpdateFirstWonOpportunity(trigger.new,trigger.oldMap);   
}