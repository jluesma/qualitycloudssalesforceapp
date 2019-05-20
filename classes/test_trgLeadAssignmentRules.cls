@isTest
private class test_trgLeadAssignmentRules {
    public static testmethod void testmethod1()
    {
        Lead newLead = new Lead(LastName = 'Test lead', Company = 'Lister Tech', Email = 'testlead@listertechnologies.com', Status ='Contacted', CurrencyIsoCode = 'GBP',Reassign__c=True);
        insert newLead;       
    }

}