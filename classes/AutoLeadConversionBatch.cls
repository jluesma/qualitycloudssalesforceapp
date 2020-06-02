/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Title           : AutoLeadConversionBatch
Author          : Lister Technologies
Description     : This is a batch class for auto conversion of lead.
Test Class      : 
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
global class AutoLeadConversionBatch implements Database.batchable<sObject>
{
	//global List<Messaging.SingleEmailMessage> emailList;
	global AutoLeadConversionBatch()
	{
	 
	}
    global Database.QueryLocator start(Database.BatchableContext BC)
    {
        String q;
        q = 'select id,Name,Country,Email,isConverted,status,OwnerId,AlreadyProcessed__c,RestrictWorkFlow__c from Lead where IsConverted = false and Email!=null and AlreadyProcessed__c = false and Country !=null and dr_funnel__c = \'MQL\'';
        return Database.getQueryLocator(q);
    }
    global void execute(Database.BatchableContext BC, List<Lead> scope)
    {
        //Group grp = [SELECT Id, Name FROM Group where name='Sales Team'];
        List<Id> UserIDlist = new List<Id>();
        List<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>(); 
        /*List<String> SalesemailId = new List<String>();
        for(GroupMember GrpMem:[SELECT Id, GroupId, UserOrGroupId FROM GroupMember where GroupId=:grp.Id])
        {
            UserIDlist.add(GrpMem.UserOrGroupId);
        }
        for(User us:[select id,Email from User where id in:UserIDlist])
        {
          SalesemailId.add(us.Email); 
        }*/
        system.debug('scope'+scope);
        Map<String,List<Id>> MapofLeadIdtoDomainandCountry = new Map<String,List<Id>>();
        Map<String,Id> MapofLeademailtoId = new Map<String,Id>();
        Set<String> domainset = new Set<String>();
        Set<String> Countryset = new Set<String>();
        Set<String> emailset = new Set<String>();
        Set<Id> accIdset = new Set<Id>();
        Map<Id,Account> mapofLeadIdtoAcc = new Map<Id,Account>();
        Map<Id,Contact> mapofLeadIdtoCon = new Map<Id,Contact>();
        Set<Id> SetofAccIdtoOppExists = new Set<Id>();
        List<Database.LeadConvert> leadconvertlist = new List<Database.LeadConvert>();
        Map<Id,Lead> leadtoupdate = new Map<Id,Lead>();
        Map<Id,Lead> leadtoupdateowner = new Map<Id,Lead>();
        List<EmailTemplate> emailTemplatelist;
        EmailTemplate EmailTemplate1;
        EmailTemplate EmailTemplate2;
        Map<Id,List<String>> mapofaccIdtoAccandOppOwner = new Map<Id,List<String>>();
        
        for(Lead l:scope)
        {
            String tempstring ='';
            String emaildom ='';
            List<String> strlist = l.email.split('@');
            if(strlist!=null && strlist.size()>0)
            emaildom = strlist.get(1);
            tempstring = emaildom +'::'+l.Country;
            domainset.add(emaildom);            
            Countryset.add(l.Country);
            if(MapofLeadIdtoDomainandCountry.containskey(tempstring))
            {
                List<Id> templist = MapofLeadIdtoDomainandCountry.get(tempstring);
                templist.add(l.Id);
                MapofLeadIdtoDomainandCountry.put(tempstring,templist);
            }
            else
            {
                List<Id> templist = new List<Id>();
                templist.add(l.Id);
                MapofLeadIdtoDomainandCountry.put(tempstring,templist);
            }
            
            emailset.add(l.email);
            MapofLeademailtoId.put(l.email,l.Id);
        }
        
        system.debug('MapofLeadIdtoDomainandCountry'+MapofLeadIdtoDomainandCountry);
        //select the accounts whose email domain and country match with the lead email domain and country
        for(Account acc:[select id,Email__c,BillingCountry,Type,ownerId,Status__c from Account where Email__c in:domainset and billingCountry in:Countryset and Email__c !=null and billingCountry!=null])
        {
            String templist = '';
            templist = acc.Email__c+'::'+acc.BillingCountry;
            if(MapofLeadIdtoDomainandCountry.get(templist) != null)
            {
                for(Id ldid:MapofLeadIdtoDomainandCountry.get(templist))
                mapofLeadIdtoAcc.put(ldid,acc);
                accIdset.add(acc.Id);
                List<String> templist1 = new List<String>();
                templist1.add(acc.ownerId);
                mapofaccIdtoAccandOppOwner.put(acc.Id,templist1);
            }
        }
        system.debug('mapofLeadIdtoAcc'+mapofLeadIdtoAcc);
        //select the contacts whose email matches with the lead email
        for(Contact con:[select id,Email from Contact where Email in:emailset])
        {
            if(MapofLeademailtoId.get(con.Email) != null)
            mapofLeadIdtoCon.put(MapofLeademailtoId.get(con.Email),con);
        }
        system.debug('mapofLeadIdtoCon'+mapofLeadIdtoCon);
        //check is opportunity is present for the accounts that have a match
        if(mapofLeadIdtoAcc != null)
        {
            Set<String> statusset = new Set<String>();          
            for(OpportunityStage oppstage:[SELECT MasterLabel FROM OpportunityStage where isActive = true and isclosed = false])
            {
                statusset.add(oppstage.MasterLabel);
            }
            for(Opportunity opp:[select id,AccountId,OwnerId,StageName from opportunity where AccountId in:accIdset])
            {
                if(statusset.contains(opp.StageName))
                {
                    SetofAccIdtoOppExists.add(opp.AccountId);
                    List<String> templist=mapofaccIdtoAccandOppOwner.get(opp.AccountId);
                    if(templist[0] != opp.ownerId)
                    templist.add(opp.ownerId);
                    mapofaccIdtoAccandOppOwner.put(opp.AccountId,templist);
                }   
            }
        }
        String str = Label.Template_for_lead_conversion_mail;
        String str1 = Label.Template_for_lead_conversion_sales_mail;
        LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
        emailTemplatelist=[Select id,DeveloperName from EmailTemplate where DeveloperName=:str or developername = :str1];
        for(EmailTemplate emt:emailTemplatelist)
        {
            if(emt.developername == str)
            emailtemplate1 = emt;
            else
            emailtemplate2 = emt;
        }
        
        system.debug('scope'+scope);
        
        set<Id> queueId = new set<Id>();
        for(Group gp: [Select Id from Group where type='Queue']){
            queueId.add(gp.Id);
        } 
        system.debug('**queueId '+queueId);
        //firing assignment rules for the leads whose owner is a Queue
        for(lead l:scope)
        {
        	Boolean Camein = false;
             if(mapofLeadIdtoAcc != null && mapofLeadIdtoAcc.get(l.Id)!=null)//Inside if means Account match is found
            	{    
                	if(SetofAccIdtoOppExists !=null && SetofAccIdtoOppExists.contains(mapofLeadIdtoAcc.get(l.Id).Id))//Inside if means opp is present for acc
                	{
                    	if(mapofLeadIdtoCon != null && mapofLeadIdtoCon.get(l.Id) != null)//Inside if means Conctat match is found
                    	{
                    	}
                    	else//inside else means no contact match found
                    	{
                    		l.RestrictWorkFlow__c = true;                        	
            				Camein = true; 
            				system.debug('lead to be converted'+l);
                        	                       
                    	}                   
                	}
                	else//inside else means no opporunity for Account
                	{
                    	if(mapofLeadIdtoAcc.get(l.Id).type !='Customer' && mapofLeadIdtoAcc.get(l.Id).type != null)
                    	{
                        	l.RestrictWorkFlow__c = true;
           					Camein = true; 
           					system.debug('lead to be converted'+l);
                        	                      
                    	}
                	}
                 }
           if(queueId != null && queueId.contains(l.OwnerId))
            {
                 
                Database.DMLOptions dmo = new Database.DMLOptions();
        		dmo.assignmentRuleHeader.useDefaultRule = true;                  
                l.setOptions(dmo);
                Camein = true;
            }
            if(Camein)
               leadtoupdateowner.put(l.Id,l);
        }
        
        if(leadtoupdateowner != null && leadtoupdateowner.values().size()>0)
        { system.debug('****leadtoupdateowner '+ leadtoupdateowner);
            try
            {
                update leadtoupdateowner.values();
            }
            Catch(Exception e)
            {
                system.debug('Exception while updating the lead'+e.getMessage());
            }
            system.debug('****leadtoupdateowner '+ leadtoupdateowner);            
        }
        
        for(Lead l:[select id,Country,Email,isConverted,RestrictWorkFlow__c,status,OwnerId,AlreadyProcessed__c from Lead where IsConverted = false and Email!=null and AlreadyProcessed__c = false and Country !=null and dr_funnel__c = 'MQL'])
        {
            system.debug('leadl'+l);
            if(mapofLeadIdtoAcc != null && mapofLeadIdtoAcc.get(l.Id)!=null)//Inside if means Account match is found
            {    
                system.debug('****1');
                if(SetofAccIdtoOppExists !=null && SetofAccIdtoOppExists.contains(mapofLeadIdtoAcc.get(l.Id).Id))//Inside if means opp is present for acc
                {
                    system.debug('****2');
                    if(mapofLeadIdtoCon != null && mapofLeadIdtoCon.get(l.Id) != null)//Inside if means Conctat match is found
                    {
                        system.debug('****3');
                        //email opp owner and acc owner
                        List<String> toAdd=mapofaccIdtoAccandOppOwner.get(mapofLeadIdtoAcc.get(l.Id).Id);
                        //Id targetID = Id.valueof(toAdd[0]);
                        l.AlreadyProcessed__c=true;
                        leadtoupdate.put(l.Id,l);
                        toAdd.add(label.Lister_mail);
                        emailList.add(sendcustmail(toAdd,emailTemplate1,mapofLeadIdtoAcc.get(l.Id).Id,l.Id,false));
                    }
                    else//inside else means no contact match found
                    {
                        system.debug('****4');
                        //email to opp owner and acc owner
                        List<String> toAdd=mapofaccIdtoAccandOppOwner.get(mapofLeadIdtoAcc.get(l.Id).Id);
                        toAdd.add(label.Lister_mail);                       
                        emailList.add(sendcustmail(toAdd,emailTemplate1,mapofLeadIdtoAcc.get(l.Id).Id,l.Id,false));
                        
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(l.id);
                        lc.setAccountId(mapofLeadIdtoAcc.get(l.Id).Id);
                        if(queueId.contains(l.OwnerId))
                        	lc.setOwnerId(mapofLeadIdtoAcc.get(l.Id).ownerId);
                        lc.setDoNotCreateOpportunity(true);
                        lc.setConvertedStatus(convertStatus.MasterLabel);                        
                        leadconvertlist.add(lc);
                        
                    }                   
                }
                else//inside else means no opporunity for Account
                {
                    system.debug('****5');
                    if(mapofLeadIdtoAcc.get(l.Id).type !='Customer' && mapofLeadIdtoAcc.get(l.Id).type != null)
                    {
                        
                        system.debug('if lead Id'+l.OwnerId);
                        Database.LeadConvert lc = new Database.LeadConvert();
                        lc.setLeadId(l.id);
                        if(queueId.contains(l.OwnerId))
                        lc.setOwnerId(mapofLeadIdtoAcc.get(l.Id).ownerId);
                        lc.setAccountId(mapofLeadIdtoAcc.get(l.Id).Id);
                        lc.setDoNotCreateOpportunity(true);
                        lc.setConvertedStatus(convertStatus.MasterLabel);
                        leadconvertlist.add(lc);
                        
                    }
                    else if(mapofLeadIdtoAcc.get(l.Id).type != null && mapofLeadIdtoAcc.get(l.Id).Status__c != 'Prospect')
                    {
                        system.debug('else lead Id'+l.Id);
                        l.status = 'Qualified - (SQL)';
                        l.AlreadyProcessed__c=true;
                        leadtoupdate.put(l.Id,l);
                        //email to sales with suggestion
                        
                        //List<String> toAdd = new List<String>();
                        //toAdd.addall(SalesemailId);
						List<String> toAdd=mapofaccIdtoAccandOppOwner.get(mapofLeadIdtoAcc.get(l.Id).Id);
                        toAdd.add(label.Lister_mail);                       
                        emailList.add(sendcustmail(toAdd,emailTemplate2,mapofLeadIdtoAcc.get(l.Id).Id,l.Id,false));
                    }
                    else
                    {
                         l.AlreadyProcessed__c=true;
                    }    
                }
            }
            else
            {
                l.AlreadyProcessed__c=true;
                leadtoupdate.put(l.Id,l);
            }
        }
        try
        {
        	if(emailList !=null)        	                
        		Messaging.sendEmail(emailList);
        }        
    	Catch(Exception e)
    	{
    		system.debug('Exception while updating the lead'+e.getMessage());
    	}
        
        //convert the leads to contacts
        if(leadconvertlist != null && leadconvertlist.size()>0)
        {
            List<Database.LeadConvertResult> lcr = Database.convertLead(leadconvertlist);
            for (Database.LeadConvertResult lc:lcr)
            {
                if (lc.isSuccess())
                {
                    system.debug('lead converted successfully');
                    system.debug('Contact Id' + lc.getContactId());                 
                }
                else
                {
                    system.debug('Error converting new Lead:'+lc.getErrors()[0].getMessage());
                }
            }           
        }                             
        
        // update the leads for which status needs to be updated
        if(leadtoupdate != null && leadtoupdate.values().size()>0)
        {
            try
            {
                update leadtoupdate.values();
            }
            Catch(Exception e)
            {
                system.debug('Exception while updating the lead'+e.getMessage());
            }
        }
        
    }
        public Messaging.SingleEmailMessage  sendcustmail(String[] toAddresses,EmailTemplate emailTemplate,Id whatId,Id targetObjectId,Boolean treatAsRecipient)
        {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
           System.debug('sendMailWithAttachments'+whatId);
                mail.setToAddresses(toAddresses);
                mail.setWhatId(whatId);
                mail.setTargetObjectId(targetObjectId);
                mail.setTemplateId(emailTemplate.id);
                mail.saveAsActivity = false;
                mail.setTreatTargetObjectAsRecipient(treatAsRecipient);
                system.debug('mail'+mail);
               // emailList.add(mail); 
               return mail; 
        }
    
    global void finish(Database.BatchableContext BC)
    {                
	 	
    }
}