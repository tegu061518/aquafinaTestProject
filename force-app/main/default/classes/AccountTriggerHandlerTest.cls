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
private class AccountTriggerHandlerTest {

    
    @isTest
    static void afterInsert() {
        Test.startTest();
            Account testAccount = new Account(
                Name = 'Amahay',
                Rating = 'Hot',
                SLA__c = 'Gold',
                SLASerialNumber__c = '12345',
                SLAExpirationDate__c = Date.newInstance(2025, 5, 31),
                Sic = '123AB'
            );
            insert testAccount;
        Test.stopTest();
            
            Account createdTestAccount = [SELECT Id, Name FROM Account WHERE Id =:testAccount.Id LIMIT 1];
            Assert.areEqual('Amahay', createdTestAccount.Name, 'Account Name is Amahay');

    }
}