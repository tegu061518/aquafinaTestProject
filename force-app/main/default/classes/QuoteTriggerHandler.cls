/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-10-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class QuoteTriggerHandler extends TriggerHandler {

    public override void beforeUpdate() {
        for(Quote quote : (List<Quote>) Trigger.new){
            if(quote.Status == 'Accepted'))
        }

    }
}