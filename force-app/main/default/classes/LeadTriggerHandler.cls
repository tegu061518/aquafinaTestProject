public with sharing class LeadTriggerHandler extends TriggerHandler{
private List<Lead> newLeadList;
private Map<Id, Lead> oldLeadMap;

    public LeadTriggerHandler() {
        this.newLeadList = (List<Lead>) Trigger.new;
        this.oldLeadMap = (Map<Id, Lead>) Trigger.oldMap;
    }

    public override void afterInsert(){
        SM_Lead.convertLeads(this.newLeadList);
    }
    
    public override void afterUpdate(){
        SM_Lead.checkConvertedLeads(this.oldLeadMap, this.newLeadList);
    }
}