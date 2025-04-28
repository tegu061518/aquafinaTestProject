public with sharing class SM_Opportunity {

    public static void createContactRole(List<Opportunity> newOpportunityList) {
        List<OpportunityContactRole> rolesToInsert = new List <OpportunityContactRole>();
        Set<Id> accountIds = new Set<Id>();

        for(Opportunity opp : newOpportunityList){
            if (opp.AccountId != null){
                accountIds.add(opp.AccountId);
            }
        }

        List<Contact> contactList = new List<Contact>(DM_Contact.getContactsByOppAccountId(accountIds));

        //logic to loop through Opportunities then create roles if Account has Contacts
        //perform oppContactRole for each Contact, no need to be primary

        for (Opportunity opp : newOpportunityList) {
                for(Contact con :contactList) {
                rolesToInsert.add(
                    new OpportunityContactRole(
                        OpportunityId = opp.Id,
                        ContactId = con.Id,
                        Role = 'Business User',
                        IsPrimary = true) 
                    );
                }
            }
            
            insert rolesToInsert; 
        }

    public static void updateClientFieldOnAccount(Map<Id, Opportunity> closedWonOpportunitiesOldMap, List<Opportunity> closedWonOpportunities) {
        Set<Id> closedWonAccIds = new Set<Id>();

        for(Opportunity updatedOpp : closedWonOpportunities) {
            if(updatedOpp.StageName == 'Won' && closedWonOpportunitiesOldMap.get(updatedOpp.Id).StageName != 'Won'){
                closedWonAccIds.add(updatedOpp.AccountId);
            }
        }

        //pass accountIds of Opptunities with Stage = Closed Won to get related Accounts
        List<Account> relatedAccounts = new List<Account>(DM_Account.getAccountByClosedWonOpp(closedWonAccIds));

        for(Account accountsToUpdate : relatedAccounts){
            accountsToUpdate.Client__c = true;
        }

        update relatedAccounts;
    }

    public static void createTaskForUpdatedOpps(List<Opportunity> ppqOpportunities){
        List<Task> tasksToCreate = new List<Task>();
        
            for(Opportunity ppqOpportunity : ppqOpportunities){
                if(ppqOpportunity.StageName == 'Proposal/Price Quote' && ppqOpportunity.StageName != 'Won'){
                    Task createTaskWithReminder = new Task(
                        OwnerId = ppqOpportunity.OwnerId,
                        WhatId = ppqOpportunity.Id,
                        Subject = 'Email',
                        TaskSubtype = 'Task',
                        Status = 'Not Started',
                        ActivityDate = Date.today(),
                        ReminderDateTime = Date.today() + 3,
                        IsReminderSet = true
                    );

                    tasksToCreate.add(createTaskWithReminder);
            }
        }
        insert tasksToCreate;
    }
}