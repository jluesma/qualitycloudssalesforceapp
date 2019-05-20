global class OpportunityNotificationsScheduler implements Schedulable {
    global void execute(SchedulableContext sc) {
        List<Opportunity> keyOpps = new List<Opportunity>([select id, name, description, Age__c, StageName, Annual_contract_value__c, OwnerId, AccountId, Account.Name, CloseDate, CreatedDate, OpportunityId18digit__c, Account.AccountId18digit__c, Owner.Isactive
                                                           from Opportunity where 
                                                          ((Age__c > 3 and StageName = '0 Active (SQL)' and Annual_contract_value__c > 0) or
                                                          ((StageName = '1 Prospecting (Discovering/Identifying)' or StageName = '2 Qualification' or StageName = '3 Evaluation') and Annual_contract_value__c > 0) or
                                                          (StageName != '6 Closed/Won' and StageName != '6 Closed/Lost' and StageName != '6 Closed/Pending' and Annual_contract_value__c > 0 and CloseDate < :system.today()) or
                                                          (CloseDate > :system.today() and CloseDate < :system.today().addDays(7) and (StageName = '4 Proposal' or StageName = '5 Negotiation/Closing') and Annual_contract_value__c > 0)
                                                          ) and Owner.Isactive = true]);
        
        OpportunityNotifications.NotifyOwner(keyOpps);
    }
}