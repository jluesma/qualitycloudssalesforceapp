public class TriggerOnQuote_Handler{
    public static void TriggerHandler_BeforeUpdate(List<SBQQ__Quote__c> QuotesToBeUpdated){
    
       Set<id> quoteIds = new Set<id>();
       Map<id, List<SBQQ__QuoteLine__c>> mapOfQuoteToQuoteLines = new Map<id, List<SBQQ__QuoteLine__c>>();
       
       for(SBQQ__Quote__c Quotes : QuotesToBeUpdated) {
            quoteIds.add(Quotes.id);   
            Quotes.SBQQ__WatermarkShown__c = true;
            if(Quotes.Legal_Notes__c != NULL)
                Quotes.Contains_Legal_Notes__c = true;
            else
                Quotes.Contains_Legal_Notes__c = false;
            if(Quotes.SBQQ__Status__c == 'Accepted' || Quotes.SBQQ__Status__c == 'Approved') {
                Quotes.SBQQ__WatermarkShown__c = false;
            } 
       }
       
       List<SBQQ__QuoteLine__c> quoteLinesQuery = [SELECT id, SBQQ__ProductFamily__c,SBQQ__ListTotal__c, SBQQ__ProductCode__c,SBQQ__ListPrice__c, SBQQ__NetTotal__c, SBQQ__AdditionalDiscount__c,Net_Total_Annum__c, SBQQ__Quantity__c, SBQQ__RegularPrice__c, SBQQ__Quote__c from SBQQ__QuoteLine__c where SBQQ__Quote__c in : quoteIds];
       
       if(!quoteLinesQuery.isEmpty()) {
       
           for(SBQQ__QuoteLine__c QL : quoteLinesQuery) {
               if(!mapOfQuoteToQuoteLines.containsKey(QL.SBQQ__Quote__c))
                         mapOfQuoteToQuoteLines.put(QL.SBQQ__Quote__c,new List<SBQQ__QuoteLine__c>{QL});
               else
                         mapOfQuoteToQuoteLines.get(QL.SBQQ__Quote__c).add(QL);
           }
       
           for(SBQQ__Quote__c TempQuote : QuotesToBeUpdated) {
               List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
               system.debug(mapOfQuoteToQuoteLines.containskey(TempQuote.id));
               quoteLines = mapOfQuoteToQuoteLines.get(TempQuote.id);
               
               double TempMaxLicenseDiscount = 0.00;
               double TempMinLicenseDiscount = 1000.00;
               double TempSupportDiscount = 0.00;
               Decimal PSOAmount = 0;
               Decimal PerpTotal = 0;
               Decimal SubTotal = 0;
               Decimal SuppTotal = 0;
               Decimal Term = 1; 
               Decimal AnnualContractValue = 0;
               
               Decimal AggregateLicenseDiscount = 0;
               Decimal SumOfNetTotalsExcludingSAP = 0;  
               Decimal SumOfListUnitPrices = 0;   
               Decimal SumOfPerpetualNetTotals =0;
               Decimal SumOfSupportTotals = 0;
                 
                 TempQuote.Contains_Connect_Product__c = false;
                 TempQuote.Contains_Perpetual_Product__c = false;
                 TempQuote.Contains_Subscription_Product__c = false;
               
               for(SBQQ__QuoteLine__c ql : quoteLines){
                   
                   if(ql.SBQQ__ProductCode__c.contains ('SERV_PACKAGE') || ql.SBQQ__ProductCode__c.contains('PERP')){
                             TempQuote.Perpetual_and_Service_Package_Product__c = true;
                         }
                   if(ql.SBQQ__ProductCode__c.contains ('SERV_PACKAGE')){
                       if(ql.SBQQ__RegularPrice__c > 0) {
                         if(((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100 > TempMaxLicenseDiscount) {
                             TempMaxLicenseDiscount = ((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100;
                         } 
                     }
                     
                     if(ql.SBQQ__RegularPrice__c > 0) {
                         if(((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100 < TempMinLicenseDiscount) {
                             TempMinLicenseDiscount = ((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100;
                         } 
                      }
                   }

//calculate the aggregate license discount
                if(ql.SBQQ__ProductFamily__c =='Perpetual') {
                    if(ql.SBQQ__RegularPrice__c > 0) {
                        if(ql.SBQQ__NetTotal__c!=null){
                            SumOfPerpetualNetTotals += ql.SBQQ__NetTotal__c;
                        if(!ql.SBQQ__ProductCode__c.contains('SAP') && !ql.SBQQ__ProductCode__c.contains('TCONN')) {
                            SumOfNetTotalsExcludingSAP += ql.SBQQ__NetTotal__c;
                            SumOfListUnitPrices += ql.SBQQ__ListTotal__c;
                         }
                        }
                    }
                }
               
                if(ql.SBQQ__ProductFamily__c =='Maintenance') {
                    //if(!ql.SBQQ__ProductCode__c.contains('SAP')) {
                    if(ql.SBQQ__NetTotal__c != null){                   
                        SumOfSupportTotals += ql.SBQQ__NetTotal__c;
                    }
                    //}
                }
               
//checks for connect product                  
                   if(ql.SBQQ__ProductCode__c.contains('TCONN')) {
                                 TempQuote.Contains_Connect_Product__c = true;
                   }

//Discount value for the perpetual products is calculated and check the checkbox if we have got subscription products
                   if(ql.SBQQ__ProductCode__c.contains('PERP')) {
                         TempQuote.Contains_Perpetual_Product__c = true; 
                         system.debug('$$$$ Perp License value:' + ql.SBQQ__AdditionalDiscount__c);
                     if(ql.SBQQ__RegularPrice__c > 0) {
                         if(((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100 > TempMaxLicenseDiscount) {
                             TempMaxLicenseDiscount = ((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100;
                         } 
                     }
                     
                     if(ql.SBQQ__RegularPrice__c > 0) {
                         if(((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100 < TempMinLicenseDiscount) {
                             TempMinLicenseDiscount = ((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100;
                         } 
                      }      
                   }
                              
//Annual contract value for the subscription products is calculated and check the checkbox if we have got subscription products
                   if(ql.SBQQ__ProductCode__c.contains('SUB')) {
                         TempQuote.Contains_Subscription_Product__c = true;
                         system.debug('$$$$ Net Total :' + ql.Net_Total_Annum__c);
                         AnnualContractValue += ql.Net_Total_Annum__c;
                       if(ql.SBQQ__RegularPrice__c > 0) {
                         if(((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100 > TempMaxLicenseDiscount) {
                             TempMaxLicenseDiscount = ((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100;
                         } 
                     }
                     
                     if(ql.SBQQ__RegularPrice__c > 0) {
                         if(((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100 < TempMinLicenseDiscount) {
                             TempMinLicenseDiscount = ((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100;
                         } 
                      } 
                   }
                             
//calculate the support discount 
                  if(ql.SBQQ__ProductCode__c.contains('SUPP')) {
                     if( ql.SBQQ__RegularPrice__c > 0) {
                         if(((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100 > TempSupportDiscount ) {
                             TempSupportDiscount = ((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c  * ql.SBQQ__Quantity__c))*100;
                         }
                     }
                  }
                   
                             
                     if(TempQuote.SBQQ__Primary__c == true) {
                         if(ql.SBQQ__ProductCode__c.contains('SERV_PACKAGE')) {
                             if( ql.SBQQ__RegularPrice__c > 0) {
                                PSOAmount += (ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c);
                             }
                         }
                         if(ql.SBQQ__ProductCode__c.contains('PERP')) {
                             if( ql.SBQQ__RegularPrice__c > 0) {
                                PerpTotal += (ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c);
                             }
                         }
                         if(ql.SBQQ__ProductCode__c.contains('SUB')) {
                             if( ql.SBQQ__RegularPrice__c > 0) {
                                SubTotal += (ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c);
                             }
                         }
                         if(ql.SBQQ__ProductCode__c.contains('SUPP')) {
                             if( ql.SBQQ__RegularPrice__c > 0) {
                                SuppTotal += (ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c);
                             }
                         }
                     }

                         
                     } 
                  if(SumOfListUnitPrices>0){
                      AggregateLicenseDiscount = ((SumOfListUnitPrices - SumOfNetTotalsExcludingSAP)*100)/SumOfListUnitPrices;
                  }
                  
                  if(TempQuote.SBQQ__Type__c == 'Renewal')
                      TempQuote.Contains_Perpetual_Product__c = false;
                  TempQuote.Annual_Contract_Value_Subscription__c = AnnualContractValue;
                  TempQuote.License_Discount__c = TempMaxLicenseDiscount;
                  if(TempMinLicenseDiscount == 1000)
                      TempMinLicenseDiscount = 0;
                  TempQuote.Min_License_Discount__c = TempMinLicenseDiscount;
                  TempQuote.Support_Discount__c = TempSupportDiscount;
                  TempQuote.Annual_Contract_Value__c = SumOfPerpetualNetTotals + AnnualContractValue + SumOfSupportTotals;
                  TempQuote.Support_total__c = SuppTotal;
                  
                  TempQuote.Aggregate_License_Discount__c = AggregateLicenseDiscount;
                  system.debug(TempQuote.Annual_Contract_Value__c + '='+ TempQuote.SBQQ__NetAmount__c );
              }
           }
      
          else{
          for (SBQQ__Quote__c Q : QuotesToBeUpdated) {
              Q.Annual_Contract_Value_Subscription__c = 0;
              Q.License_Discount__c = 0;
              Q.Min_License_Discount__c =0;
              Q.Support_Discount__c = 0;
              Q.Annual_Contract_Value__c = 0;
              Q.Support_total__c = 0;
              Q.Contains_Connect_Product__c = false;
              Q.Contains_Perpetual_Product__c = false;
              Q.Contains_Subscription_Product__c = false;
          }
          
          }
       }  
       
    public static void triggerhandler_AfterUpdate(List<SBQQ__Quote__c> triggernew, Map<ID,SBQQ__Quote__c> oldmap, Map<ID,SBQQ__Quote__c> newmap){
        list<Opportunity> listOfOpportunity = new list<Opportunity>();
        Map<id, List<SBQQ__QuoteLine__c>> mapOfQuoteToQuoteLines = new Map<id, List<SBQQ__QuoteLine__c>>();
        list<Id> listOfQuote = new list<Id>();
        for(SBQQ__Quote__c quote: triggernew){
            if(quote.SBQQ__Primary__c == true){
                listOfQuote.add(quote.Id);
            }
        }
        for (list<SBQQ__QuoteLine__c> listoflines: [SELECT Id,SBQQ__RegularPrice__c,SBQQ__Quantity__c,SBQQ__ProductCode__c,SBQQ__Quote__c from SBQQ__QuoteLine__c where SBQQ__Quote__c in: listOfQuote]){
            for(SBQQ__QuoteLine__c ql: listoflines){
                if(!mapOfQuoteToQuoteLines.containsKey(ql.SBQQ__Quote__c))
                     mapOfQuoteToQuoteLines.put(ql.SBQQ__Quote__c,new List<SBQQ__QuoteLine__c>{ql});
                 else
                     mapOfQuoteToQuoteLines.get(ql.SBQQ__Quote__c).add(ql);
            } 
        }
        
        for(SBQQ__Quote__c quote : [SELECT id,SBQQ__Opportunity2__c,SBQQ__Primary__c,Year__c,SBQQ__Type__c,Annual_Contract_Value__c,Contains_Subscription_Product__c,Contains_Perpetual_Product__c,SBQQ__NetAmount__c from SBQQ__Quote__c where id IN :mapOfQuoteToQuoteLines.keySet()]){
            system.debug(quote.Annual_Contract_Value__c + '='+ quote.SBQQ__NetAmount__c );
            if(quote.SBQQ__Primary__c){
            List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
            Opportunity Opptoadd = new Opportunity(id=quote.SBQQ__Opportunity2__c);
            quoteLines = mapOfQuoteToQuoteLines.get(quote.id);
            Decimal PSOAmount = 0;
            Decimal PerpTotal = 0;
            Decimal SubTotal = 0;
            Decimal SuppTotal = 0;
            Decimal Term = 1;
            for(SBQQ__QuoteLine__c ql: quoteLines){
                if(ql.SBQQ__ProductCode__c.contains('SERV_PACKAGE')) {
                    if( ql.SBQQ__RegularPrice__c > 0) {
                        PSOAmount += (ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c);
                    }
                }
                if(ql.SBQQ__ProductCode__c.contains('PERP')) {
                    if( ql.SBQQ__RegularPrice__c > 0) {
                        PerpTotal += (ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c);
                    }
                }
                if(ql.SBQQ__ProductCode__c.contains('SUB')) {
                    if( ql.SBQQ__RegularPrice__c > 0) {
                        SubTotal += (ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c);
                    }
                }
                if(ql.SBQQ__ProductCode__c.contains('SUPP')) {
                    if( ql.SBQQ__RegularPrice__c > 0) {
                        SuppTotal += (ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c);
                    }
                }
            }
            
            if(quote.Year__c=='24 months')
                Term = 2;
            if(quote.Year__c=='36 months')
                Term = 3;
            Opptoadd.PSO_Amount__c = PSOAmount;
            Opptoadd.Sum_value_of_perpetual_products__c = PerpTotal;
            Opptoadd.Sum_value_of_subscription_products__c= SubTotal;
            Opptoadd.Sum_value_of_support_products__c= SuppTotal;
            Opptoadd.Annual_contract_value__c = quote.Annual_Contract_Value__c;
            Opptoadd.Total_contract_value1__c = quote.SBQQ__NetAmount__c; //changed by lister
            if(quote.Contains_Subscription_Product__c == true && quote.Contains_Perpetual_Product__c == true){
                Opptoadd.Subscription_Term__c = Opptoadd.Subscription_Term__c;
            }
            else if(quote.Contains_Perpetual_Product__c == true){
                Opptoadd.Subscription_Term__c = '1';
            }
            
            else{
                Opptoadd.Subscription_Term__c = String.valueOf(Term);
            }
            if(quote.Contains_Perpetual_Product__c == true && quote.Contains_Subscription_Product__c == false){
                Opptoadd.License_Type__c = 'Perpetual';
            }else if(quote.Contains_Subscription_Product__c == true && quote.Contains_Perpetual_Product__c == false){
                Opptoadd.License_Type__c = 'Subscription';
            }
            system.debug(Opptoadd.Annual_Contract_Value__c + '==='+ Opptoadd.Total_contract_value1__c );
            
            listOfOpportunity.add(Opptoadd);
        }
        }
        try{
            update listOfOpportunity;
        }catch(exception e){
            for(SBQQ__Quote__c quote: triggernew){
                quote.addError(e);
            }
        }
    }
}