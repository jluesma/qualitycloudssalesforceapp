trigger trg_Lead on Lead (before insert,before update) {

    SynchSettings__c settings = SynchSettings__c.getInstance();
    if(settings == null || settings.IntegrationUser__c == null || settings.IntegrationUser__c.length() < 15 || String.valueOf(UserInfo.getUserId()).substring(0, 15) != settings.IntegrationUser__c.substring(0, 15)){
        Handler_trgLead TrgHandler=new Handler_trgLead();
        
        if((Trigger.isInsert||Trigger.isUpdate)&&(Trigger.isBefore))
        {
            
            
            TrgHandler.UpdateTierValues(Trigger.new,Trigger.oldmap);
            
        }    
    }
}