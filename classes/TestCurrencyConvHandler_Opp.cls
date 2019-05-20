@isTest
public class TestCurrencyConvHandler_Opp {
 public static testmethod void acvCurrencyConversion(){
        
        List<Opportunity> oppList = new List<Opportunity>();
        List<Opportunity> oppUpdateList = new List<Opportunity>();
        List<Opportunity> oppResultList = new List<Opportunity>();
        Account acc = new Account();
        acc.Name = 'LK Test Solutions';
        acc.Type = 'Customer';
        acc.Website = 'www.lksoln.com';
        acc.CurrencyIsoCode = 'EUR';
        acc.Status__c='Existing-Active';
        acc.geo__c='APAC';
        acc.Industry='Electronics';
        insert acc;
        
        Opportunity opp = new Opportunity();
        opp.Name='Test1';
        opp.License_Type__c = 'Perpetual';
        opp.Annual_contract_value__c = 300;
        opp.ACV_mgmt_commit_in_Euro__c = 400;
        opp.AccountId=acc.Id;
        opp.StageName='3 Evaluation';
        opp.type='Existing Customer';
        opp.CloseDate = Date.newInstance(2017, 09, 4);
        opp.LeadSource = 'MQL(Marketing Sourced)';
        opp.CurrencyIsoCode = 'AUD';
        opp.NextStep = 'Test';
        opp.isenable__c = true;
        oppList.add(opp);
        
        Opportunity opp1 = new Opportunity();
        opp1.Name='Test2';
        opp1.AccountId=acc.Id;
        opp.License_Type__c = 'Perpetual';
        opp.Annual_contract_value__c = 300;
        opp.ACV_mgmt_commit_in_Euro__c = 400;
        opp.isenable__c = true;
        opp.Tri_Close_Reason__c = 'Lost to Competitor';
        opp1.StageName='6 Closed/Won';
        opp1.type='Existing Customer';
        opp1.CloseDate = Date.newInstance(2017, 10, 1);
        opp1.LeadSource = 'MQL(Marketing Sourced)';
        opp1.CurrencyIsoCode = 'CHF';
        opp1.NextStep = 'Test';
        oppList.add(opp1);
        
        Opportunity opp2 = new Opportunity();
        opp2.Name='Test3';
        opp2.AccountId=acc.Id;
        opp.License_Type__c = 'Perpetual';
        opp.Annual_contract_value__c = 300;
        opp.ACV_mgmt_commit_in_Euro__c = 400;
        opp.isenable__c = true;
        opp2.StageName='6 Closed/Lost';
        opp2.Tri_Debrief_Comments__c = 'comments';
        opp2.Tri_Close_Reason__c = 'Lost to Competitor';
        opp2.type='Existing Customer';
        opp2.CloseDate = Date.newInstance(2017, 01, 3);
        opp2.LeadSource = 'MQL(Marketing Sourced)';
        opp2.CurrencyIsoCode = 'NZD';
        opp2.NextStep = 'Test';
        oppList.add(opp2);
        
        Opportunity opp3 = new Opportunity();
        opp3.Name='Test4';
        opp3.AccountId=acc.Id;
        opp3.StageName='3 Evaluation';
        opp3.type='Existing Customer';
        opp3.CloseDate = Date.newInstance(2017, 08, 26);
        opp3.LeadSource = 'MQL(Marketing Sourced)';
        opp3.CurrencyIsoCode = 'GBP';
        opp3.NextStep = 'Test';
        oppList.add(opp3);
            
        test.startTest();
        insert oppList;
        opp.LIC_FYM_mgmt_commit__c = 15;
        oppUpdateList.add(opp);
        opp1.LIC_FYM_mgmt_commit__c = 13;
        oppUpdateList.add(opp1);
        opp2.LIC_FYM_mgmt_commit__c = 14;
        oppUpdateList.add(opp2);
        opp3.LIC_FYM_mgmt_commit__c = 16;
        oppUpdateList.add(opp3);
        
        update oppUpdateList;
        List<Opportunity> opptyUpdateList = [Select CreatedDate,Id,CurrencyIsoCode,LIC_FYM_mgmt_commit__c,ACV_mgmt_commit_in_Euro__c from Opportunity where id in : oppUpdateList];
        CurrencyConversionHandler.handleCurrencyConversion(opptyUpdateList);
        
        oppResultList = [Select Name,ACV_mgmt_commit_in_Euro__c from Opportunity where id in : oppUpdateList];
        /*
        for(Opportunity oppResult:oppResultList){
            Decimal acv_value = oppResult.ACV_mgmt_commit_in_Euro__c;
            if(oppResult.Name=='Test1')
            system.assertEquals(10.07,acv_value.setscale(2));
            else if(oppResult.Name=='Test2')
                system.assertEquals(12.04,acv_value.setscale(2));
            else if(oppResult.Name=='Test3')
                system.assertEquals(8.97,acv_value.setscale(2));
            else if(oppResult.Name=='Test4')
                system.assertEquals(19.28,acv_value.setscale(2));
        } */
        test.stopTest(); 
        
    }
}