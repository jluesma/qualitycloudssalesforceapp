@isTest
private class test_trgLeadHandler
{
   public static testMethod void testMethod1()
   {
        Account newAcc = new Account(name = 'Lister Tech', website = 'www.listertechnologies.com', CurrencyIsoCode='GBP', Tier__c = 'Tier 1', Type='Customer', Status__c = 'Prospect', Geo__c = 'APAC', Industry='Banking', Email__c = 'listertechnologies.com');
        insert newAcc;

        Lead newLead = new Lead(LastName = 'Test lead', Company = 'Lister Tech', Email = 'testlead@listertechnologies.com', Status ='Contacted', CurrencyIsoCode = 'GBP');
        insert newLead;
   }
   
   public static testMethod void testMethod2()
   {
        Account newAcc = new Account(name = 'Lister Tech', website = 'www.listertechnologies.com', CurrencyIsoCode='GBP', Tier__c = 'Tier 1', Type='Customer', Status__c = 'Prospect', Geo__c = 'APAC', Industry='Banking', Email__c = 'listertechnologies.com');
        insert newAcc;
        
        Account newAcc2 = new Account(name = 'LT', website = 'www.lt.com', CurrencyIsoCode='GBP', Tier__c = 'Tier 2', Type='Customer', Status__c = 'Prospect', Geo__c = 'APAC', Industry='Banking', Email__c = 'lt.com');
        insert newAcc2;

        Lead newLead = new Lead(LastName = 'Test lead', Company = 'Lister Tech', Email = 'testlead@listertechnologies.com', Status ='Contacted', CurrencyIsoCode = 'GBP');
        insert newLead;
        
        newLead.Email = 'testlead@lt.com';
        update newLead;
   }
   
   public static testMethod void testMethod3()
   {
       Lead newLead = new Lead(LastName = 'Test lead', Company = 'Lister Tech', Email = 'testlead@listertechnologies.com', Status ='Contacted', CurrencyIsoCode = 'GBP');
        insert newLead;
   }
   
   public static testMethod void testMethod4()
   {
        Account newAcc = new Account(name = 'Lister Tech', website = 'www.listertechnologies.com', CurrencyIsoCode='GBP', Tier__c = 'Tier 1', Type='Customer', Status__c = 'Prospect', Geo__c = 'APAC', Industry='Banking', Email__c = 'listertechnologies.com');
        insert newAcc;
        
        Lead newLead = new Lead(LastName = 'Test lead', Company = 'Lister Tech', Email = 'testlead@listertechnologies.com', Status ='Contacted', CurrencyIsoCode = 'GBP');
        insert newLead;
        
        newLead.Email = 'testlead@lt.com';
        update newLead;
   }
}