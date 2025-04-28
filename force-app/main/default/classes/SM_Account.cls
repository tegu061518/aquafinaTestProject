public with sharing class SM_Account {

    public static void createContactAndTask(Set<Id> accountIds) {
    
        //call DM_Accounts for created Accounts
        List<Account> accountList = new List<Account>(DM_Account.getAccounts(accountIds));

        //make a list for Contacts & Tasks and bulkify create
        List<Contact> contactList = new List<Contact>();
        List<Task> createTasks = new List<Task>();

        for(Account acc : accountList){
            Contact createContact = new Contact(
                FirstName = 'Default Contact ',
                LastName = acc.Name,
                AccountId = acc.Id,
                Salutation = 'Mr.'
            );
            contactList.add(createContact);

        }
        insert contactList;

        for(Contact con : contactList){
            Task createtask = new Task(
            WhatId = con.AccountId,
            WhoId = con.Id,
            Priority = 'Normal',
            Subject = 'Call',
            TaskSubtype = 'Task',
            Status = 'Not Started',
            ActivityDate = Date.newInstance(2025, 4, 30)
            );
            createTasks.add(createtask);
        }

        insert createTasks;
    }
}