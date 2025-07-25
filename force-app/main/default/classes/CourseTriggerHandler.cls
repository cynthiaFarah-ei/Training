public with sharing class CourseTriggerHandler {

    static final String RETIRED = 'Retired';
    static final String ENROLLED = 'Enrolled';
    static final String SCHEDULED = 'Scheduled';
    static final String CANCELLED = 'Cancelled';
    static final String COURSE_ERROR_MESSAGE = 'Course has enrolled students'; // Optionally replace text with a custom label
    static final String DELIVERY_ERROR_MESSAGE = 'Unable to update scheduled delivery status'; // Optionally replace text with a custom label


    public static void checkStatus(List<Course__c> triggerNew, Map<Id, Course__c> oldMap, Map<Id, Course__c> newMap)  {

        /**
        *  If a Course Status is changed to retired, then we need to check to see if there are any Course Delivery records marked
        *  as Scheduled. If there is at least one attendee marked as Enrolled, then the change to retired should not happen
        *  and an error message passed back
        */

        // Initialize a Set of Id's named courseIds
        Set<Id> courseIds = new Set<Id>();

        // Loop through all Course Delivery records to look for attendees
        for (Course__c course : triggerNew) {
            if (oldMap.get(course.Id).Status__c != RETIRED && course.Status__c == RETIRED) {

                // Add the course Id to the set named courseIds
                courseIds.add(course.Id);
            }
        }

        // Check to see that we have records to process
        if (courseIds.size() > 0) {

            // TODO #1: Modify the following SOQL FOR Loop to use a list iterator variables called cds
            for (List <Course_Delivery__c> cds : [SELECT Id, Course__c, Status__c, (SELECT Status__c FROM Course_Attendees__r WHERE Status__c = :ENROLLED)
                                          FROM Course_Delivery__c
                                          WHERE Course__c IN :courseIds AND Status__c = :SCHEDULED]) {

                // TODO #2: Declare and initialize a variable named courseDeliveriesToUpdate whose type is a List of Course_Delivery__c sObjects.
                List<Course_Delivery__c>courseDeliveriesToUpdate = new List<Course_Delivery__c>();

                // TODO #3: Add an inner for loop that iterates through the cds collection one Course Delivery (cd) 
                //          at a time placing the following if/else block inside the body of the loop
                for(Course_Delivery__c cd : cds){
                    if (cd.Course_Attendees__r != null && cd.Course_Attendees__r.size() > 0) {
                        newMap.get(cd.Course__c).addError(COURSE_ERROR_MESSAGE);
                    } else {
                        // Change the status of the Course Delivery record to 'Cancelled'
                        cd.Status__c = CANCELLED;

                        // TODO #4: Replace the update statement by adding the modified Course Delivery record to the courseDeliveriesToUpdate list
                        courseDeliveriesToUpdate.add(cd);
                    }
                }

                // TODO #5: Outside the inner loop (but still inside the outer loop) - if the courseDeliveriesToUpdate list is not 
                //          empty perform a partial commit update DML operation on the list. 
                //
                //          Loop through the resulting list of Database.SaveResult records using an index counter. 
                //
                //          For any failures use the index to identify the offending Course Delivery record. Remember that the order of
                //          the Database.SaveResult list will be the same as the courseDeliveriesToUpdate list.
                //
                //          Use newMap to identify the parent Course record and call the addError() method to add the 
                //          DELIVERY_ERROR_MESSAGE error to the Course record.
                //
                //          Add the DELIVERY_ERROR_MESSAGE static final string variable at the top of the class with an appropriate error message.  

                if(courseDeliveriesToUpdate.size()>0){
                    List<Database.SaveResult> lsr = Database.update(courseDeliveriesToUpdate, false);
                    for(Integer i=0; i< lsr.size();i++){
                        if (lsr[i].isSuccess() == false) {
                            newMap.get(courseDeliveriesToUpdate[i].Course__c).addError(DELIVERY_ERROR_MESSAGE);
                        } 
                    }
                }
            }
        }        
    }
}