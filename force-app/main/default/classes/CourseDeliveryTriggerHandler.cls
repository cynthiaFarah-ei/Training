public class CourseDeliveryTriggerHandler {

    private static Set<Date> allHolidays = new Set<Date>();

    static {
        for (Holiday h : [SELECT ActivityDate FROM Holiday]) {
            allHolidays.add(h.ActivityDate);
        }
    }

    public static void preventInvalidCourseDeliveries(List<Course_Delivery__c> newCourseDeliveryList,
                                                      Map<ID, Course_Delivery__c> oldCourseDeliveryMap) {
        
        for (Course_Delivery__c cd : newCourseDeliveryList) {
            if (oldCourseDeliveryMap?.get(cd.Id).Start_Date__c != cd.Start_Date__c) {   
                if ( allHolidays.contains(cd.Start_Date__c) ) {
                    cd.Start_Date__c.addError(Label.Invalid_Delivery_Start_Date);
                    
                    // TODO #1
                    // Immediately Publish a platform event with details of the error
                    Error_Message__e event = new Error_Message__e();
                    event.Source_Component__c = 'Course Delivery Trigger Handler';
                    event.Error_Message__c = 'Error'+ Label.Invalid_Delivery_Start_Date;
                    EventBus.publish(event);

                }
            }
        }
    }


    // public static void preventDeletePastDeliveries(List<Course_Delivery__c> deletedCourseDeliveryList) {
        //loop through deleted rec (before)
        // for (Course_Delivery__c cd : deletedCourseDeliveryList) {
        //     //check if end date < today error
        //     //Exercice 1 using end_date field
        //     Date dToday = Date.today();
        //     if (cd.End_Date__c < dToday) {                
        //             cd.addError(Label.End_Date_Elapsed);
        //     }


            // ex 2 using start date and num of days
            // Date dToday = Date.today();
            // Decimal duration = cd.Course__r.Duration__c - 1;
            // Date end_date = cd.Start_Date__c.addDays(duration);
            // if (end_date < dToday) {                
            //         cd.addError(Label.End_Date_Elapsed);
            // }
        // }
    // }
}