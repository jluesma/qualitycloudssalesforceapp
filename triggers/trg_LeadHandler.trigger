trigger trg_LeadHandler on Lead (before Insert, before Update){
    Map<String, Account> mapDomainAccount = new Map<String, Account>();
    for(Account acc: [Select Id, Email__c, Tier__c,  Name from Account]){
        mapDomainAccount.put(acc.Email__c, acc);
    }
    if(Trigger.isInsert && Trigger.isBefore){
        for(Lead leadInsrt : trigger.New){
            string emailInsert = leadInsrt.Email;
            string emailSubStrin = emailInsert.substringAfter('@'); 
            if(mapDomainAccount.containsKey(emailSubStrin)){
                leadInsrt.Tier__c = mapDomainAccount.get(emailSubStrin).Tier__c;
            }
            else if(!mapDomainAccount.containsKey(emailSubStrin)){
                leadInsrt.Tier__c = 'NA';
            }
        }
    }
    if(Trigger.isUpdate && Trigger.isBefore){
        for(Id LeadId : Trigger.newMap.keySet())
        {
          if(Trigger.oldMap.get(LeadId).Email != Trigger.newMap.get(LeadId).Email)
          {
            string emailInsert = Trigger.newMap.get(LeadId).Email;
            string emailSubStrin = emailInsert.substringAfter('@'); 
            if(mapDomainAccount.containsKey(emailSubStrin)){
                Trigger.newMap.get(LeadId).Tier__c = mapDomainAccount.get(emailSubStrin).Tier__c;
            }
            else if(!mapDomainAccount.containsKey(emailSubStrin)){
                Trigger.newMap.get(LeadId).Tier__c = 'NA';
            }
         }
       }
    }
}