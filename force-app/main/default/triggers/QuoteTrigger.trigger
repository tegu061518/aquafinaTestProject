/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-08-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
// trigger QuoteTrigger on Quote (before update) {
//    for(Quote quote : Trigger.new) {
//        if(quote.Status == 'Accepted'){
//           quote.ready_for_delivery__c = true;
//        }
//    }
// }

trigger QuoteTrigger on Quote (before update) {
        if(Trigger.isBefore){
            if(Trigger.isInsert){
                QuoteController.qcontroller(Trigger.new);
            }
        }
}

