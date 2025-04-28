@isTest
private class OpportunityUtils_Test {

    @isTest
    static void getOpportunityCountAndRevenue() {

        Account testAccount = new Account(
            Name = 'Test Utils',
            Rating = 'Hot',
            SLASerialNumber__c = '12345',
            SLAExpirationDate__c = Date.newInstance(2025, 5, 31),
            Sic = '123AB'
        );
        insert testAccount;

        List<Opportunity> testOpportunities = new List<Opportunity>{
            new Opportunity(Name = 'Test Opp 1', StageName = 'New', CloseDate = Date.today() +37, AccountId = testAccount.Id),
            new Opportunity(Name = 'Test Opp 2', StageName = 'Negotiation', CloseDate = Date.today() +37, AccountId = testAccount.Id),
            new Opportunity(Name = 'Test Opp 3', StageName = 'Quote sent', CloseDate = Date.today() +37, AccountId = testAccount.Id),
            new Opportunity(Name = 'Test Opp 4', StageName = 'Negotiation', CloseDate = Date.today() +37, AccountId = testAccount.Id),
            new Opportunity(Name = 'Test Opp 5', StageName = 'Quote sent', CloseDate = Date.today() +37, AccountId = testAccount.Id)
        };
        insert testOpportunities;

        // create a product
        Product2 testProduct = new Product2(Name = 'Test Product', IsActive = true, ProductCode = 'TP-001');
        insert testProduct;

        // get the standard pricebook Id
        Id pricebookId = Test.getStandardPricebookId();

        // create a Price Book Entry for the product
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = pricebookId,
            Product2Id = prod.Id,
            UnitPrice = 1000.00,
            IsActive = true
        );
        insert pbe;

        List<OpportunityLineItem> oppLineItem = new List<OpportunityLineItem>{
            new OpportunityLineItem(OpportunityId = testOpportunities[0].Id, Quantity = 10, PricebookEntryId = pbe.Id, TotalPrice = pbe.UnitPrice),
            new OpportunityLineItem(OpportunityId = testOpportunities[1].Id, Quantity = 15, PricebookEntryId = pbe.Id, TotalPrice = pbe.UnitPrice),
            new OpportunityLineItem(OpportunityId = testOpportunities[2].Id, Quantity = 20, PricebookEntryId = pbe.Id, TotalPrice = pbe.UnitPrice),
            new OpportunityLineItem(OpportunityId = testOpportunities[3].Id, Quantity = 25, PricebookEntryId = pbe.Id, TotalPrice = pbe.UnitPrice),
            new OpportunityLineItem(OpportunityId = testOpportunities[4].Id, Quantity = 30, PricebookEntryId = pbe.Id, TotalPrice = pbe.UnitPrice)
        };
        insert oppLineItem;

        Test.startTest();
        ContactUtils.getOpportunitiesFromContact(testContacts);
        Test.stopTest();

        Integer oppCount = [SELECT COUNT() FROM Opportunity WHERE AccountId =: testAccount.Id];
        System.assertEquals(15, oppCount, 'Test Utils Account should have 15 Oppportuities');
        Integer oppRevenueCount = [SELECT SUM(ExpectedRevenue) FROM Opportunity WHERE AccountId =: testAccount.Id];
        System.assertEquals(15, oppRevenueCount, 'Test Utils Account should have 15 Oppportuities');
    }
}
