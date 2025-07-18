global class NbOfCourseAttendeesBatch implements Database.Batchable<SObject>{
     // Step 1: Start method - defines the scope of records
     global Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator(
            // data to update (all)
            'SELECT Id FROM Certification__c'
        );
    }

    // Step 2: Execute method - processes each batch of records
    global void execute(Database.BatchableContext bc, List<Certification__c> scope) {
        Integer count = 0;
        Set<Id> certificationIds = new Set<Id>();
        for (Certification__c certification : scope) {
            certificationIds.add(certification.Id);
        }
        // List<Course_Attendee__c> courseAttendees = [SELECT count(Id),Course_Delivery__r.Course__r.Certification__c from Course_Attendee__c where Course_Delivery__r.Course__r.Certification__c IN:certificationIds Group BY];
         
        // for loop 3l certifications if id not in hay aggregation put 0 
        // aggregation list mn hot get Course_Delivery__r.Course__r.Certification__c
        update scope;
    }

    // Step 3: Finish method - post-processing like logging, email, etc.
    global void finish(Database.BatchableContext bc) {
        System.debug('Batch process completed.');
        // Optional: Send notification or trigger another batch
    }
}