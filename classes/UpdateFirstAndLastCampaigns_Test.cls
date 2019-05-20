@isTest
public class UpdateFirstAndLastCampaigns_Test {

    public static testMethod void testIt () {
        Campaign campaign = new Campaign (Name = 'Test Campaign', dr_substantial_engagement__c = true);
        Database.SaveResult result = Database.Insert (campaign);
        Id campaignId = result.getId();
        Contact aContact = new Contact (LastName = 'Test Contact',MailingCountry = 'United States');
        result = Database.Insert (aContact);
        Id contactId = result.getId();
        Lead aLead = new Lead (LastName = 'Test Lead', Company = 'Test Company');
        result = Database.Insert (aLead);
        Id leadId = result.getId();
        
        CampaignMember leadMember = new CampaignMember (CampaignId = campaignId, LeadId = leadId, Status = 'Responded');
        insert (leadMember);

        CampaignMember contactMember = new CampaignMember (CampaignId = campaignId, ContactId = contactId, Status = 'Responded');
        insert (contactMember);
    }
}