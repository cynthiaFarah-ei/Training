public with sharing class Exercise2 {

    public static void updateAccountContactsCount(List<Contact> newContactsList, Map<Id,Contact> idsToContactsOldMap) {
        Set <Id> accountsIdsList = new Set<Id>();
        // for method 1 l2n mn 3uz l duplicates to count.
        // List <Id> accountsIdsList = new List<Id>();
        for(contact contact : newContactsList){
            if(contact.AccountId !=null){
                // check if insert or update (firstname or lastname)
                if(idsToContactsOldMap == null || idsToContactsOldMap.get(contact.Id).FirstName != contact.FirstName
                || idsToContactsOldMap.get(contact.Id).LastName != contact.LastName){
                    // check if condition are met  first name == null ot ''
                    if(contact.FirstName == null || contact.LastName=='Smith'){
                        accountsIdsList.add(contact.AccountId);
                    }
                }
            }
        }
        // method 1 get accounts li bdn update then loop through accounts and loop through ids each occurence + 1
        // List<Account> accountsToUpdate = [SELECT Id, Contacts_Occurences__c FROM Account WHERE Id IN :accountsIdsList];
        // for(Account account : accountsToUpdate){
        //     for(Id id : accountsIdsList){
        //         Decimal count = account.Contacts_Occurences__c;
        //         if(count == null){
        //             count = 0.0 ;
        //             System.debug('count: '+count);
        //         }
        //         if(id == account.Id){
        //             account.Contacts_Occurences__c = count + 1.0;
        //         }
        //     }
        // }
        // update accountsToUpdate;
        
        if(! accountsIdsList.isEmpty()){
            List <Account> accountsToUpdate = new List<Account>();
            for(Account acc : [SELECT Id, (SELECT Id FROM Contacts WHERE FirstName=null OR LastName = 'Smith') 
            FROM Account WHERE Id IN :accountsIdsList ]){
                Integer count = acc.Contacts.size();
                acc.Contacts_Occurences__c = count;
                accountsToUpdate.add(acc);
            }
            update accountsToUpdate;
        }
    }
}
