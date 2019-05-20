public class ReassignLeads {

    public static Boolean futureMethodAlreadyCalled = FALSE; 
    @future
    public static void reassignLeads(Set<Id> ids){
        futureMethodAlreadyCalled = TRUE;
        List<Lead> leads = [SELECT id, Reassign__c FROM Lead WHERE Id IN: ids];
        Database.DMLOptions dmo=new Database.DMLOptions();
        dmo.assignmentRuleHeader.UseDefaultRule=True;

        for (Lead l: leads){	   
            if(l.Reassign__c==True){
              l.Reassign__c=False; //set it to false to avoid continually reassigning this lead
              l.setOptions(dmo);
            }
        }
       try {
           Database.Update(leads);
       }catch (DMLException e){
           system.debug('Something went wrong with the reassignLeads method: ' + e);
       }
    }
}