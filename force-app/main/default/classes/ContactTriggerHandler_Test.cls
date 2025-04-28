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
private class ContactTriggerHandler_Test {

    @isTest
    static void afterInsert_checkContactsInserted() {

        Test.startTest();
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

            List<Contact> testContacts = new List<Contact>{
                new Contact(FirstName = 'Kere', LastName = 'Bantot1', Salutation = 'Ms.', AccountId = testAccount.Id),
                new Contact(FirstName = 'Kere', LastName = 'Bantot2', Salutation = 'Ms.', AccountId = testAccount.Id),
                new Contact(FirstName = 'Kere', LastName = 'Bantot3', Salutation = 'Ms.', AccountId = testAccount.Id)
            };
            insert testContacts;
        Test.stopTest();

        List<Opportunity> result = [SELECT Id FROM Opportunity WHERE AccountId =: testAccount.Id LIMIT 1];
        System.assertEquals(1, result.size(), 'A prospecting Opportunity has been created');
    }
}