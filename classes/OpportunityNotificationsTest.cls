@isTest
public class OpportunityNotificationsTest {

    public static testMethod void testAll() {
        Account acc = new Account(Name = 'first', Status__c = 'Existing-Active', Industry = 'Banking', Website = 'www.aa.bb');
        insert acc;
        
        Opportunity opp1 = new Opportunity(AccountId = acc.id, Name = 'opp1', Type = 'Existing customer', CloseDate = system.today().addMonths(1), stageName = '0 Active (SQL)', NextStep = 'x', LeadSource = 'Banner');
        Opportunity opp2 = new Opportunity(AccountId = acc.id, Name = 'opp2', Type = 'Existing customer', CloseDate = system.today().addDays(10), stageName = '2 Qualification', NextStep = 'x', LeadSource = 'Banner', Annual_contract_value__c = 1);
        Opportunity opp3 = new Opportunity(AccountId = acc.id, Name = 'opp3', Type = 'Existing customer', CloseDate = system.today().addMonths(-1), stageName = '2 Qualification', NextStep = 'x', LeadSource = 'Banner', Annual_contract_value__c = 2);
        Opportunity opp4 = new Opportunity(AccountId = acc.id, Name = 'opp4', Type = 'Existing customer', CloseDate = system.today().addDays(1), stageName = '5 Negotiation/Closing', NextStep = 'x', LeadSource = 'Banner', Annual_contract_value__c = 2);
        insert new List<Opportunity> {opp1, opp2, opp3, opp4};
        
        Test.setCreatedDate(opp1.id, system.today().addYears(-1));
        Test.setCreatedDate(opp2.id, system.today().addYears(-1));
        Test.setCreatedDate(opp3.id, system.today().addYears(-1));
        Test.setCreatedDate(opp4.id, system.today().addYears(-1));
        opp3.CloseDate = system.today().addMonths(-1);
        update opp3;
        
        test.startTest();
        List<Opportunity> opps = [select id, description, Age__c, StageName, Annual_contract_value__c, OwnerId, name from opportunity];
        OpportunityNotificationsScheduler m2 = new OpportunityNotificationsScheduler();
        m2.execute(null);
        test.stopTest();
    }
}