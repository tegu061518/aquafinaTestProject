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
private class SM_LeadTest {

    @isTest
    static void testContactsInserted() {
        
        //new Lead Record
        Lead newLeadRec = new Lead(
            FirstName = 'Keira',
            LastName = 'Guyi',
            Company = 'KCG Inc',
            LeadSource = 'Web'
        );
        insert newLeadRec;

            Test.startTest();
            //convert the new Lead Record Inserted
            Database.LeadConvert leadConvert = new Database.LeadConvert();
            leadConvert.setLeadId(newLeadRec.Id);
            leadConvert.setDoNotCreateOpportunity(true);

            //sets converted status to the current lead status
            LeadStatus convertStatus = [SELECT Id, ApiName FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            leadConvert.setConvertedStatus(convertStatus.ApiName);

            Database.LeadConvertResult leadConvertResult = Database.convertlead(leadConvert, false);
            System.assert(leadConvertResult.isSuccess());

            

                //get the converted Contacted Record
                Id convertedContactId = leadConvertResult.getContactId();
                List<Contact> contactList = [SELECT Id, LastName, Converted_From_Lead__c FROM Contact LIMIT 1];
                System.assertEquals(1, contactList.size(), 'No contact found after conversion');
                System.assertEquals(newLeadRec.Id, contactList[0].Converted_From_Lead__c, 'The converted contact has a different contact Id than the expected.');
                Contact convertedContact = contactList[0];
                convertedContact.LastName = 'Guyo';
                update convertedContact;

                Test.stopTest();

/*                     // add the converted  = new List<Contact>();
                    Map<Id,Lead> convertedLeadsOldMap, List<Lead> convertedLeadsList = new Map<Id,Lead>();
                    List<Contact> conList = new List<Contact>{convertedContact}; */
    }
}
