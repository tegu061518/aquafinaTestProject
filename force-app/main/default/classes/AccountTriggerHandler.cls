/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 04-10-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class AccountTriggerHandler extends TriggerHandler {
private List<Account> newAccountList;


    public AccountTriggerHandler(){
        this.newAccountList = (List<Account>) Trigger.new;
    } 

    public override void afterInsert(){
        SM_Account.createContactAndTask(new Map<Id, Account>(this.newAccountList).keySet());
    }
}

