/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Title           : Test_AutoLeadConversionBatch
Author          : Lister Technologies
Description     : Test Class
Test Class      : AutoLeadConversionBatch
Schedule Class  : Schedule_AutoLeadConversionBatch
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
@istest
public class Test_AutoLeadConversionBatch {
    static testMethod void unittest1(){
        Lead ld1 = new Lead(Company='Test Acc',lastname='Test Last',Email='test@test12345.com',Status='Open',CurrencyIsoCode='EUR',dr_funnel__c='MQL');
        insert ld1;
        
        Lead ld2 = new Lead(Company='Test Acc',lastname='Test Last',Email='test1@test12345.com',Status='Open',CurrencyIsoCode='EUR',dr_funnel__c='MQL');
        insert ld2;
        
        Lead ld3 = new Lead(Company='Test Acc',lastname='Test Last',Email='test1@test3.com',Status='Open',CurrencyIsoCode='EUR',dr_funnel__c='MQL');
        insert ld3;
        
        Account acc1 = new Account(Name='TestAccount',Email__c='test12345.com',Website='testwebsite.com',Type='Customer',CurrencyIsoCode='EUR',Status__c='Prospect',geo__c='APAC',Industry='Electronic');
        insert acc1;
        
        Account acc2 = new Account(Name='TestAccount2',Email__c='test3.com',Website='testwebsite.com',Type='Customer',CurrencyIsoCode='EUR',Status__c='Prospect',geo__c='APAC',Industry='Electronic');
        insert acc2;
        
        Contact con1 = new Contact(lastname='Testlast',AccountId=acc1.Id,Email='test@test123456.com',Geo__c='APAC',contact_status__c='Solar flare');
        insert con1;
        
        Opportunity opp1 = new Opportunity(Name='TestOpp',Annual_contract_value__c=100,AccountId=acc1.Id,StageName='5 Negotiation/Closing',CloseDate=date.today());
        insert opp1;        
        
        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=opp1.Id,ContactId=con1.Id,role='Business User');
        insert ocr;
        
        quote quo = new quote(Name='Test quote',OpportunityId=opp1.Id);
        insert quo;
        
        Test.startTest();
        Schedule_AutoLeadConversionBatch salcb = new Schedule_AutoLeadConversionBatch();             
         // Schedule the test job
         string sch='0 0 12 * * ?'; 
         String jobId = system.schedule('test',sch,salcb);
        Test.stopTest();
    }
}