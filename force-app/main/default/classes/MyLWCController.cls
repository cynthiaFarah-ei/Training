public with sharing class MyLWCController {
    // cacheable = true just for select
    @AuraEnabled(cacheable = true)
    public static List<Account> getAccounts(Integer maxRecords){
        try {
            if(maxRecords == 0){return new List<Account>();}
            return [SELECT Id, Name FROM Account LIMIT :maxRecords];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}