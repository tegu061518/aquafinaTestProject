/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-10-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class QuoteController extends TriggerHandler{
    List<SObject> newQuoteList = new List<SObject>();

    public QuoteController(){
        this.newQuoteList = (List<Quote>) Trigger.new;
    }
    
    public override void beforeUpdate(){
        for(Quote Quote :this.newQuoteList){
            if(Quote.Status == 'Accepted'){
                Quote.ready_for_delivery__c = true;
            }
        }
        }
    }
