public with sharing class OpportunityUtils {

    public static Integer getOpportunityCountAndRevenue(List<Opportunity> insertedOpportunity) {
    
            Integer countOfOpportunity = 0;
            Integer revenueOfOpportunity = 0;

            for(Opportunity oppCount : insertedOpportunity){
                if(oppCount.ExpectedRevenue != 0 && oppCount.ExpectedRevenue != null){
                    countOfOpportunity++;
                }
            }

            for(Opportunity oppRevenue : insertedOpportunity){
                if(oppRevenue.Amount != 0 && oppRevenue.Amount != null){
                    revenueOfOpportunity += (Integer)oppRevenue.Amount;
                }
            }

            System.debug('Total number of Opportunity with Expected Revenue: ' +countOfOpportunity);
            System.debug('Total revenue of the opportunity: ' +revenueOfOpportunity);
            return countOfOpportunity + revenueOfOpportunity;
    }
}