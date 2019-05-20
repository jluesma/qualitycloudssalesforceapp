public class TriggerOnQuoteLine_Handler {

    public static void TriggerHandler(Boolean isDelete, List<SBQQ__QuoteLine__c> QuoteLineItems) {
         Set<id> quoteIds = new Set<id>();
         Map<id, List<SBQQ__QuoteLine__c>> mapOfQuoteToQuoteLines = new Map<id, List<SBQQ__QuoteLine__c>>();
         List<SBQQ__Quote__c> QuotesToBeUpdated = new List<SBQQ__Quote__c>();
         List<Opportunity> OppToBeUpdated = new List<Opportunity>();
         List<id> ToBeDeletedLines = new List<id>();
         
         //get the quote ids of the quote lines which are inserted or updated or deleted.
         for(SBQQ__QuoteLine__c lineItem : QuoteLineItems){
             quoteIds.add(lineItem.SBQQ__Quote__c);
             ToBeDeletedLines.add(lineitem.id);
         }
         
         //constructing the query for insert, update and delete
         string QueryStr = 'SELECT id, SBQQ__ProductCode__c, SBQQ__AdditionalDiscount__c,Net_Total_Annum__c, SBQQ__Quantity__c, SBQQ__RegularPrice__c, SBQQ__Quote__c from SBQQ__QuoteLine__c '; 
         if(isDelete){
             QueryStr += 'where SBQQ__Quote__c in : quoteIds AND id NOT IN: ToBeDeletedLines';
         }
         else {
             QueryStr += 'where SBQQ__Quote__c IN : quoteIds';
         }
         
         List<SBQQ__QuoteLine__c> QueryResult = Database.query(QueryStr);
         system.debug('here'+QueryResult);
         
         //construct a map of quote and its quote line items
         if(!QueryResult.isEmpty()) {
         
             for(SBQQ__QuoteLine__c quoteline :  QueryResult) {
                 if(!mapOfQuoteToQuoteLines.containsKey(quoteline.SBQQ__Quote__c))
                     mapOfQuoteToQuoteLines.put(quoteline.SBQQ__Quote__c,new List<SBQQ__QuoteLine__c>{quoteline});
                 else
                     mapOfQuoteToQuoteLines.get(quoteline.SBQQ__Quote__c).add(quoteline);
             }

             //Iterating quotelines for each quote
             for(SBQQ__Quote__c quote : [SELECT id,SBQQ__Opportunity2__c,SBQQ__Primary__c,Year__c,SBQQ__Type__c from SBQQ__Quote__c where id IN :mapOfQuoteToQuoteLines.keySet()]){
                 
                 SBQQ__Quote__c TempQuote = new SBQQ__Quote__c(id=quote.id);
                Opportunity TempOpp = new Opportunity(id=quote.SBQQ__Opportunity2__c);
                 double TempMaxLicenseDiscount = 0.00;
                 double TempMinLicenseDiscount = 1000.00;
                 double TempSupportDiscount = 0.00;
                 Decimal PSOAmount = 0;
                 Decimal PerpTotal = 0;
                 Decimal SubTotal = 0;
                 Decimal SuppTotal = 0;
                 Decimal Term = 1; 
                 Decimal AnnualContractValue = 0;
                 Decimal ConnectProductCount = 0;
                 
                 TempQuote.Contains_Connect_Product__c = false;
                 TempQuote.Contains_Perpetual_Product__c = false;
                 TempQuote.Contains_Subscription_Product__c = false;
                 TempQuote.Basic_service__c = false;
                 TempQuote.Intermediate_Service__c = false;
                 TempQuote.Advanced_Service__c = false;
                 
                
                 List<SBQQ__QuoteLine__c> quoteLines = new List<SBQQ__QuoteLine__c>();
                 quoteLines = mapOfQuoteToQuoteLines.get(quote.id);
                 
                     for(SBQQ__QuoteLine__c ql : quoteLines){
//updating Annual Contract value, Total contract value and PSO amount on the opportunity. We pick these values from the primary quote
                 system.debug('$$$$ Product code :' + ql.SBQQ__ProductCode__c);
                             if(ql.SBQQ__ProductCode__c.contains('BASIC')) {
                                 TempQuote.Basic_service__c = true;
                             }
                             if(ql.SBQQ__ProductCode__c.contains('INTERMEDIATE')) {
                                TempQuote.Intermediate_Service__c = true;
                             }
                             if(ql.SBQQ__ProductCode__c.contains('ADVANCED')) {
                                 TempQuote.Advanced_Service__c = true;
                             }
                             if(ql.SBQQ__ProductCode__c.contains('TCONN')) {
                                 TempQuote.Contains_Connect_Product__c = true;
                                 if(ql.SBQQ__Quantity__c == null){
                                     ql.SBQQ__Quantity__c = 0;
                                 }
                                 ConnectProductCount += ql.SBQQ__Quantity__c;
                             }
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
                             if(ql.SBQQ__ProductCode__c.contains('SUPP')) {
                                 if( ql.SBQQ__RegularPrice__c > 0) {
                                     if(((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c * ql.SBQQ__Quantity__c))*100 > TempSupportDiscount ) {
                                         TempSupportDiscount = ((ql.SBQQ__AdditionalDiscount__c)/(ql.SBQQ__RegularPrice__c  * ql.SBQQ__Quantity__c))*100;
                                     }
                                 }
                             }
                             
                             if(quote.SBQQ__Primary__c == true) {
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
                  if(quote.Year__c=='12 months')
                  Term = 1;
                  if(quote.Year__c=='24 months')
                  Term = 2;
                  if(quote.Year__c=='36 months')
                  Term = 3;
                  
                  if(quote.SBQQ__Type__c == 'Renewal'){
                      TempQuote.Contains_Perpetual_Product__c = false;
                  }
                  
                  TempQuote.Annual_Contract_Value_Subscription__c = AnnualContractValue;
                  TempQuote.License_Discount__c = TempMaxLicenseDiscount;
                  TempQuote.Min_License_Discount__c = TempMinLicenseDiscount;
                  TempQuote.Support_Discount__c = TempSupportDiscount;
                  TempQuote.Annual_Contract_Value__c = PerpTotal + (SubTotal/Term);// changed by Lister on Oct 5th 2017 - Removed adding support sum
                  TempQuote.Support_total__c = SuppTotal;
                  TempQuote.Connect_Products_Count__c = ConnectProductCount;
                  QuotesToBeUpdated.add(TempQuote);
                  if(quote.SBQQ__Primary__c == true)// changed by Lister on Oct 5th 2017  - Opportunity values defaulted to 0 when quote is not primary
                  {
                      TempOpp.PSO_Amount__c = PSOAmount;
                      TempOpp.Sum_value_of_perpetual_products__c = PerpTotal;
                      TempOpp.Sum_value_of_subscription_products__c= SubTotal;
                      TempOpp.Sum_value_of_support_products__c= SuppTotal;
                      TempOpp.Annual_contract_value__c = TempQuote.Annual_Contract_Value__c;
                      TempOpp.Total_contract_value1__c = PerpTotal + SubTotal; // changed by Lister on Oct 5th 2017 - Removed adding support sum
                  }
                  if(TempQuote.Contains_Perpetual_Product__c == true){
                      TempOpp.Subscription_Term__c = '1';
                  }
                  else if(TempQuote.Contains_Subscription_Product__c == true && TempQuote.Contains_Perpetual_Product__c == true){
                     TempOpp.Subscription_Term__c = TempOpp.Subscription_Term__c;
                  }
                  else{
                       TempOpp.Subscription_Term__c = String.valueOf(Term);
                  }
                 if(TempQuote.Contains_Perpetual_Product__c == true && TempQuote.Contains_Subscription_Product__c == false){
                     TempOpp.License_Type__c = 'Perpetual';
                 }else if(TempQuote.Contains_Subscription_Product__c == true && TempQuote.Contains_Perpetual_Product__c == false){
                     TempOpp.License_Type__c = 'Subscription';
                 }
                 system.debug(TempQuote.Annual_Contract_Value__c+'=ql1=');
                 system.debug(TempOpp.Annual_contract_value__c+'=ql='+TempOpp.Total_contract_value1__c);
                  OppToBeUpdated.add(TempOpp); 
              }
             try{
                     update QuotesToBeUpdated; 
                     //update OppToBeUpdated;
             }catch(Exception e){
                 for(SBQQ__Quote__c quote: QuotesToBeUpdated){
                     quote.addError(e);
                 }
             }
                   
          }
          
          else {
              for(SBQQ__Quote__c quote : [SELECT id,SBQQ__Opportunity2__c from SBQQ__Quote__c where id IN : quoteIds]) {
                  SBQQ__Quote__c TempQuote = new SBQQ__Quote__c(id=quote.id);
                  Opportunity TempOpp = new Opportunity(id=quote.SBQQ__Opportunity2__c);
                  TempQuote.Contains_Connect_Product__c = false;
                  TempQuote.Contains_Perpetual_Product__c = false;
                  TempQuote.Contains_Subscription_Product__c = false;
                  TempQuote.Basic_service__c = false;
                  TempQuote.Intermediate_Service__c = false;
                  TempQuote.Advanced_Service__c = false;
                  TempQuote.License_Discount__c = 0;
                  TempQuote.Support_Discount__c = 0;
                  
                  TempOpp.PSO_Amount__c = 0;
                  QuotesToBeUpdated.add(TempQuote);
                  OppToBeUpdated.add(TempOpp); 
              }
              
                  update QuotesToBeUpdated;   
                  update OppToBeUpdated;
              
          }
       
    }
}