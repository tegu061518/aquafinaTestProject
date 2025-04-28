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
private class OpportunityTriggerHandlerTest {

    @isTest
    static void afterInsert_CreateContactRole() {
    Test.startTest();
        Account testAccount = new Account(
            Name = 'Ina Baho'
        );
        insert testAccount;

        Contact testContact = new Contact(
            FirstName = 'Ina',
            LastName = 'Baho',
            Salutation = 'Mrs.',
            AccountId = testAccount.Id
        );
        insert testContact;

        Opportunity testOpportunity = new Opportunity(
            Name = 'Test Opp Insert',
            StageName = 'Prospecting',
            CloseDate = Date.newInstance(2025, 4, 30), 
            AccountId = testAccount.Id
        );
        insert testOpportunity;


        OpportunityContactRole testOCR = new OpportunityContactRole(
            OpportunityId = testOpportunity.Id,
            ContactId = testContact.Id,
            IsPrimary = true
        );
        insert testOCR;
    Test.stopTest();
    
    OpportunityContactRole result = [SELECT Id FROM OpportunityContactRole WHERE Id =: testOpportunity.Id];
    System.assertEquals('Created Contact Role', result.Id, 'An Opportunity Contact Role has been created');
    }

    @isTest
    static void afterUpdate_UpdateClientFieldOnAccount() {

        Test.startTest();
            Account testAccount = new Account(
                Name = 'Test',
                SLA__C = 'Gold',
                SLAExpirationDate__c = Date.newInstance(2025, 5, 31),
                SLASerialNumber__c = '123'
            );
            insert testAccount;

            List<Opportunity> testOppList = new List<Opportunity>{
                new Opportunity(Name = 'Test Opp 1', StageName = 'New', CloseDate = Date.today() +37, AccountId = testAccount.Id),
                new Opportunity(Name = 'Test Opp 2', StageName = 'Negotiation', CloseDate = Date.today() +37, AccountId = testAccount.Id),
                new Opportunity(Name = 'Test Opp 3', StageName = 'Quote sent', CloseDate = Date.today() +37, AccountId = testAccount.Id)
            };
            insert testOppList;
        
            //perform update
            List<Opportunity> insertedOppsToUpdate = [SELECT Id, StageName FROM Opportunity WHERE AccountId = :testAccount.Id];

            for(Opportunity insertedOppToUpdate : insertedOppsToUpdate){
                insertedOppToUpdate.StageName = 'Won';
            }
            update insertedOppsToUpdate;
        Test.stopTest(); 

        Account result = [SELECT Id, Client__c FROM Account WHERE Id =: testAccount.Id];
        System.assertEquals(true, result.Client__c, 'The account client has been set');
    }

    @isTest
    static void afterUpdate_CreateTaskForUpdatedOpps() {
    
        Test.startTest();
            Account testAccount = new Account(
                Name = 'Test',
                SLA__C = 'Gold',
                SLAExpirationDate__c = Date.newInstance(2025, 5, 31),
                SLASerialNumber__c = '123'
            );
            insert testAccount;

            List<Opportunity> testOppList = new List<Opportunity>{
                new Opportunity(Name = 'Test Opp 1', StageName = 'New', CloseDate = Date.today() +37, AccountId = testAccount.Id),
                new Opportunity(Name = 'Test Opp 2', StageName = 'Negotiation', CloseDate = Date.today() +37, AccountId = testAccount.Id),
                new Opportunity(Name = 'Test Opp 3', StageName = 'Quote sent', CloseDate = Date.today() +37, AccountId = testAccount.Id)
            };
            insert testOppList;

            //perform update
            List<Opportunity> insertedOppsToUpdate = [SELECT Id, StageName FROM Opportunity WHERE AccountId = :testAccount.Id];

            for(Opportunity insertedOppToUpdate : insertedOppsToUpdate){
                insertedOppToUpdate.StageName = 'Proposal/Price Quote';
            }
            update insertedOppsToUpdate;

            List<Id> updatedOppIds = new List<Id>();
            for(Opportunity testOpps : insertedOppsToUpdate){
                updatedOppIds.add(testOpps.Id);
            }

        Test.stopTest(); 

        List<Task> taskResult = [SELECT Id, Subject FROM Task WHERE WhatId IN :updatedOppIds LIMIT 3];
        System.assertEquals(3, taskResult.size(), 'Each Opportunity has a task associated');   
    }
}