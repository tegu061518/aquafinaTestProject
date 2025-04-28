public with sharing class DM_Account {

    public static list<Account> getAccounts(Set<Id> accountIds) {
        System.debug('Created Account Ids' +accountIds);

        List<Account> createdAccounts = [SELECT Id, Name FROM Account WHERE Id =:accountIds];
        System.debug('Queried Accounts' +createdAccounts);

        return createdAccounts;

    }

    public static list<Account> getAccountByClosedWonOpp(Set<Id> closedWonAccIds){
    
        List<Account> existingAccounts = [SELECT Id FROM Account WHERE Id =:closedWonAccIds];
        System.debug('Queried Accounts' +existingAccounts);

        return existingAccounts;
    }

    public static list<Account> getProspectAccounts(Set<Id> prospectAccIds){
    
        List<Account> prospectAccounts = [SELECT Id FROM Account WHERE Id =:prospectAccIds AND Type = 'Prospect'];
        System.debug('Queried Accounts' +prospectAccounts);

        return prospectAccounts;
    }
}