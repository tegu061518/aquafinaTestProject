//flow on tebins brain
//any contacts inserted / updated, get accountId and store it
//use the accountId to query Opportunities where AcountId IN :accountIds
//store the total count of Opportunities into a variable

public with sharing class ContactUtils {

    public static Integer getOpportunitiesFromContact(List<Contact> insertedContact) {
        
        Set<Id> accountIds = new Set<Id>();

        for(Contact con : insertedContact){
            if(con.AccountId != null){
                accountIds.add(con.accountId);
            }
        }

        //created aggregate list to store OppurtunityId count per Account
        List<AggregateResult> opportunityCount = [SELECT COUNT(Id) numberOfOpportunities, AccountId
                                      FROM Opportunity
                                      WHERE AccountId 
                                      IN :accountIds
                                      GROUP BY AccountId];
        
        //created a list to store Opportunity Count                                      
        Map<Id, Integer> opportunityCountMap = new Map<Id, Integer>();

        //for each opportunityId on the aggregatelist, check if count is greater than 0 then store the value on an integer list to use return
        for(AggregateResult ar : opportunityCount){
            Integer oppCount = (Integer) ar.get('numberOfOpportunities');
            Id accountId = (Id) ar.get('AccountId');
            opportunityCountMap.put(accountId, oppCount);
        
        }

        System.debug('Number of Opportunities: ' + opportunityCountMap);
        return opportunityCountMap.size();
    }
}
