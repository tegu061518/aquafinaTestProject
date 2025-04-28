public without sharing class DM_Contact {

    // proper naming convention, must be meaningful, updates 'checkContacts' 
    // and make sure that it shows or explains what it needs to do 
    public static List<Contact> getConByLeadsId(Set<Id> leadIds) {
        System.debug('Contact Id' + leadIds);

            List<Contact> checkContacts = [SELECT Id FROM Contact WHERE Id IN :leadIds];
            System.debug('Leads converted from Contacts: ' + checkContacts);

            return checkContacts;
    }

    public static List<Contact> getContactsByOppAccountId(Set<Id> accountIds){
        System.debug('Opportunity Account Id' + accountIds);

            List<Contact> searchContactsByAccId = [SELECT Id FROM Contact WHERE AccountId IN :accountIds];
            System.debug('Contacts from Account' +searchContactsByAccId);

            return searchContactsByAccId;
    }

    public static list<Contact> getProspectAccounts(Set<Id> prospectAccountTypes) {

        List<AggregateResult> prospectContacts = [SELECT AccountId, COUNT(Id) FROM Contact WHERE AccountId IN :prospectAccountTypes GROUP BY AccountId];
        System.debug('Queried Accounts' +prospectContacts);

        return prospectContacts;

    }

}