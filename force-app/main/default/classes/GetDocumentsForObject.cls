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
    public static Map<Id, List<ContentDocumentLink>> getDocumentsForContacts(List<Id> contactIds) {
        Map<Id, List<ContentDocumentLink>> contactIdToDocRecords = new Map<Id, List<ContentDocumentLink>>();
        // System.debug('in contact related doc');
        // loop through contacts and select list of documents from contentDocumentLinksss
        for (Contact contact : [
        SELECT Id,
        (SELECT ContentDocumentId, ContentDocument.Title FROM ContentDocumentLinks)
        FROM Contact
        WHERE Id IN :contactIds]) {
        System.debug('in contact loop '+contact.Id);

            // for each contacts create list of CDL (id, name) and loop through the documents
            List<ContentDocumentLink> docRecords = new List<ContentDocumentLink>();
            for (ContentDocumentLink link : contact.ContentDocumentLinks) {
                // add red kelo
                docRecords.add(link);
                System.debug('contact id'+ contact.Id+' doc name : '+link.ContentDocument.Title+ ' doc id: '+ link.ContentDocument.Id);
            }
            // add this list to the map with corresponding contact id
            contactIdToDocRecords.put(contact.Id, docRecords);
        }
        
        return contactIdToDocRecords;
    }
    
    
}