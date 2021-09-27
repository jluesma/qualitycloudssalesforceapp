global class batchLeadTierUpdate implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        
        String query = 'SELECT Email,Tier__c FROM Lead where (Tier__c=\'\' or Tier__c=null) and isconverted=false' ;
        return Database.getQueryLocator(query);
    }
   
    global void execute(Database.BatchableContext BC, List<Lead> scope) {
  
    Set<String> DomainSet=new Set<String>();
            List<Lead> Finalleads=new  List<Lead>();
        
        Map<String,List<Account>> MapOfDomainToAccounts=new Map<String,List<Account>>();
       
        for(Lead CurLead:scope)
        {
            if(CurLead.email != null)
            
            {
            String emailDomain = CurLead.Email.substringAfter('@'); 
            DomainSet.add(emailDomain);    
            }           
        }
        
        if(DomainSet.size()>0)
        
    {
        
        List<Account>  relatedacc = [SELECT ID,Email__c ,Tier__c,Parent_Account__c FROM Account WHERE Email__c IN:DomainSet];
       
        
        if(relatedacc!=null && relatedacc.size()>0)
        {
        
        for(Account acc:relatedacc)
        {
            if(MapOfDomainToAccounts.containsKey(acc.Email__c))
            {
                MapOfDomainToAccounts.get(acc.Email__c).add(acc);
            }
            else 
            {
                MapOfDomainToAccounts.put(acc.Email__c,new List<Account>{acc});
            }
        }
        }
        for(Lead CurLead:scope)
        {
        
            if(CurLead.Email !=null)        
        {
              String emailDomain = CurLead.Email.substringAfter('@'); 
                if(MapOfDomainToAccounts.containsKey(emailDomain))
                {
                        string s1=MapOfDomainToAccounts.get(emailDomain)[0].Tier__c;
                        boolean b = false;
                        integer i=0;
                        
                        for(Account acc:MapOfDomainToAccounts.get(emailDomain))
                        {
                        
                            if(i!= 0) 
                            {
                            if(MapOfDomainToAccounts.get(emailDomain).size()>1)
                                {
                                    if(String.isNotBlank(acc.Tier__c) && acc.Parent_Account__c==true )
                                    {
                                        
                                        string str1=acc.Tier__c;
                                        System.debug('s1'+ s1 + '--'+ str1);
                                        if(b==false)
                                        {
                                            s1=acc.Tier__c;
                                            
                                        }
                                        else
                                        {
                                            if(s1==str1)
                                                {
                                                    s1=acc.Tier__c;
                                                    
                                                }
                                            else
                                                {
                                                    s1='Multiple Accounts';
                                                    
                                                }
                                        }
                                        b=true;    
                                    }
         else if(String.isNotBlank(acc.Tier__c) && b==false)
         {
                                  string str1=acc.Tier__c;
                                          if(s1==str1)
                                            {
                                                s1=acc.Tier__c;
                                                
                                            }
                                        else
                                            {
                                                s1='Multiple Accounts';
                                                
                                            }
         }
         
                                }
                   
                            else if(String.isNotBlank(acc.Tier__c))                                 
                                {
                                s1=acc.Tier__c;
                                
                                }
                            else
                                {
                                    s1='No Tier';
                                    
                                }   
                            }
                            else
                            {
        if(String.isNotBlank(acc.Tier__c) && acc.Parent_Account__c==true )
        {
         b=true;
        }
                                String religion ="A";
        i++;
                            }
                            
                        }
      
      
                        if(s1 !=Null && s1 !='' )
                        {
                         CurLead.Tier__c=s1;
                         
                        }
                        else
                        {
                        CurLead.Tier__c='No Tier';
                        
                        }
      
    
      
      

                }
                
                else 
                {
                    CurLead.Tier__c='No Account';
                    
                    
                }
                       
            
           Finalleads.add(CurLead);     
        }
        }
        }
        
        if(Finalleads.size()>0)
        {
        update Finalleads;
        }
        
    
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}
