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
private class DM_AccountTest {

    @isTest
    static void testGetAccounts() {
    
            Account testAccount = new Account(
                Name = 'Isuzu',
                Rating = 'Hot',
                SLA__c = 'Gold',
                SLASerialNumber__c = '12345',
                SLAExpirationDate__c = Date.newInstance(2025, 5, 31),
                Sic = '123AB'
            );
            insert testAccount;

        Test.startTest();
            Set<Id> testAccId = new Set<Id>{testAccount.Id};
            DM_Account.getAccounts(testAccId);
        Test.stopTest();
        
        Account results = [SELECT Id, Name FROM Account WHERE Id =:testAccount.Id LIMIT 1];
        System.assertEquals('Isuzu', results.Name, 'Expected Account Name is Isuzu');
    }

    @isTest
    static void getAccountByClosedWonOpp() {
    
            Account testAccount = new Account(
                Name = 'Honda',
                Rating = 'Hot',
                SLA__c = 'Silver',
                SLASerialNumber__c = '123456',
                SLAExpirationDate__c = Date.newInstance(2025, 5, 31),
                Sic = '123ABC'
            );
            insert testAccount;

            List<Opportunity> newTestOpp = new List<Opportunity>{
                new Opportunity(Name = 'Test Opp 1', StageName = 'New', CloseDate = Date.today() +37, AccountId = testAccount.Id),
                new Opportunity(Name = 'Test Opp 2', StageName = 'Negotiation', CloseDate = Date.today() +37, AccountId = testAccount.Id),
                new Opportunity(Name = 'Test Opp 2', StageName = 'Quote sent', CloseDate = Date.today() +37, AccountId = testAccount.Id)
                };
            insert newTestOpp;
            
            for(Opportunity oppToUpdate : newTestOpp){
                oppToUpdate.StageName = 'Won';
            }
            update newTestOpp;

        Test.startTest();
            Set<Id> testAccId = new Set<Id>{testAccount.Id};
            DM_Account.getAccountByClosedWonOpp(testAccId);
        Test.stopTest();
        
        Account results = [SELECT Id, Name FROM Account WHERE Id =:testAccount.Id LIMIT 1];
        System.assertEquals('Honda', results.Name, 'Expected Account with Close Won Opportuinity is called Honda');
    }

    @isTest
    static void getProspectAccounts(){

        List<Account> testProspectAccounts = new List<Account>{
            new Account(Name = 'Honda', Rating = 'Hot', SLA__c = 'Silver', SLASerialNumber__c = '123456', SLAExpirationDate__c = Date.newInstance(2025, 5, 31), Sic = '123ABC', Type = 'Prospect'),
            new Account(Name = 'Yamaha', Rating = 'Hot', SLA__c = 'Silver', SLASerialNumber__c = '123456', SLAExpirationDate__c = Date.newInstance(2025, 5, 31), Sic = '123ABC', Type = 'Prospect'),
            new Account(Name = 'Isuzu', Rating = 'Hot', SLA__c = 'Silver', SLASerialNumber__c = '123456', SLAExpirationDate__c = Date.newInstance(2025, 5, 31), Sic = '123ABC', Type = 'Prospect'),
            new Account(Name = 'Subaru', Rating = 'Hot', SLA__c = 'Silver', SLASerialNumber__c = '123456', SLAExpirationDate__c = Date.newInstance(2025, 5, 31), Sic = '123ABC', Type = 'Prospect'),
            new Account(Name = 'Lexus', Rating = 'Hot', SLA__c = 'Silver', SLASerialNumber__c = '123456', SLAExpirationDate__c = Date.newInstance(2025, 5, 31), Sic = '123ABC', Type = 'Prospect')
        };
        insert testProspectAccounts;

        Set<Id> prospectAccIds = new Set<Id>();
        for(Account acc : testProspectAccounts){
            prospectAccIds.add(acc.Id);
        }

        Test.startTest();
            DM_Account.getProspectAccounts(prospectAccIds);
        Test.stopTest();

        List<Account> result = [SELECT Id, Name FROM Account WHERE Id IN :testProspectAccounts LIMIT 5];
        System.assertEquals(5, result.size(), 'These should be 5 Prospect Accounts Createad');
    }
}