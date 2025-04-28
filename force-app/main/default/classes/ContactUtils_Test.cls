@isTest
private class ContactUtils_Test {

    @isTest
    static void testGetOpportunitiesFromContact() {
    
        Account createTestAccount = new Account(
            Name = 'Test Utils',
            Rating = 'Hot',
            SLASerialNumber__c = '12345',
            SLAExpirationDate__c = Date.newInstance(2025, 5, 31),
            Sic = '123AB'
        );
        insert createTestAccount;
        
        List<Opportunity> createTestOpportunities = new List<Opportunity>{
            new Opportunity(Name = 'Test Opp 1', StageName = 'New', CloseDate = Date.today() +37, AccountId = createcreateTestAccount.Id),
            new Opportunity(Name = 'Test Opp 2', StageName = 'Negotiation', CloseDate = Date.today() +37, AccountId = createcreateTestAccount.Id),
            new Opportunity(Name = 'Test Opp 3', StageName = 'Quote sent', CloseDate = Date.today() +37, AccountId = createcreateTestAccount.Id),
            new Opportunity(Name = 'Test Opp 4', StageName = 'Negotiation', CloseDate = Date.today() +37, AccountId = createcreateTestAccount.Id),
            new Opportunity(Name = 'Test Opp 5', StageName = 'Quote sent', CloseDate = Date.today() +37, AccountId = createcreateTestAccount.Id)
        };
        insert createTestOpportunities;

        List<Contact> createTestContacts = new List<Contact>{
            new Contact(FirstName = 'Keira', LastName = 'Bear1', Salutation = 'Ms.', AccountId = createTestAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear2', Salutation = 'Ms.', AccountId = createTestAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear3', Salutation = 'Ms.', AccountId = createTestAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear4', Salutation = 'Ms.', AccountId = createTestAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear5', Salutation = 'Ms.', AccountId = createTestAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear6', Salutation = 'Ms.', AccountId = createTestAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear7', Salutation = 'Ms.', AccountId = createTestAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear8', Salutation = 'Ms.', AccountId = createTestAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear9', Salutation = 'Ms.', AccountId = createTestAccount.Id),
            new Contact(FirstName = 'Keira', LastName = 'Bear10', Salutation = 'Ms.', AccountId = createTestAccount.Id)
        };
        insert createTestContacts;

        Test.startTest();
            ContactUtils.getOpportunitiesFromContact(createTestContacts);
        Test.stopTest();

        Integer oppCount = [SELECT COUNT() FROM Opportunity WHERE AccountId =: createTestAccount.Id];
        System.assertEquals(5, oppCount, 'Test Utils Account should have 5 Oppportuities');
    }
}