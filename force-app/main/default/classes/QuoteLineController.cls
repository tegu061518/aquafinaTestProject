/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-04-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class QuoteLineController {
    
    @AuraEnabled(cacheable=true)
    public static List<QuoteLineItem> qlList(String quoteId) {
        // Validate the input parameter
        if (String.isBlank(quoteId)) {
            throw new AuraHandledException('QuoteId is required to fetch Quote Line Items.');
        }
        
        // Query Quote Line Items related to the provided QuoteId
        return [
            SELECT Id, Product2.Name, UnitPrice, Quantity
            FROM QuoteLineItem
            WHERE QuoteId = :quoteId
        ];
    }
}