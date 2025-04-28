public with sharing class ContactTriggerHandler extends TriggerHandler {
private List<Contact> newContactList;

    public ContactTriggerHandler(){
        this.newContactList = (List<Contact>) Trigger.new;
    }
    public override void afterInsert() {
        SM_Contact.checkContactsInserted(newContactList);
        ContactUtils.getOpportunitiesFromContact(newContactList);
    } 
}
