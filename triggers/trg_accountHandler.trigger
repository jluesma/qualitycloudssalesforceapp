trigger trg_accountHandler on Account (after Update) {
    if(Trigger.isUpdate && Trigger.isAfter){
        for(Id AccId : Trigger.newMap.keySet())
        {
          if(Trigger.oldMap.get(AccId).Tier__c != Trigger.newMap.get(AccId).Tier__c)
          {
            string accEmail = '%' + Trigger.newMap.get(AccId).Email__c;
            List<Lead> listLead = new List<Lead>([select Id, Tier__c, Email from Lead where Email LIKE: accEmail]);
            for(Integer i=0; i<listLead.size(); i++){
                if(Trigger.newMap.get(AccId).Email__c != '' || Trigger.newMap.get(AccId).Email__c != null){
                    listLead[i].Tier__c = Trigger.newMap.get(AccId).Tier__c;
                }
                else{
                    listLead[i].Tier__c = 'No Account';
                }
            }
            update listLead;
          }
          if(Trigger.oldMap.get(AccId).Email__c != Trigger.newMap.get(AccId).Email__c)
          {
          string accEmail ='';
            if(Trigger.oldMap.get(AccId).Email__c != '' && Trigger.oldMap.get(AccId).Email__c!= null)
            {
                accEmail = '%' + Trigger.oldMap.get(AccId).Email__c;
            }
            else
            {
                accEmail = '%' + Trigger.newMap.get(AccId).Email__c;
            }
            List<Lead> listLead = new List<Lead>([select Id, Tier__c, Email from Lead where Email LIKE: accEmail]);
            for(Integer i=0; i<listLead.size(); i++){
                if(Trigger.newMap.get(AccId).Email__c != '' && Trigger.newMap.get(AccId).Email__c != null){
                    listLead[i].Tier__c = Trigger.newMap.get(AccId).Tier__c;
                }
                else{
                    listLead[i].Tier__c = 'No Account';
                }
            }
            update listLead;
          }
        }
    }
}