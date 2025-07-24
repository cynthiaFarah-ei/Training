public with sharing class GetDocumentsForObject {
    @AuraEnabled(cacheable = true)
    public static List<ContentDocumentLink> getDocumentsForAccount(Id accountId){
        try {
            // return List of ( Id, ContentDocumentId, Contentdocument.Title)
            return [SELECT ContentDocumentId,  ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId  = :accountId];

            // better to return doc id for key
            // List<ContentDocumentLink> docsRecords = new List<ContentDocumentLink>();
            // // for 1 account so i want only document title
            // for(ContentDocumentLink cdl : [SELECT ContentDocumentId,  ContentDocument.Title FROM ContentDocumentLink WHERE LinkedEntityId  = :accountId]){
            //     docNames.add(cdl.ContentDocument.Title);
            // }
            // return docNames;
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    @AuraEnabled(cacheable=true)
    public static Map<Id, List<String>> getDocumentsForContacts(List<Id> contactIds) {
        Map<Id, List<String>> contactIdToDocNames = new Map<Id, List<String>>();
        System.debug('in contact related doc');
        // loop through contacts and select list of documents from contentDocumentLinksss
        for (Contact contact : [
        SELECT Id,
        (SELECT ContentDocument.Title FROM ContentDocumentLinks)
        FROM Contact
        WHERE Id IN :contactIds]) {
        System.debug('in contact loop '+contact.Id);

            // for each contacts create list of doc names and loop through the documents
            List<String> docNames = new List<String>();
            for (ContentDocumentLink link : contact.ContentDocumentLinks) {
                // add doc name to a list
                docNames.add(link.ContentDocument.Title);
                System.debug('contact id'+ contact.Id+' doc name : '+link.ContentDocument.Title);
            }
            // add this list to the map with corresponding contact id
            contactIdToDocNames.put(contact.Id, docNames);
        }
        
        return contactIdToDocNames;
    }
    
    
}