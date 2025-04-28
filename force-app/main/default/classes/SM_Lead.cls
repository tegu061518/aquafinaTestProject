public with sharing class SM_Lead {

    // Double check for DML that calls 'Database.LeadConvertResult leadConvertResults = Database.convertLead(leadConvert)' 
    // make sure to bulkify if there is
    // target Sunday
    public static void convertLeads(List<Lead> leadsToConvertList) {
    List<Database.LeadConvert> leadConvertList = new List<Database.LeadConvert>();   

        for(Lead lead : leadsToConvertList) {
            if(lead.LeadSource == 'Web' && lead.Rating == 'Hot'){
                Database.LeadConvert leadConvert = new Database.LeadConvert();
                leadConvert.setLeadId(lead.Id);
                leadConvert.setDoNotCreateOpportunity(true);
                leadConvert.setConvertedStatus('Qualified');
                leadConvertList.add(leadConvert);
            }

            if(!leadConvertList.isEmpty()){
                List<Database.LeadConvertResult> leadConvertResultList = Database.convertLead(leadConvertList);
                System.debug('Lead converted: ' + leadConvertResultList);
            }
        }
    }
    
        
    public static void checkConvertedLeads(Map<Id,Lead> convertedLeadsOldMap, List<Lead> convertedLeadsList){
        Set<Id> convertedLeadsId = new Set<Id>();
        Map<Id, Id> contactIdToLead = new Map<Id, Id>();
        List<Contact> contactsToUpdate = new List<Contact>();
        
        for(Lead lead : convertedLeadsList){
            if(lead.IsConverted && lead.ConvertedContactId != null && convertedLeadsOldMap.get(lead.Id).ConvertedContactId == null){
                convertedLeadsId.add(lead.ConvertedContactId);
                contactIdToLead.put(lead.ConvertedContactId, lead.Id);
                System.debug('Converted Contacts: ' + lead.ConvertedContactId);
            }
        }

        System.debug('ContactIdToLead' +contactIdToLead);

        //get Contact ID from DM_Contact
        List<Contact> contactList = new List<Contact>(DM_Contact.getConByLeadsId(convertedLeadsId));

        
        for(Contact con : contactList){
            con.Converted_From_Lead__c = contactIdToLead.get(con.Id);
            contactsToUpdate.add(con);
        }

        //can remove, apex knows already if list is empty before performing the action
        if(!contactsToUpdate.isEmpty()){
            update contactsToUpdate;
        }
    }
}

 
                        