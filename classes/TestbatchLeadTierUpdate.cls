@istest
public class TestbatchLeadTierUpdate
{
    @istest static void Tiersuccesscase()
    {
    
        
        Account acct=new Account(Name='AccTest1',Website='www.roundberry.com',Email__c='roundberry.com',CurrencyIsoCode='USD',Tier__c='Tier 3',Type='Customer',
                                Status__c='Prospect',geo__c='EMEA',Industry='Electronics');

                                insert acct;    
                                
        Lead ld=new Lead(Company='LDTest1',LastName='LDTest9001',Email='LDtest1@roundberry.com',Status='Open',CurrencyIsoCode='USD');
        
            insert ld;
            
            ld.tier__c=null;
            update ld;
        
  Test.startTest();
        batchLeadTierUpdate b = new batchLeadTierUpdate();
Database.executebatch(b,50);
        Test.stopTest();    
            
       Lead leadupdated=[select Tier__c from Lead where ID=:ld.Id];     
     System.assertEquals(acct.Tier__c, leadupdated.Tier__c); 
    
    }
      @istest static void MultipleAccount()
    {

        
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
            
            ld.tier__c=null;
            update ld;
            Test.startTest();
        batchLeadTierUpdate b = new batchLeadTierUpdate();
Database.executebatch(b,50);
        Test.stopTest();    
        
       Lead leadupdated=[select Tier__c from Lead where ID=:ld.Id];       
    // System.assertEquals('Multiple Accounts', leadupdated.Tier__c); 
   
    }
       @istest static void ParentAccount()
    {
    
        
       
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
            
             ld.tier__c=null;
            update ld;
            
     Test.startTest();   
     SchedulebatchLeadTierUpdate sh1 = new SchedulebatchLeadTierUpdate ();      
     String sch = '0 0 8 15 12 ?';
       system.schedule('Test', sch, sh1);
     
     Test.stopTest();
        Lead leadupdated=[select Tier__c from Lead where ID=:ld.Id];           
   //  System.assertEquals(acct.Tier__c, leadupdated.Tier__c); 
    
    }
    
    
}