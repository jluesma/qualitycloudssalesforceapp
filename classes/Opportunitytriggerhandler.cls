/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Title           : Opportunitytriggerhandler
Author          : Lister Technologies
Description     : This is a handler class for opportunity trigger
Test Class      : Test
Trigger         : Trg_Opportunity
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - */
public with sharing class Opportunitytriggerhandler 
{
    private static Boolean isInsert = false;
    public static void beforeUpdateLogic(List<Opportunity> newList,List<Opportunity> oldList,Map<Id,Opportunity> newMap,Map<Id,Opportunity> oldMap)
        {
            if(isInsert == false)
            {
                List<Id> Opplistforcontactroles=new List<Id>();
                Recordtype rt = [select id from recordtype where developername='Tosca' and SobjectType='Opportunity'];
                for(Opportunity opp:newList)            
                {
                    //Stage gates to move opportunity to respected stages should fire only on edit but not while creation
                    system.debug(oldMap.get(opp.Id).StageName);
                    if(opp.recordtypeid == rt.id && (opp.StageName == '3 Evaluation' || opp.StageName == '4 Proposal' || opp.StageName == '5 Negotiation/Closing' || opp.StageName == '6 Closed/Won'))
                    {
                        Opplistforcontactroles.add(opp.Id);
                    }
                    
                    if(oldMap.get(opp.Id).StageName != opp.StageName && (opp.StageName == '6 Closed/Won' || opp.StageName == '6 Closed/Lost'))
                    opp.isClosed__c = true;
                }
                for(Opportunity opp:[select id,stageName,(select id from OpportunityContactRoles) from Opportunity where id in:Opplistforcontactroles])
                {
                    List<OpportunityContactRole> oppcontactrole = opp.getSObjects('OpportunityContactRoles');
                    
                    //While moving the opportunity to '2 Qualification' stage,there should be atleast one contact associted with the opportunity
                    if(oppcontactrole == null || oppcontactrole.size()==0)
                    {
                        String s = Label.Error_message_for_stage_gate_contact;
                        //trigger.new[0].addError(s);
                    }
                }                
            }
            isInsert = false;
        }
        
    public static void afterUpdateLogic(List<Opportunity> newList, Map<Id,Opportunity> oldMap) {
            List<Id> OpplistToUpdateItsQuotes=new List<Id>();
            System.debug('$$$$ after update');
            List<SBQQ__Quote__c> QuoteListForStatusUpdate=new List<SBQQ__Quote__c>();
            for(Opportunity Opp : [Select id,recordtypeid,StageName,SBQQ__Renewal__c,SBQQ__RenewedContract__r.Parent_opportunity_name__c from Opportunity where id in:newList]){
                if(oldMap.get(Opp.Id).StageName != Opp.StageName && Opp.StageName == '6 Closed/Won')
                    OpplistToUpdateItsQuotes.add(Opp.id);
            }
            system.debug(OpplistToUpdateItsQuotes);
            //updates the primary and approved quote's status as approved when the related opportunity's stage is changed to 6 Closed/Won
            for(SBQQ__Quote__c quote : [select id,SBQQ__Status__c,SBQQ__Primary__c,SBQQ__StartDate__c  from SBQQ__Quote__c where SBQQ__Opportunity2__c in: OpplistToUpdateItsQuotes and SBQQ__Status__c='Approved' and SBQQ__Primary__c  = True]) {
                SBQQ__Quote__c TempQuote = new SBQQ__Quote__c(id=quote.id);
                //TempQuote.SBQQ__Status__c = 'Accepted';
                TempQuote.SBQQ__Primary__c = true;
                //if(TempQuote.SBQQ__StartDate__c == null){
                   // TempQuote.SBQQ__StartDate__c = date.today();
                //}
                QuoteListForStatusUpdate.add(TempQuote);
            }
            system.debug(QuoteListForStatusUpdate);
            update QuoteListForStatusUpdate;     
        }
        
     public static void UpdateFirstWonOpportunity(List<Opportunity> newList,Map<Id,Opportunity> oldMap){
            List<Account> accstoUpdate = new List<Account>();
            List<Id> opplistforUpdate = new List<Id>();
            
            for(Opportunity opp:newList){
                if((opp.StageName == '6 Closed/Won' && oldMap.get(opp.Id).StageName!='6 Closed/Won') || (oldMap.get(opp.Id).StageName=='6 Closed/Won' && opp.StageName != '6 Closed/Won'))
                    opplistforUpdate.add(opp.accountid);

            }
            system.debug(opplistforUpdate+'===');
            for(Account acc:[select id,First_Won_Opportunity__c, (select id,closed_won_date__c from Opportunities where StageName = '6 Closed/Won') from Account where id in:opplistforUpdate]){
                Opportunity firstWon = new Opportunity();
                system.debug(acc+'===1');
                for(Opportunity opp:acc.Opportunities){
                    if(firstWon.closed_won_date__c == null || (firstWon.closed_won_date__c != null && firstWon.closed_won_date__c > opp.closed_won_date__c))
                        firstWon = opp;
                    
                }
                system.debug(firstWon+'===2');
                acc.First_Won_Opportunity__c = firstWon.Id;
                accstoUpdate.add(acc);
                system.debug(accstoUpdate+'===3');
             }
            
            if(accstoUpdate.size()>0)   
                update accstoUpdate;           
        }
        
        public static void stopUpdateOnInsert()
        {
            isInsert = true;
        }
        public static Boolean displayBooleanValue(){
        
            return isInsert;
        }
}