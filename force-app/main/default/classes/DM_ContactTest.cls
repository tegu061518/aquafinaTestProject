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
private class DM_ContactTest {

    @isTest
    static void checkConvertedLeads() {

        // first thing to do was to insert a Lead Record
        Lead testLead = new Lead(
        FirstName = 'Kevin',
        LastName = 'Guyo',
        Company = 'KCG Inc',
        LeadSource = 'Web'
        );

        insert testLead;

            // we want to convert the inserted Lead Record and by doing the method below, converts the lead and creates an Account and a Contact Record
            Database.LeadConvert convertLead = new Database.LeadConvert();
            convertLead.setLeadId(testLead.Id);
            convertLead.setDoNotCreateOpportunity(true);

            LeadStatus convertStatus = [SELECT Id, ApiName FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            convertLead.setConvertedStatus(convertStatus.ApiName);
            
            Database.LeadConvertResult leadConvertResult = Database.convertLead(convertLead, false);
            System.assert(leadConvertResult.isSuccess());
            

            // perform test by calling the DM_Contact.getConByLeadsId method
            Test.startTest();
            List <Contact> results = DM_Contact.getConByLeadsId(new Set<Id>{testLead.Id});
            Test.stopTest();
    }

    @isTest
    static void checkInsertedOpp() {


    Account testAccount = new Account(
        Name = 'Test Account'
    );

    insert testAccount;

    Contact testContact = new Contact(
        FirstName = 'Keira',
        LastName = 'Bear',
        Salutation = 'Ms.',
        AccountId = testAccount.Id
    );

    insert testContact;

    Opportunity testOpp = new Opportunity(
        Name = 'Test Insert Opp',
        CloseDate = Date.newInstance(2025, 4, 30),
        StageName = 'Prospecting',
        AccountId = testAccount.Id
    );

    insert testOpp;

    OpportunityContactRole testOCR = new OpportunityContactRole(
            OpportunityId = testOpp.Id,
            ContactId = testContact.Id,
            Role = 'Business User',
            IsPrimary = true
    );

    insert testOCR;

    Test.startTest();
    List <Contact> results = DM_Contact.getContactsByOppAccountId(new Set<Id>{testAccount.Id});
    Test.stopTest();

    System.assertEquals(testContact.Id, results[0].Id, 'An Opportunity Contact Role has been created');
    }
}