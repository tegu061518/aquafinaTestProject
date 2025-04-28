public with sharing class OpportunityTriggerHandler extends TriggerHandler {
    private List<Opportunity> newOpportunityList;
    private Map<Id, Opportunity> oldOpportunityMap;

    public OpportunityTriggerHandler() {
        this.newOpportunityList = (List<Opportunity>) Trigger.new;
        this.oldOpportunityMap = (Map<Id, Opportunity>) Trigger.oldMap;
    }

    public override void afterInsert(){
        SM_Opportunity.createContactRole(this.newOpportunityList);
        OpportunityUtils.getOpportunityCountAndRevenue(this.newOpportunityList);
    }

    public override void afterUpdate(){
        SM_Opportunity.updateClientFieldOnAccount(this.oldOpportunityMap, this.newOpportunityList);
        SM_Opportunity.createTaskForUpdatedOpps(this.newOpportunityList);
        OpportunityUtils.getOpportunityCountAndRevenue(this.newOpportunityList);
    }
}
