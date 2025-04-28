/**
 * This class contains unit tests for validating the behavior of Apex classes
 * and triggers.
 *
 * Unit tests are class methods that verify whether a particular piece
 * of code is working properly. Unit test methods take no arguments,
 * commit no data to the database, and are flagged with the testMethod
 * keyword in the method definition.
 *
 * All test methods in an org are executed whenever Apex code is deployed
 * to a production org to confirm correctness, ensure code
 * coverage, and prevent regressions. All Apex classes are
 * required to have at least 75% code coverage in order to be deployed
 * to a production org. In addition, all triggers must have some code coverage.
 * 
 * The @isTest class annotation indicates this class only contains test
 * methods. Classes defined with the @isTest annotation do not count against
 * the org size limit for all Apex scripts.
 *
 * See the Apex Language Reference for more information about Testing and Code Coverage.
 */
@isTest
private class SM_OpportunityTest {

    @isTest
    static void testCreateContactRole() 
    {
        Account testAccount = new Account(
            Name = 'Yamaha'
        );
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Kevin',
            LastName = 'Guyo',
            Salutation = 'Mr.',
            AccountId = testAccount.Id
        );
        insert testContact;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Suzuki',
            CloseDate = Date.newInstance(2025, 4, 30),
            StageName = 'Prospecting',
            AccountId = testAccount.Id
        );
        insert testOpportunity;

        OpportunityContactRole testOCR = new OpportunityContactRole(
            OpportunityId = testOpportunity.Id,
            ContactId = testContact.Id,
            IsPrimary = true
        );
        insert testOCR;

        Test.startTest();
        List<OpportunityContactRole> ocrList = [SELECT Id FROM OpportunityContactRole WHERE OpportunityId =: testOpportunity.Id LIMIT 1];
        System.assertEquals(1, ocrList.size(), 'An Opportunity Contact Role has been Created');
        Test.stopTest();        
    }

    @isTest
    static void testUpdateClientFieldOnAccount() {

        Account testAccount = new Account(
            Name = 'Test',
            SLA__C = 'Gold',
            SLAExpirationDate__c = Date.newInstance(2025, 5, 31),
            SLASerialNumber__c = '123'
        );
        insert testAccount;

        List<Opportunity> newTestOpp = new List<Opportunity>{
        new Opportunity(Name = 'Test Opp 1', StageName = 'New', CloseDate = Date.today() +37, AccountId = testAccount.Id),
        new Opportunity(Name = 'Test Opp 2', StageName = 'Negotiation', CloseDate = Date.today() +37, AccountId = testAccount.Id),
        new Opportunity(Name = 'Test Opp 2', StageName = 'Quote sent', CloseDate = Date.today() +37, AccountId = testAccount.Id)
        };
        insert newTestOpp;
        
        //perform update
        Map<Id, Opportunity> insertedOldOppsToUpdate = new Map<Id, Opportunity>(newTestOpp);

        for(Opportunity oppToUpdate : newTestOpp){
            oppToUpdate.StageName = 'Won';
        }
        update newTestOpp;

        Test.startTest();
        SM_Opportunity.updateClientFieldOnAccount(insertedOldOppsToUpdate, newTestOpp);
        List<Account> updatedClient = [SELECT Id FROM Account WHERE Id =: testAccount.Id LIMIT 1];
        System.assertEquals(1, updatedClient.size(), 'An Account has been updated');
        Test.stopTest();  
    }

    @isTest
    static void testCreateTaskForUpdatedOpps() {

        Account testAccount = new Account(
            Name = 'Test',
            SLA__C = 'Gold',
            SLAExpirationDate__c = Date.newInstance(2025, 5, 31),
            SLASerialNumber__c = '123'
        );
        insert testAccount;

        List<Opportunity> newTestListOpp = new List<Opportunity>{
            new Opportunity(Name = 'Test Opp 1', StageName = 'New', CloseDate = Date.today() +37, AccountId = testAccount.Id),
            new Opportunity(Name = 'Test Opp 2', StageName = 'Negotiation', CloseDate = Date.today() +37, AccountId = testAccount.Id),
            new Opportunity(Name = 'Test Opp 3', StageName = 'Quote sent', CloseDate = Date.today() +37, AccountId = testAccount.Id)
        };
        insert newTestListOpp;
        
        //perform update
        List<Opportunity> insertedOppsToUpdate = [SELECT Id, StageName, OwnerId FROM Opportunity WHERE AccountId = :testAccount.Id];

        for(Opportunity insertedOppToUpdate : insertedOppsToUpdate){
            insertedOppToUpdate.StageName = 'Proposal/Price Quote';
        }
        update insertedOppsToUpdate;

        Test.startTest();
        SM_Opportunity.createTaskForUpdatedOpps(insertedOppsToUpdate);

        List<Id> oppIds = new List<Id>();
        for(Opportunity opp : insertedOppsToUpdate){
            oppIds.add(opp.Id);
        }
        List<Task> createdTasks = [SELECT Id FROM Task WHERE WhatId IN : oppIds LIMIT 3];
        System.assertEquals(3, createdTasks.size(), 'Tasks Created');
        Test.stopTest();  
    }
}