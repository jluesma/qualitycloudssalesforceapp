@isTest
public class Test_cls_OpportunityViewPage {
    static testMethod void unittest(){
        Account acc = new Account(Name='Test Account');
        insert acc;
        Contact con = new Contact(lastname='Testlast',AccountId=acc.Id,Email='test@test1.com',Geo__c='APAC',contact_status__c='Solar flare');
        insert con;
        Opportunity opp = new Opportunity(Name='Test opp',AccountId=acc.Id,Annual_contract_value__c=1000 ,StageName='6 Closed/Won',CloseDate=date.today(),Tri_Close_Reason__c='Won on Price');
        insert opp;
        OpportunityContactRole ocr = new OpportunityContactRole(OpportunityId=opp.Id,ContactId=con.Id,role='Business User');
        insert ocr;        
        quote quo = new quote(Name='Test quote',OpportunityId=opp.Id);
        insert quo;
        
        PageReference pg = Page.OpportunityViewPage;
        Test.setCurrentPage(pg);
        
        ApexPages.currentPage().getParameters().put('Id', opp.id);
        
        ApexPages.StandardController sc = new ApexPages.StandardController(opp);                                
        cls_OpportunityViewPage controller = new cls_OpportunityViewPage(sc);
        controller.SaveClosedate();
        controller.closePopup();
    }
}