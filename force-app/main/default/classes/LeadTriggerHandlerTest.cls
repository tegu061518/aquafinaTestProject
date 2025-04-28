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
private class LeadTriggerHandlerTest {

    // @isTest
    @testsetup static void myUnitTest() {

        Lead insertLeadA = new Lead(
            FirstName = 'Maria Teressa',
            LastName = 'Guyo',
            Company = 'Stockholm University',
            LeadSource = 'Web',
            Rating = 'Hot'
        );

        Lead insertLeadB = new Lead(
            FirstName = 'Kirby',
            LastName = 'Guyo',
            Company = 'IKEA',
            LeadSource = 'Web'
        );

        insert insertLeadA;
        insert insertLeadB;
    }

        // @isTest static void testMethod1_From_LeadTriggerHandler(){

        //    Lead insertLeadA = [SELECT Id, Company FROM Lead WHERE Company  = 'Stockholm University' LIMIT 1];
    
        //     Database.LeadConvert lc1 = new Database.LeadConvert();
        //    lc1.setLeadId(insertLeadA.Id);
        //    lc1.setDoNotCreateOpportunity(true);
        //   lc1.setConvertedStatus('Qualified');
        //
            //LeadStatus convertStatus1 = [SELECT Id, ApiName FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            //lc1.setConvertedStatus(convertStatus1.ApiName);

        //    Database.LeadConvertResult lcr1 = Database.convertLead(lc1);
        //    System.assert(lcr1.isSuccess());
            
        //}

    
        @isTest static void testMethod2_From_LeadTriggerHandler(){

            Lead insertLeadB = [SELECT Id, Company FROM Lead WHERE Company  = 'IKEA' LIMIT 1];

            Database.LeadConvert lc2 = new Database.LeadConvert();
            lc2.setLeadId(insertLeadB.Id);
            lc2.setDoNotCreateOpportunity(true);

            LeadStatus convertStatus2 = [SELECT Id, ApiName FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            lc2.setConvertedStatus(convertStatus2.ApiName);

            Database.LeadConvertResult lcr2 = Database.convertLead(lc2);
            System.assert(lcr2.isSuccess());

        }
        
}
