/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-10-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger AccountAddressTrigger on Account (before insert, before update) {

    for (Account Acc: Trigger.new) {
        if(Acc.Match_Billing_Address__c == true){
            Acc.ShippingPostalCode = Acc.BillingPostalCode;
        }
        }
}

