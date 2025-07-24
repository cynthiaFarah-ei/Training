public with sharing class TopAccounts {
    
  @AuraEnabled(cacheable = true)
  public static List<Account> getTopAccounts(Integer amount){
    // try {
        List<Account> accs = new List<Account>();
        accs =  [SELECT Id, Name, TotalOppsAmount__c FROM Account WHERE TotalOppsAmount__c!=null AND TotalOppsAmount__c < :amount  ORDER BY TotalOppsAmount__c DESC LIMIT 5];
        System.debug(accs);
        return accs;

    // } catch (Exception e) {
    //     throw new AuraHandledException(e.getMessage());
    // }
  }
}