public class OpportunityNotifications {
    
    /* CJ-1 BEGIN - Reminder Notification for Sales about stalled Opps
     * Sends a single email message for owner of the user, based on template 
     */
    public static void NotifyOwner(List<Opportunity> opps) {
        //select for email templates
        EmailTemplate []templates = [select id, name, subject, body, htmlValue from EmailTemplate where DeveloperName in ('CJ_1_cond1_html', 'CJ_1_cond2_html', 'CJ_1_cond3_html', 'CJ_1_cond4_html') order by DeveloperName];
        EmailTemplate temp1 = templates[0];
        EmailTemplate temp2 = templates[1];
        EmailTemplate temp3 = templates[2];
        EmailTemplate temp4 = templates[3];
        //setting the from mail address
        OrgWideEmailAddress []addresses = [select id, Address, DisplayName from OrgWideEmailAddress];
        OrgWideEmailAddress address;
        for(OrgWideEmailAddress a : addresses) {
            if(a.DisplayName == 'salesOps')
                address = a;
        }
//container for later use of mail sending
        List<Messaging.SingleEmailMessage> messages2send = new List<Messaging.SingleEmailMessage>();
        //container for later use of inserting activities
        List<Task> tasks2save = new List<Task>();
        
        //parsing CC addresses
        List<Reminder_Notification_for_Sales_1__mdt> ccAddresses = new List<Reminder_Notification_for_Sales_1__mdt>([select id, email__c from Reminder_Notification_for_Sales_1__mdt]);        
        List<String> ccAddressesString = new List<String>();
        for(Reminder_Notification_for_Sales_1__mdt r : ccAddresses) {
            ccAddressesString.add(r.email__c);
        }
        
        //containers for parsing opportunity owners with templated mail (there were 3 levels mentioned in ticket)
        Map<Id, Messaging.SingleEmailMessage> owner2mailLevel1 = new Map<Id, Messaging.SingleEmailMessage>();
        Map<Id, Messaging.SingleEmailMessage> owner2mailLevel2 = new Map<Id, Messaging.SingleEmailMessage>();
        Map<Id, Messaging.SingleEmailMessage> owner2mailLevel3 = new Map<Id, Messaging.SingleEmailMessage>();
        Map<Id, Messaging.SingleEmailMessage> owner2mailLevel4 = new Map<Id, Messaging.SingleEmailMessage>();
        
        //parsing and matching
        for(Opportunity opp : opps) {            
            //level 1
            if(opp.Age__c > 3 && opp.StageName == '0 Active (SQL)' && opp.Annual_contract_value__c > 0) {
                Messaging.SingleEmailMessage email = owner2mailLevel1.get(opp.OwnerId);
                //where there is no email created yet
                if(email == null) {
                	email = Messaging.renderStoredEmailTemplate(temp1.Id, opp.OwnerId, opp.Id);
                    email.setBCcAddresses(ccAddressesString);
                    email.saveAsActivity = false;
                    email.setOrgWideEmailAddressId(address.Id);
                    email.setHtmlBody(email.htmlBody += '<br/><table style="width:100%;border: 1px solid black;"><tr><th style="background-color: #eee;border: 1px solid black;">Name</th><th style="background-color: #eee;border: 1px solid black;">Close Date</th><th style="background-color: #eee;border: 1px solid black;">Age</th><th style="background-color: #eee;border: 1px solid black;">Account</th><th style="background-color: #eee;border: 1px solid black;">Created Date</th></tr>');
                    owner2mailLevel1.put(opp.OwnerId, email);
                //when there is alreday mail created and filled with content adding the current opportunity at the end
                }
                email = addNewLineToEmail(email, opp);                
            }
            else if((opp.StageName == '1 Prospecting (Discovering/Identifying)' || opp.StageName == '2 Qualification' || opp.StageName == '3 Evaluation') && opp.Annual_contract_value__c > 0 && (opp.CloseDate >= system.today()  && opp.CloseDate < system.today().addMonths(1))) {
                Messaging.SingleEmailMessage email = owner2mailLevel2.get(opp.OwnerId);
                //where there is no email created yet
                if(email == null) {
	                email = Messaging.renderStoredEmailTemplate(temp2.Id, opp.OwnerId, opp.Id);
                    email.setBCcAddresses(ccAddressesString);
                    email.saveAsActivity = false;
                    email.setOrgWideEmailAddressId(address.Id);
                    email.setHtmlBody(email.htmlBody += '<br/><table style="width:100%;border: 1px solid black;"><tr><th style="background-color: #eee;border: 1px solid black;">Name</th><th style="background-color: #eee;border: 1px solid black;">Close Date</th><th style="background-color: #eee;border: 1px solid black;">Age</th><th style="background-color: #eee;border: 1px solid black;">Account</th><th style="background-color: #eee;border: 1px solid black;">Created Date</th></tr>');
                    owner2mailLevel2.put(opp.OwnerId, email);
                //when there is alreday mail created and filled with content adding the current opportunity at the end
                }
                email = addNewLineToEmail(email, opp);                
            }
            else if(opp.StageName != '6 Closed/Won' && opp.StageName != '6 Closed/Lost' && opp.StageName != '6 Closed/Pending' && opp.Annual_contract_value__c > 0 && opp.CloseDate < system.today()) {
                Messaging.SingleEmailMessage email = owner2mailLevel3.get(opp.OwnerId);
                //where there is no email created yet
                if(email == null) {
                	email = Messaging.renderStoredEmailTemplate(temp3.Id, opp.OwnerId, opp.Id);
                    email.setBCcAddresses(ccAddressesString);
                    email.saveAsActivity = false;
                    email.setOrgWideEmailAddressId(address.Id);
                    email.setHtmlBody(email.htmlBody += '<br/><table style="width:100%;border: 1px solid black;"><tr><th style="background-color: #eee;border: 1px solid black;">Name</th><th style="background-color: #eee;border: 1px solid black;">Close Date</th><th style="background-color: #eee;border: 1px solid black;">Age</th><th style="background-color: #eee;border: 1px solid black;">Account</th><th style="background-color: #eee;border: 1px solid black;">Created Date</th></tr>');
                    owner2mailLevel3.put(opp.OwnerId, email);
                //when there is alreday mail created and filled with content adding the current opportunity at the end
                }
                email = addNewLineToEmail(email, opp);                
            } else if(opp.CloseDate > system.today() && opp.CloseDate < system.today().addDays(7) && (opp.StageName == '4 Proposal' || opp.StageName == '5 Negotiation/Closing') && opp.Annual_contract_value__c > 0) {
                Messaging.SingleEmailMessage email = owner2mailLevel4.get(opp.OwnerId);
                //where there is no email created yet
                if(email == null) {
                	email = Messaging.renderStoredEmailTemplate(temp4.Id, opp.OwnerId, opp.Id);
                    email.setBCcAddresses(ccAddressesString);
                    email.saveAsActivity = false;
                    email.setOrgWideEmailAddressId(address.Id);
                    email.setHtmlBody(email.htmlBody += '<br/><table style="width:100%;border: 1px solid black;"><tr><th style="background-color: #eee;border: 1px solid black;">Name</th><th style="background-color: #eee;border: 1px solid black;">Close Date</th><th style="background-color: #eee;border: 1px solid black;">Age</th><th style="background-color: #eee;border: 1px solid black;">Account</th><th style="background-color: #eee;border: 1px solid black;">Created Date</th></tr>');
                    owner2mailLevel4.put(opp.OwnerId, email);
                //when there is alreday mail created and filled with content adding the current opportunity at the end
                }
                email = addNewLineToEmail(email, opp);                
            }
        }
        
        for(Messaging.SingleEmailMessage em : owner2mailLevel1.values()) 
            em.setHtmlBody(em.htmlBody + '</table>');
        for(Messaging.SingleEmailMessage em : owner2mailLevel2.values()) 
            em.setHtmlBody(em.htmlBody + '</table>');
        for(Messaging.SingleEmailMessage em : owner2mailLevel3.values()) 
            em.setHtmlBody(em.htmlBody + '</table>');
        for(Messaging.SingleEmailMessage em : owner2mailLevel4.values()) 
            em.setHtmlBody(em.htmlBody + '</table>');
        
        //creating tasks for each opportunity 
        //this is done in separated for cycle, because the email contains already all the opportunity names
        for(Opportunity opp : opps) {            
            if(opp.Age__c > 3 && opp.StageName == '0 Active (SQL)' && opp.Annual_contract_value__c > 0) {
                Messaging.SingleEmailMessage email = owner2mailLevel1.get(opp.OwnerId);
                if(email != null) {
                    Task t = createTaskBasedOnEmailTemplateAndOpportunity(opp, email);
                    tasks2save.add(t);
                }
            }
            else if((opp.StageName == '1 Prospecting (Discovering/Identifying)' || opp.StageName == '2 Qualification' || opp.StageName == '3 Evaluation') && opp.Annual_contract_value__c > 0 && (opp.CloseDate >= system.today() && opp.CloseDate < system.today().addMonths(1))) {
                Messaging.SingleEmailMessage email = owner2mailLevel2.get(opp.OwnerId);
                if(email != null) {
                    Task t = createTaskBasedOnEmailTemplateAndOpportunity(opp, email);
                    tasks2save.add(t);
                }
            }
            else if(opp.StageName != '6 Closed/Won' && opp.StageName != '6 Closed/Lost' && opp.StageName != '6 Closed/Pending' && opp.Annual_contract_value__c > 0 && opp.CloseDate < system.today()) {
                Messaging.SingleEmailMessage email = owner2mailLevel3.get(opp.OwnerId);
                if(email != null) {
                    Task t = createTaskBasedOnEmailTemplateAndOpportunity(opp, email);
                    tasks2save.add(t);
                }
            } else if(opp.CloseDate > system.today() && opp.CloseDate < system.today().addDays(7) && (opp.StageName == '4 Proposal' || opp.StageName == '5 Negotiation/Closing') && opp.Annual_contract_value__c > 0) {
                Messaging.SingleEmailMessage email = owner2mailLevel4.get(opp.OwnerId);
                if(email != null) {
                    Task t = createTaskBasedOnEmailTemplateAndOpportunity(opp, email);
                    tasks2save.add(t);
                }
            }
        }
        
        //collecting mails
        messages2send.addAll(owner2mailLevel1.values());
        messages2send.addAll(owner2mailLevel2.values());
        messages2send.addAll(owner2mailLevel3.values());
        messages2send.addAll(owner2mailLevel4.values());
    
        //sending mails
        if(messages2send.size() > 0)
            Messaging.sendEmail(messages2send);
            
        //inserting activities
        if(!tasks2save.isEmpty())
            insert tasks2save;
        
    }
    
