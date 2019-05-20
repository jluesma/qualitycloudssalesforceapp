/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Title           : Test_Trg_Opportunity 
Author          : Lister Technologies
Description     : Test Class
Trigger         : Trg_Opportunity
Handler Class   : Opportunitytriggerhandler
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
@isTest(seealldata=true)
private class Test_Trg_Opportunity {

    static testMethod void myUnitTest() {
        
        Account acc = new Account(Name='Test Account',Website='test@test.com',Type='Customer',Status__c='Existing-Active',geo__c='EMEA',Industry='Aerospace & Defense',CurrencyIsoCode='EUR');
        insert acc;    
        
        Contact con = new Contact(AccountId=acc.id,lastname='Test contact');
        insert con;                   
        
        Opportunity opp = new Opportunity(Name='Test opp',AccountId=acc.Id,Annual_contract_value__c=1000,Type='Existing customer',CloseDate=date.today(),StageName='5 Negotiation/Closing',Amount=0.00,CurrencyIsoCode='EUR');
        insert opp;
        
        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=opp.Id,ContactId=con.Id,role='Business User');
        insert ocr;
        
        quote quo = new quote(Name='Test quote',OpportunityId=opp.Id);
        insert quo;
        
        opp.StageName = '6 Closed/Won';
        opp.Tri_Close_Reason__c='Won on Price';
        update opp;
        
    }
}