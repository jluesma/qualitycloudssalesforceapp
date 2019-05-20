/*
        Name: CurrencyConversionHandler 
        Discription: Class to Convert other currency into euro
        Created by: Bavitha P
        Test Class: TestCurrencyConversionHandler

    Change History
	   *********************************************************************************************************************************************
	   ModifiedBy        Date          Ticket No.      Requested By      Description                                                             Tag
	   *********************************************************************************************************************************************                                     					                                                                                                                                       
*/


public class CurrencyConversionHandler {
    @InvocableMethod
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
            createdDate = opp.CreatedDate.date();
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
                for(Opportunity opp:Opportunities){
                    DatedConversionRate dateCon = new DatedConversionRate();
                    double Acv_In_Euro =0;
                    dateCon = exchangeRateMap.get(opp.CreatedDate.date()+'-'+opp.CurrencyIsoCode);
                    if(dateCon!=null && opp.LIC_FYM_mgmt_commit__c!=null && dateCon.ConversionRate!=0){
                        Acv_In_Euro = opp.LIC_FYM_mgmt_commit__c/dateCon.ConversionRate; 
                        if(opp.ACV_mgmt_commit_in_Euro__c!=Acv_In_Euro){
                            oppId.add(opp.Id);
                            convertedCurr.put(opp.Id, Acv_In_Euro);}
                    }
                }
                 System.debug('oppId.size():::::'+oppId.size());
                if(oppId.size()!=0){
                    List<Opportunity> oppList = new List<Opportunity>();
                    oppList = [Select id,ACV_mgmt_commit_in_Euro__c,LIC_FYM_mgmt_commit__c from Opportunity where id in :oppId];
                    for(Opportunity oppUpdate : oppList){
                        oppUpdate.ACV_mgmt_commit_in_Euro__c = convertedCurr.get(oppUpdate.id);
                        oppUpdateList.add(oppUpdate);
                    }
                    System.debug('oppUpdateList.size():::::'+oppUpdateList.size());
                    if(oppUpdateList.size()!=0)  
                        update oppUpdateList;  
                }                
            }
        }
    }
}