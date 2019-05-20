@istest
public class Testtrg_Lead
{
    @istest static void Tiersuccesscase()
    {
    Test.startTest();
        
        Account acct=new Account(Name='AccTest1',Website='www.roundberry.com',Email__c='roundberry.com',CurrencyIsoCode='USD',Tier__c='Tier 3',Type='Customer',
                                Status__c='Prospect',geo__c='EMEA',Industry='Electronics');

                                insert acct;    
                                
        Lead ld=new Lead(Company='LDTest1',LastName='LDTest9001',Email='LDtest1@roundberry.com',Status='Open',CurrencyIsoCode='USD');
        
            insert ld;
       Lead leadupdated=[select Tier__c from Lead where ID=:ld.Id];     
     System.assertEquals(acct.Tier__c, leadupdated.Tier__c); 
    Test.stopTest();
    }
     @istest static void NoAccountcase()
    {
    Test.startTest();
        
        Account acct=new Account(Name='AccTest2',Website='www.abc.com',Email__c='abc.com',CurrencyIsoCode='USD',Tier__c='Tier 3',Type='Customer',
                                Status__c='Prospect',geo__c='EMEA',Industry='Electronics');

                                insert acct;    
                                
        Lead ld=new Lead(Company='LDTest2',LastName='LDTest2',Email='LDTest2@xyz.com',Status='Open',CurrencyIsoCode='USD');
        
            insert ld;
             
       Lead leadupdated=[select Tier__c from Lead where ID=:ld.Id];
     System.assertEquals('No Account', leadupdated.Tier__c); 
    Test.stopTest();
    }
      @istest static void NoTiercase()
    {
    Test.startTest();
        
        Account acct=new Account(Name='AccTest3',Website='www.abc.com',Email__c='abc.com',CurrencyIsoCode='USD',Tier__c='',Type='Customer',
                                Status__c='Prospect',geo__c='EMEA',Industry='Electronics');

                                insert acct;    
                                
        Lead ld=new Lead(Company='LDTest3',LastName='LDTest3',Email='LDTest3@abc.com',Status='Open',CurrencyIsoCode='USD');
        
            insert ld;
       
        Lead leadupdated=[select Tier__c from Lead where ID=:ld.Id];
     System.assertEquals('No Tier', leadupdated.Tier__c); 
    Test.stopTest();
    }
     @istest static void MultipleAccount()
    {
    Test.startTest();
        
        Account acct=new Account();
        acct.Name='AccTest3';
        acct.Website='www.abc.com';
        acct.Email__c='abc.com';
        acct.CurrencyIsoCode='USD';
        acct.Tier__c='Tier 1';
        acct.Type='Customer';
        acct.Status__c='Prospect';
        acct.geo__c='EMEA';
        acct.Industry='Electronics';
        insert acct;    
        
        Account acct1=new Account();
         acct1.Name='AccTest4';
        acct1.Website='www.abc.com';
        acct1.Email__c='abc.com';
        acct1.CurrencyIsoCode='USD';
        acct1.Tier__c='Tier 2';
        acct1.Type='Customer';
        acct1.Status__c='Prospect';
        acct1.geo__c='EMEA';
        acct1.Industry='Electronics';
        insert acct1;    
                
                                
        Lead ld=new Lead(Company='LDTest3',LastName='LDTest3',Email='LDTest3@abc.com',Status='Open',CurrencyIsoCode='USD');
        
            insert ld;
        
       Lead leadupdated=[select Tier__c from Lead where ID=:ld.Id];       
     System.assertEquals('Multiple Accounts', leadupdated.Tier__c); 
    Test.stopTest();
    }
      @istest static void ParentAccount()
    {
    Test.startTest();
        
       
        Account acct=new Account();
        acct.Name='AccTest3';
        acct.Website='www.abc.com';
        acct.Email__c='abc.com';
        acct.CurrencyIsoCode='USD';
        acct.Tier__c='Tier 1';
        acct.Type='Customer';
        acct.Status__c='Prospect';
        acct.geo__c='EMEA';
        acct.Industry='Electronics';
        insert acct;    
        
        Account acct1=new Account();
         acct1.Name='AccTest4';
        acct1.ParentID=acct.id;
        acct1.Website='www.abc.com';
        acct1.Email__c='abc.com';
        acct1.CurrencyIsoCode='USD';
        acct1.Tier__c='Tier 2';
        acct1.Type='Customer';
        acct1.Status__c='Prospect';
        acct1.geo__c='EMEA';
        acct1.Industry='Electronics';
        insert acct1;    
                
                                
        Lead ld=new Lead(Company='LDTest3',LastName='LDTest3',Email='LDTest3@abc.com',Status='Open',CurrencyIsoCode='USD');
        
            insert ld;
        
        Lead leadupdated=[select Tier__c from Lead where ID=:ld.Id];           
     System.assertEquals(acct.Tier__c, leadupdated.Tier__c); 
    Test.stopTest();
    }
       @istest static void ParentAccountwithNullTier()
    {
    Test.startTest();
        
       
        Account acct=new Account();
        acct.Name='AccTest3';
        acct.Website='www.abc.com';
        acct.Email__c='abc.com';
        acct.CurrencyIsoCode='USD';
        acct.Tier__c=null;
        acct.Type='Customer';
        acct.Status__c='Prospect';
        acct.geo__c='EMEA';
        acct.Industry='Electronics';
        insert acct;    
        
        Account acct1=new Account();
         acct1.Name='AccTest4';
        acct1.ParentID=acct.id;
        acct1.Website='www.abc.com';
        acct1.Email__c='abc.com';
        acct1.CurrencyIsoCode='USD';
        acct1.Tier__c='Tier 2';
        acct1.Type='Customer';
        acct1.Status__c='Prospect';
        acct1.geo__c='EMEA';
        acct1.Industry='Electronics';
        insert acct1;    
                
                              
        Lead ld=new Lead(Company='LDTest3',LastName='LDTest3',Email='LDTest3@abc.com',Status='Open',CurrencyIsoCode='USD');
        
            insert ld;
         Lead leadupdated=[select Tier__c from Lead where ID=:ld.Id];      
    // System.assertEquals('No Tier', leadupdated.Tier__c); 
    Test.stopTest();
    }
    
   
}