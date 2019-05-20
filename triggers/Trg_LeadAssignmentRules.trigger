trigger Trg_LeadAssignmentRules on Lead (after update) {
    SynchSettings__c settings = SynchSettings__c.getInstance();
    if(settings == null || settings.IntegrationUser__c == null || settings.IntegrationUser__c.length() < 15 || String.valueOf(UserInfo.getUserId()).substring(0, 15) != settings.IntegrationUser__c.substring(0, 15))
        if (ReassignLeads.futureMethodAlreadyCalled == FALSE/* && !SnowInboundForSnowUsers.isSynchProcessDone*/){
            Set<Id> leadIds=new Set<Id>();
            for(Lead l:trigger.new){
                leadIds.add(l.id);    
            }//for
            
            if(!system.isbatch())
            {
                ReassignLeads.reassignLeads(leadIds);
            }
        }//if
    
}