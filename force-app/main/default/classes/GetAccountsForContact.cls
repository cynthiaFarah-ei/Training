public with sharing class GetAccountsForContact {
    @AuraEnabled(cacheable = true)
    public static List<AccountContactRelation> getAccountsLinkedTocontact(Id contactId){
        // returns account name and id for this selected contact 
        try {
            return [SELECT Account.Name, AccountId FROM AccountContactRelation WHERE ContactId = :contactId];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<Contact> getContactsRelatedToAccounts(List<Id> accountIds){
        // returns account name and id for this selected contact 

        // get first name and last name of contacts for a list of accounts
        try {
            return [SELECT FirstName, LastName, AccountId FROM contact WHERE AccountId IN :accountIds];
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled(cacheable = true)
    public static List<AccountContactRelation> getAllContactsForRelatedAccounts( Id contactId){
        try { List<Id> accountIds = new List<Id>();
            // get account Ids related to this contact 
            for(AccountContactRelation acr : [SELECT AccountId FROM AccountContactRelation WHERE ContactId = :contactId]){
                accountIds.add(acr.AccountId);
            }

            return[SELECT Contact.FirstName, Contact.LastName, ContactId, AccountId, Account.Name
            FROM AccountContactRelation
            WHERE AccountId IN :accountIds];


        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
}