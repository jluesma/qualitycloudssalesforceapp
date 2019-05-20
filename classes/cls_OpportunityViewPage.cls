public with sharing class cls_OpportunityViewPage
{
    
    public String domain{get;set;}
    public Boolean displayPopUp{get;set;}
    public Boolean isStartDatefilled{get;set;}
    public Opportunity currentOpp{get;set;}
    public Id oppid{get;set;}
    Date oldclosdate;
    public List<SBQQ__Quote__c> quoteList;
    public SBQQ__Quote__c quote{get;set;}
    
    public cls_OpportunityViewPage(ApexPages.StandardController stdController)
    {
        quote = new SBQQ__Quote__c();
        currentOpp = (Opportunity)stdController.getRecord();
        oppid = apexpages.currentpage().getparameters().get('Id');
        currentOpp = [select Id,stagename,closedate,isclosed__c from Opportunity where id =: oppid];
        oldclosdate = currentOpp.closedate;
        if(currentOpp.isclosed__c && (currentOpp.stagename == '6 Closed/Won' || currentOpp.stagename== '6 Closed/Lost'))
        displayPopUp = true;
        else
        displayPopUp = false;
        isStartDatefilled = false;
        system.debug('$$$ Display popup:' + displayPopUp);
        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.WARNING,'Please verify the close date before proceeding.Clicking on Cancel will retain old close date'));
    }
    public void SaveClosedate()
    {
        currentOpp.isclosed__c = false;
        quoteList = [select id,SBQQ__Status__c,SBQQ__Primary__c from SBQQ__Quote__c where SBQQ__Opportunity2__c =: oppid and SBQQ__Primary__c  = True];
        if(quoteList !=null && quoteList.size()>0)
        {   
            quote.id = quoteList[0].id; 
            Update quote;
        }
        Update currentOpp;
        displayPopUp = false;
    }
    public void closePopup()
    {
        currentOpp.closedate=oldclosdate; 
        currentOpp.isclosed__c = false;
        Update currentOpp;
        displayPopUp = false;
    }
}