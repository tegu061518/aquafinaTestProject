/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-10-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class QuoteService {

    public static void updateQuoteReadyForDelivery (List<Quote> quoteList) {
        for(Quote quote : quoteList){
            if(quote.Status == 'Accepted'){
                quote.ready_for_delivery__c = true;
            }
        }

        update quoteList;
    }
}