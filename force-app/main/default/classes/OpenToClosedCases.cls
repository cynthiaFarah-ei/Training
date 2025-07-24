public with sharing class OpenToClosedCases {
    @AuraEnabled
    public static List<Case> getUnclosedCases(){
        return [SELECT Id, Subject, Status, CaseNumber FROM Case WHERE Status <> 'Closed'];
    }

     @AuraEnabled
    public static void closeCase(Id caseId) {
        Case c = [SELECT Id, Status FROM Case WHERE Id = :caseId LIMIT 1];
        c.Status = 'Closed';
        update c;
    }
}