    //helper method to fill task based on opportunity ID and email
    private static Task createTaskBasedOnEmailTemplateAndOpportunity(Opportunity opp, Messaging.SingleEmailMessage email) {
        Task t = new Task(); 
        t.OwnerId = opp.OwnerId;
        t.Description = email.plainTextBody;
        t.Priority = 'Normal';
        t.Subject = email.subject;
        t.Status = 'Completed';
        t.Type = 'Email';
        t.TaskSubtype = 'Email';
        t.WhatId = opp.id;
        t.IsReminderSet = false;
        return t;
    }
    
    private static Messaging.SingleEmailMessage addNewLineToEmail(Messaging.SingleEmailMessage email, Opportunity opp) {
        email.setHtmlBody(email.htmlBody += '<tr><td style="text-align: center;border: 1px solid black"><a href="' + Url.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(opp.OpportunityId18digit__c) + '">' + opp.Name + 
                          '</a></td><td style="text-align: center;border: 1px solid black">' + opp.CloseDate.format()
                          + '</td><td style="text-align: center;border: 1px solid black">' + opp.Age__c + '</td><td style="text-align: center;border: 1px solid black"><a href="' + 
                          Url.getSalesforceBaseUrl().toExternalForm() + '/' + String.valueOf(opp.Account.AccountId18digit__c) + '">' + opp.Account.Name + '</a></td><td style="text-align: center;border: 1px solid black">' + opp.CreatedDate.format() + '</tr>');
        
        return email;
    }
}