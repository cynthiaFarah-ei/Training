public with sharing class CreateAccountImperative {
    @AuraEnabled
    public static Account createAccount(String accName){
        try {
            // if(accName != ''){
                Account acc = new Account(Name = accName);
                insert acc;
                return acc;
            // }
        } catch (Exception e) {
            // throw new AuraHandledException(e.getMessage());
            throw new AuraHandledException('Failed To create error, missing Account name');
            // hay error msg li bynba3at bi elb error tb3 wire aw call this method
        }
    }
}