public with sharing class GetRelatedContacts {
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContacts(Id accountId){
        
        List <Contact> a =  [SELECT Id, FirstName, LastName, Email, MobilePhone 
        FROM Contact 
        WHERE AccountId = :accountId];
        System.debug(a);
        return a;
        // try {
        
        // } catch (Exception e) {
        //     throw new AuraHandledException(e.getMessage());
        // }
    }
    @AuraEnabled(cacheable = true)
    public static List<Contact> getContactsFullName(Id accountId){
        
        List <Contact> a =  [SELECT Id, FirstName, LastName
        FROM Contact 
        WHERE AccountId = :accountId];
        System.debug(a);
        return a;
    }
}