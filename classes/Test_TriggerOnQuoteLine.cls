/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Title           : Test_TriggerOnQuoteLine
Author          : Lister Technologies
Description     : Test Class
Trigger         : TriggerOnQuoteLine
Handler Class   : TriggerOnQuoteLine_handler
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */

@isTest
Private class Test_TriggerOnQuoteLine{

    static testMethod void myUnitTest(){
        Account acc = new Account(Name='Test Account',Website='test@test.com',Type='Customer',Status__c='Existing-Active',geo__c='APAC',Industry='Aerospace & Defense',CurrencyIsoCode='EUR');
        insert acc; 
        Contact contact = new Contact(AccountID=acc.Id, LastName='testcont1');
        insert contact;
        List<SBQQ__SolutionGroup__c> SolutionGps = new List<SBQQ__SolutionGroup__c>();
        SBQQ__SolutionGroup__c solutionGp1 = new SBQQ__SolutionGroup__c(Name='Subscription products');
        SolutionGps.add(solutionGp1);
        SBQQ__SolutionGroup__c solutionGp2 = new SBQQ__SolutionGroup__c(Name='Perpetual Products');
        SolutionGps.add(solutionGp2);
        SBQQ__SolutionGroup__c solutionGp3 = new SBQQ__SolutionGroup__c(Name='Services Products');
        SolutionGps.add(solutionGp3);
        
        insert SolutionGps;
        
        Product2 Prod = new Product2(Name = 'Test product',ProductCode='TCONN_PERP_SUB_SUPP_SERV_PACKAGE',family='Perpetual');
        insert Prod;
        Product2 Prod2 = new Product2(Name = 'Test product2',ProductCode='TCONN_PERP_SUB_SUPP_SERV_PACKAGE',family='Maintenance');
        insert Prod2;
        PricebookEntry pcBook = new PricebookEntry (Pricebook2Id= Test.getstandardPricebookid(),Product2Id =Prod.Id,unitPrice=10);
        insert pcBook;
        
        Opportunity opp = new Opportunity(Name='Test opp',AccountId=acc.Id,Annual_contract_value__c=1000,Type='Existing customer',CloseDate=date.today(),StageName='5 Negotiation/Closing',Amount=0.00,CurrencyIsoCode='EUR');
        insert opp;
        
        List<SBQQ__Quote__c> Quotes = new List<SBQQ__Quote__c>();
        List<SBQQ__QuoteLine__c > quotelines= new List<SBQQ__QuoteLine__c >();
        
        SBQQ__Quote__c quo1 = new SBQQ__Quote__c(SBQQ__PrimaryContact__c=contact.Id,Reference_Agreement_Number__c='123',SBQQ__Opportunity2__c=opp.Id,Legal_Notes__c='Legal Notes',Country__c='Australia',Order_Number__c='123',SBQQ__Primary__c=false, Year__c='24 months');
        Quotes.add(quo1);
        SBQQ__Quote__c quo2 = new SBQQ__Quote__c(SBQQ__PrimaryContact__c=contact.Id,Reference_Agreement_Number__c='12',SBQQ__Opportunity2__c=opp.Id,Legal_Notes__c='Legal Notes',Country__c='Australia',Order_Number__c='123',Year__c='24 months');
        Quotes.add(quo2);
        SBQQ__Quote__c quo3 = new SBQQ__Quote__c(SBQQ__PrimaryContact__c=contact.Id,Reference_Agreement_Number__c='12',SBQQ__Opportunity2__c=opp.Id,Legal_Notes__c='Legal Notes',Country__c='Australia',Order_Number__c='123',Year__c='36 months');
        Quotes.add(quo3);
        test.startTest();
        Insert Quotes;
        //insert quo1;
        
        SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quo1.id,SBQQ__Product__c=Prod.id,SBQQ__RegularPrice__c=0);
        insert ql;
        test.stopTest();
        quo1.SBQQ__primary__c =true;
        update quo1;
        
        delete ql;
    }
    static testMethod void myUnitTest2(){
        Account acc = new Account(Name='Test Account',Website='test@test.com',Type='Customer',Status__c='Existing-Active',geo__c='APAC',Industry='Aerospace & Defense',CurrencyIsoCode='EUR');
        insert acc; 
        Contact contact = new Contact(AccountID=acc.Id, LastName='testcont1');
        insert contact;
        List<SBQQ__SolutionGroup__c> SolutionGps = new List<SBQQ__SolutionGroup__c>();
        SBQQ__SolutionGroup__c solutionGp1 = new SBQQ__SolutionGroup__c(Name='Subscription products');
        SolutionGps.add(solutionGp1);
        SBQQ__SolutionGroup__c solutionGp2 = new SBQQ__SolutionGroup__c(Name='Perpetual Products');
        SolutionGps.add(solutionGp2);
        SBQQ__SolutionGroup__c solutionGp3 = new SBQQ__SolutionGroup__c(Name='Services Products');
        SolutionGps.add(solutionGp3);
        
        insert SolutionGps;
        
        Product2 Prod = new Product2(Name = 'Test product',ProductCode='TCONN_PERP_SUB_SUPP_SERV_PACKAGE',family='Perpetual');
        insert Prod;
        Product2 Prod2 = new Product2(Name = 'Test product2',ProductCode='TCONN_PERP_SUB_SUPP_SERV_PACKAGE',family='Maintenance');
        insert Prod2;
        PricebookEntry pcBook = new PricebookEntry (Pricebook2Id= Test.getstandardPricebookid(),Product2Id =Prod.Id,unitPrice=10);
        insert pcBook;
        
        Opportunity opp = new Opportunity(Name='Test opp',AccountId=acc.Id,Annual_contract_value__c=1000,Type='Existing customer',CloseDate=date.today(),StageName='5 Negotiation/Closing',Amount=0.00,CurrencyIsoCode='EUR');
        insert opp;
        
        List<SBQQ__Quote__c> Quotes = new List<SBQQ__Quote__c>();
        List<SBQQ__QuoteLine__c > quotelines= new List<SBQQ__QuoteLine__c >();
        
        SBQQ__Quote__c quo1 = new SBQQ__Quote__c(SBQQ__PrimaryContact__c=contact.Id,Reference_Agreement_Number__c='123',SBQQ__Opportunity2__c=opp.Id,Legal_Notes__c='Legal Notes',Country__c='Australia',Order_Number__c='123',SBQQ__Primary__c=true, Year__c='24 months');
        Quotes.add(quo1);
        SBQQ__Quote__c quo2 = new SBQQ__Quote__c(SBQQ__PrimaryContact__c=contact.Id,Reference_Agreement_Number__c='12',SBQQ__Opportunity2__c=opp.Id,Legal_Notes__c='Legal Notes',Country__c='Australia',Order_Number__c='123',Year__c='24 months');
        Quotes.add(quo2);
        SBQQ__Quote__c quo3 = new SBQQ__Quote__c(SBQQ__PrimaryContact__c=contact.Id,Reference_Agreement_Number__c='12',SBQQ__Opportunity2__c=opp.Id,Legal_Notes__c='Legal Notes',Country__c='Australia',Order_Number__c='123',Year__c='36 months');
        Quotes.add(quo3);
        test.startTest();
        Insert Quotes;
        //insert quo1;
        
        SBQQ__QuoteLine__c ql = new SBQQ__QuoteLine__c(SBQQ__Quote__c=quo1.id,SBQQ__Product__c=Prod.id,SBQQ__RegularPrice__c=0);
        insert ql;
        test.stopTest();
        quo1.SBQQ__primary__c =true;
        update quo1;
        
        delete ql;
    }
}