@isTest
private class test_trgAccHandler
{
   public static testMethod void testMethod1()
   {
        Account newAcc = new Account(name = 'Lister Tech', website = 'www.listertechnologies.com', CurrencyIsoCode='GBP', Tier__c = 'Tier 1', Type='Customer', Status__c = 'Prospect', Geo__c = 'APAC', Industry='Banking', Email__c = 'listertechnologies.com');
        insert newAcc;

        Lead newLead = new Lead(LastName = 'Test lead', Company = 'Lister Tech', Email = 'testlead@listertechnologies.com', Status ='Contacted', CurrencyIsoCode = 'GBP');
        insert newLead;
        
        newAcc.Tier__c = 'Tier 2';
        update newAcc;
   }
   
   public static testMethod void testMethod2()
   {
        Account newAcc = new Account(name = 'Lister Tech', website = 'www.listertechnologies.com', CurrencyIsoCode='GBP', Tier__c = 'Tier 1', Type='Customer', Status__c = 'Prospect', Geo__c = 'APAC', Industry='Banking', Email__c = 'listertechnologies.com');
        insert newAcc;
        
        Lead newLead = new Lead(LastName = 'Test lead', Company = 'Lister Tech', Email = 'testlead@listertechnologies.com', Status ='Contacted', CurrencyIsoCode = 'GBP');
        insert newLead;
        
        newAcc.Email__c = 'lt.com';
        update newAcc;
   }
}