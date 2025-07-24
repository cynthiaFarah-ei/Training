public with sharing class GetOpportunitiesByAccount {
    @AuraEnabled(cacheable = true)
    public static List<Opportunity> GetOpportunities(Id accountId){
        try {
            return [ SELECT Id, Name, StageName, Amount
            FROM Opportunity
            WHERE AccountId = :accountId
            ORDER BY Amount DESC];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}