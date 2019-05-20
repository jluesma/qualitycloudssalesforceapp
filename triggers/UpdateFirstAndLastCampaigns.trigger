trigger UpdateFirstAndLastCampaigns on CampaignMember (after insert) {
    // First, compute the campaign counts for each given lead or contact. Use just one query - this is a bulkified trigger.
    List<Id> leadIds = new List<Id>();
    List<Id> contactIds = new List<Id>();
    List<Id> cmIds = new List<Id>();
    for (CampaignMember cm: Trigger.new) {
        cmIds.add (cm.Id);
        if (cm.LeadId != null) {
            leadIds.add (cm.LeadId);
        } else if (cm.ContactId != null) {
            contactIds.add (cm.ContactId);
        }
    }
    Map<Id,Integer> campaignCounts = new Map<Id,Integer>();
    AggregateResult[] counts = [select count(Id) cCount, LeadId from CampaignMember where Campaign.dr_substantial_engagement__c = true and Campaign.dr_parent_campaign__c = false and HasResponded = true and LeadId in :leadIds group by LeadId];
    for (AggregateResult ar: counts) {
        campaignCounts.put ((Id) ar.get ('LeadId'), (Integer) ar.get ('cCount'));
    }
    counts = [select count(Id) cCount, ContactId from CampaignMember where Campaign.dr_substantial_engagement__c = true and Campaign.dr_parent_campaign__c = false and HasResponded = true and ContactId in :contactIds group by ContactId];
    for (AggregateResult ar: counts) {
        campaignCounts.put ((Id) ar.get ('ContactId'), (Integer) ar.get ('cCount'));
    }
//     AggregateResult[] counts = [select count(Id) cCount, LeadId, ContactId from CampaignMember where Campaign.dr_substantial_engagement__c = true and Campaign.dr_parent_campaign__c = false and HasResponded = true and (LeadId in :leadIds or ContactId in :contactIds) group by LeadId,ContactId];
//     for (AggregateResult ar: counts) {
//         if (ar.get ('LeadId') != null) {
//             campaignCounts.put ((Id) ar.get ('LeadId'), (Integer) ar.get ('cCount'));
//         } else if (ar.get ('ContactId') != null) {
//             campaignCounts.put ((Id) ar.get ('ContactId'), (Integer) ar.get ('cCount'));
//         }
//     }
    // Figure out the CampaignMember records that correspond to Substantial Engagement campaigns
    Map<Id, CampaignMember> matches = new Map<Id, CampaignMember>([select Id, CampaignId from CampaignMember where Campaign.dr_substantial_engagement__c = true and Campaign.dr_parent_campaign__c = false and HasResponded = true and Id in :cmIds]);
    List<Lead> leadsToUpdate = new List<Lead>();
    List<Contact> contactsToUpdate = new List<Contact>();
    for (CampaignMember cm: Trigger.new) {
        if (!matches.containsKey (cm.Id)) {
            continue; // This Campaign Member is not that of a Substantial Engagement campaign
        }
        if (cm.ContactId != null) {
            Contact aContact = new Contact (Id = cm.ContactId, dr_last_campaign_tracking__c = cm.CampaignId);
            Integer cnt = campaignCounts.get (cm.ContactId);
            if (cnt == 1) {
                aContact.dr_first_campaign_tracking__c = cm.CampaignId;
            }
            aContact.dr_number_of_campaigns__c = cnt;
            contactsToUpdate.add (aContact);
        } else if (cm.LeadId != null) {
            Integer cnt = campaignCounts.get (cm.LeadId);
            if (cnt > 0) {
                Lead aLead = new Lead (Id = cm.LeadId, dr_last_campaign_tracking__c = cm.CampaignId);
                aLead.dr_last_campaign_tracking_contact__c = cm.CampaignId;
                if (cnt == 1) {
                    aLead.dr_first_campaign_tracking__c = cm.CampaignId;
                    aLead.dr_first_campaign_tracking_contact__c = cm.CampaignId;
                }
                aLead.dr_number_of_campaigns__c = cnt;
                leadsToUpdate.add (aLead);
            }
        }
    }
    if (leadsToUpdate.size() > 0) {
        update leadsToUpdate;
    }
    if (contactsToUpdate.size() > 0) {
        update contactsToUpdate;
    }
}