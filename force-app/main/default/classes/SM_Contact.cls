//task flow on tebins brain:
//x numbers of contact is inserted / created
//for each contact, chech if account is of type 'prospect'
//if yes, store on a list to check if account has more than 2 contacts
//if yes, for each account, create an opportunity

public with sharing class SM_Contact {

public static void checkContactsInserted(List<Contact> insertedContacts) {
Set<Id> prospectAccountTypes = new Set<Id>();

        for(Contact con : insertedContacts){
            prospectAccountTypes.add(con.AccountId);
        }

        //call DM_Account and look for 'Prospect' AccountTypes from the inserted Contacts
        List<Account> prospectAccounts = new List<Account>(DM_Account.getProspectAccounts(prospectAccountTypes));

        //hold prospect Acc Ids
        Set<Id> prospectAccIds = new Set<Id>();
        for(Account acc : prospectAccounts){
            prospectAccIds.add(acc.Id);
        }    
        
        List<Id> accountsToHaveOpp = new List<Id>();

        //aggregate query to look for contacts and count them per AccountId
        List<AggregateResult> contactCountResults = [SELECT COUNT(Id) contactCount, AccountId 
                                                     FROM Contact 
                                                     WHERE AccountId IN :prospectAccIds 
                                                     GROUP BY AccountId];

        for(AggregateResult result : contactCountResults){
            Integer count = (Integer) result.get('contactCount');
            Id accountId = (Id) result.get('AccountId');
            
            if(count > 2){
                accountsToHaveOpp.add(accountId);
            }
        }

        //make a list for opportunities to create 
        List<Opportunity> opportunitiesToCreate = new List<Opportunity>();

        for(Id accountId : accountsToHaveOpp){
                Opportunity opp = new Opportunity(
                Name = 'Prospect Opportunity',
                StageName = 'New',
                CloseDate = Date.today() + 7,
                AccountId = accountId
            );
            opportunitiesToCreate.add(opp);
        }
            insert opportunitiesToCreate;
    }
}
        

