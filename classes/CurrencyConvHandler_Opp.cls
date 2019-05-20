/*
        Name: CurrencyConvHandler_Opp
        Discription: Class to Convert other currency into euro
        Created by: Sunil
        Test Class: TestCurrencyConvHandler_Opp

    Change History
     *********************************************************************************************************************************************
     ModifiedBy        Date          Ticket No.      Requested By      Description                                                             Tag
     *********************************************************************************************************************************************                                                                                                                                                                                      
*/


public class CurrencyConvHandler_Opp {
    
    public static void handleCurrencyConversion(List<Opportunity> Opportunities){
        
        Date maxDate;
        Date minDate;
        Date createdDate;
        Set<String> currencyCodes = new Set<String>();
        Set<Date> dateofRateExchanges = new Set<Date>();
        List<DatedConversionRate> conversionRateList = new List<DatedConversionRate>();
        Map<String,DatedConversionRate> exchangeRateMap = new Map<String,DatedConversionRate>();
        List<Opportunity> oppUpdateList = new List<Opportunity>();
        Map<Id,double> convertedCurr = new Map<Id,double>();
        Set<Id> oppId = new Set<Id>();
        
        for(Opportunity opp:Opportunities){
            if(opp.CreatedDate!= null )
            createdDate = opp.CreatedDate.date();
            else
                createdDate = Date.today();
            if(opp.CurrencyIsoCode!= null)
                currencyCodes.add(opp.CurrencyIsoCode);
            dateofRateExchanges.add(createdDate);
            if(maxDate == null || createdDate > maxDate)    
                maxDate = createdDate;
            if(minDate == null || createdDate < minDate)
                minDate = createdDate;    
        }
        
        System.debug('maxDate::::MinDate:::::'+maxDate+':::::::'+minDate);
        if(maxDate!=null && minDate!=null && currencyCodes.size()!=0){
            
            conversionRateList = [select ConversionRate,Isocode,NextStartDate,StartDate from 
                                  DatedConversionRate where IsoCode in:currencyCodes and  
                                  (NextStartDate>=:minDate and StartDate<=:maxDate)];
            System.debug('conversionRateList:::::'+conversionRateList.size());
            if(conversionRateList.size()!=0){
                for(DatedConversionRate dcr:conversionRateList){
                    for(Date rateExchangedate:dateofRateExchanges){
                        if((rateExchangedate >= dcr.StartDate)&&(rateExchangedate <= dcr.NextStartDate)){
                            exchangeRateMap.put(rateExchangedate+'-'+dcr.Isocode,dcr);
                        }
                    }}
                
                // Conversion to Euro
                List<Opportunity> updatedOpp = new List<Opportunity>();
                for(Opportunity opp:Opportunities){
                    DatedConversionRate dateCon = new DatedConversionRate();
                    double Acv_In_Euro =0;
                    if(opp.CreatedDate!= null )
                    dateCon = exchangeRateMap.get(opp.CreatedDate.date()+'-'+opp.CurrencyIsoCode);
                    else
                        dateCon = exchangeRateMap.get(Date.today()+'-'+opp.CurrencyIsoCode);
                    if(dateCon!=null && dateCon.ConversionRate!=0){
                        if(opp.StageName == '6 Closed/Lost')
                        {
                            opp.Weigthed_Pipeline_NACV_in_Euro__c = 0;
                            opp.Total_Pipeline_NACV_in_Euro__c = 0;
                            opp.Mgmt_Expected_NACV_in_Euro__c = 0;
                            //divya
                            if(opp.License_Type__c == 'Perpetual')
                                {
                                    system.debug('license typepcl : '+ opp.License_Type__c);
                                    system.debug('Annual contract value pcl: '+ opp.Annual_contract_value__c);
                                    system.debug('Annual contract value convertedpcl: '+ dateCon.ConversionRate);
                                    opp.Total_contract_value__c = (opp.Annual_contract_value__c != null)?opp.Annual_contract_value__c/dateCon.ConversionRate:null;
                                    system.debug('tcv perpetualcl : '+ opp.Total_contract_value__c);
                                }
                           
                                else
                                if(opp.License_Type__c == 'Subscription')
                                {
                                    system.debug('license typesubcl : '+ opp.License_Type__c);
                                    system.debug('Annual contract value subcl : '+ opp.Annual_contract_value__c);
                                    system.debug('Annual contract value convertedsubcl : '+ dateCon.ConversionRate);
                                  
                                    opp.Total_contract_value__c = (opp.Annual_contract_value__c != null && opp.Subscription_Term__c != null)?((opp.Annual_contract_value__c/dateCon.ConversionRate)* Integer.valueOf(opp.Subscription_Term__c)):null;
                                    system.debug('Tcvsubcl: '+ opp.Total_contract_value__c);
                                }  
                            //divya
                        }
                        else
                            if(opp.StageName == '6 Closed/Won')
                            {
                                opp.Weigthed_Pipeline_NACV_in_Euro__c = opp.Normalized_ACVinEuro__c;
                                opp.Total_Pipeline_NACV_in_Euro__c = opp.Normalized_ACVinEuro__c;
                                opp.Mgmt_Expected_NACV_in_Euro__c = opp.Normalized_ACVinEuro__c;
                                //divya
                                if(opp.License_Type__c == 'Perpetual')
                                {
                                    opp.Total_contract_value__c = opp.ACV_in_Euro__c;
                                }
                                else
                                if(opp.License_Type__c == 'Subscription')
                                {
                                    
                                    opp.Total_contract_value__c = (opp.ACV_in_Euro__c != null && opp.Subscription_Term__c != null )?opp.ACV_in_Euro__c * Integer.valueOf(opp.Subscription_Term__c):null;
                                }
                                
                                //divya
                            }
                        else
                        {
                            if(opp.StageName !='0 Active (SQL)') {
                            opp.Weigthed_Pipeline_NACV_in_Euro__c = opp.Weighted_Normalized_ACV__c/dateCon.ConversionRate;
                            opp.Total_Pipeline_NACV_in_Euro__c = opp.Normalized_ACV__c/dateCon.ConversionRate;
                            opp.Mgmt_Expected_NACV_in_Euro__c = opp.Normalized_ACVMgmtCommit__c/dateCon.ConversionRate;
                            
                            }
                            //divya
                            if(opp.License_Type__c == 'Perpetual')
                                {
                                    system.debug('license typep!=0 : '+ opp.License_Type__c);
                                    system.debug('Annual contract value p!=0 : '+ opp.Annual_contract_value__c);
                                    system.debug('Annual contract value converted p!=0 : '+ dateCon.ConversionRate);
                                 
                                    opp.Total_contract_value__c = (opp.Annual_contract_value__c != null)?opp.Annual_contract_value__c/dateCon.ConversionRate:null;
                                    system.debug('tcv perpetual!=0 : '+ opp.Total_contract_value__c);
                                }
                                else
                                if(opp.License_Type__c == 'Subscription')
                                {
                                    {
                                        system.debug('license typesub!=0 : '+ opp.License_Type__c);
                                        system.debug('Annual contract value sub!=0 : '+ opp.Annual_contract_value__c);
                                        system.debug('Annual contract value converted sub!=0 : '+ dateCon.ConversionRate);
                                        
                                        opp.Total_contract_value__c = (opp.Annual_contract_value__c != null && opp.Subscription_Term__c != null)?((opp.Annual_contract_value__c/dateCon.ConversionRate).setScale(2)) * Integer.valueOf(opp.Subscription_Term__c):null;
                                        system.debug('Tcvsub!=0 : '+ opp.Total_contract_value__c);
                                    }
                                    
                                }
                            //}
                            //divya
                        } 
                            
                        
                        updatedOpp.add(opp);
                        /*Acv_In_Euro = opp.LIC_FYM_mgmt_commit__c/dateCon.ConversionRate; 
                        if(opp.ACV_mgmt_commit_in_Euro__c!=Acv_In_Euro){
                            oppId.add(opp.Id);
                            convertedCurr.put(opp.Id, Acv_In_Euro);} */
                    }
                }
                 System.debug('updatedOpp-->'+updatedOpp);
                //if(updatedOpp.size()!=0)  
                //        update updatedOpp;     
                            
            }
        
    }
}
}