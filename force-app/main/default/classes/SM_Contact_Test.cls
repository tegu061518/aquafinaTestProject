@isTest
private class SM_Contact_Test {

    @isTest
    static void checkContactsInserted() {

        Account testAccount = new Account(
            Name = 'Honda',
            Rating = 'Hot',
            SLA__c = 'Silver',
            SLASerialNumber__c = '123456',
            SLAExpirationDate__c = Date.newInstance(2025, 5, 31),
            Sic = '123ABC',
            Type = 'Prospect'
        );
        insert testAccount;
    
        List<Contact> testContact = new List<Contact>{
            new Contact(FirstName = 'Keira', LastName = 'Bear1', Salutation = 'Ms.', AccountId = testAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear2', Salutation = 'Ms.', AccountId = testAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear3', Salutation = 'Ms.', AccountId = testAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear4', Salutation = 'Ms.', AccountId = testAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear5', Salutation = 'Ms.', AccountId = testAccount.Id)
        };
        insert testContact;

        Test.startTest();
            SM_Contact.checkContactsInserted(testContact);
        Test.stopTest();

        List<Opportunity> result = [SELECT Id, Name FROM Opportunity WHERE AccountId =: testAccount.Id LIMIT 1];
        System.assertEquals(1, result.size(), 'These should be 1 Prospect Opportunity Createad');
    }
}