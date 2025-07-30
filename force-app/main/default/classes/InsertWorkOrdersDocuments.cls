public with sharing class InsertWorkOrdersDocuments {
    @AuraEnabled
    public static void insertWorkOrderDocuments(List<Object> documentData) {
        List<Work_Order_Review_Documents__c> recordsToInsert = new List<Work_Order_Review_Documents__c>();
        
        for (Object itemObj : documentData) {
            Map<String, Object> item = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(itemObj));
            
            String workOrderId = (String)item.get('workOrderId');
            String entityId = (String)item.get('entityId');
            String documentId = (String)item.get('documentId');
            String description = (String)item.get('description');
            
            if (String.isBlank(workOrderId) || String.isBlank(entityId)) {
                continue; // or throw error
            }
            
            recordsToInsert.add(new Work_Order_Review_Documents__c(
            Work_Order__c = workOrderId,
            EntityId__c = entityId,
            DocumentId__c = documentId,
            Description__c = description
            ));
        }
        
        insert recordsToInsert;
        System.debug(recordsToInsert);
    }
    
}