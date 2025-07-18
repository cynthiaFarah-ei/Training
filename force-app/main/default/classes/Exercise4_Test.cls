@isTest
public with sharing class Exercise4_Test {
    
    @TestSetup
    static void makeData(){

        // Test Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Test Opportunity linked to Account
        Opportunity opp1 = new Opportunity(Name = 'Test Opportunity 1', Opportunity_Identifier__c='ACB' , AccountId = acc.Id, CloseDate = Date.today(),StageName = 'Prospecting');
        insert opp1;

    }

    @isTest
    static void checkUpdatingIdentifier(){

        // Querying the created records in the test setup
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp1 = [SELECT Id FROM Opportunity LIMIT 1];

        Opportunity opp2 = new Opportunity(Name = 'Test Opportunity 1', Opportunity_Identifier__c='DEX' , AccountId = acc.Id, CloseDate = Date.today(),StageName = 'Prospecting');
        insert opp2;

        Offer__c offr1 = new Offer__c(Name = 'offer1', Opportunity__c = opp1.Id);
        Offer__c offr2 = new Offer__c(Name = 'offer2', Opportunity__c = opp1.Id);
        Offer__c offr3 = new Offer__c(Name = 'offer4', Opportunity__c = opp2.Id);

        insert new List <Offer__c>{offr1, offr2, offr3};

        System.assertEquals(3,new List<Offer__c>([SELECT id FROM Offer__c WHERE Offer_Identifier__c != null]).size());
        System.assertEquals(1,new List<Offer__c>([SELECT id FROM Offer__c WHERE Id = :offr1.Id AND Offer_Identifier__c LIKE 'ACB-000']).size());
        System.assertEquals(1,new List<Offer__c>([SELECT id FROM Offer__c WHERE Id = :offr2.Id AND Offer_Identifier__c LIKE 'ACB-001']).size());
        System.assertEquals(1,new List<Offer__c>([SELECT id FROM Offer__c WHERE Id = :offr3.Id AND Offer_Identifier__c LIKE 'DEX-000']).size());
         
        offr3 = [SELECT id FROM Offer__c WHERE Id = :offr3.Id];
        offr3.opportunity__c = opp1.Id;  // bcm acb hene 2 sarit acb - 2
        update offr3;

        System.assertEquals(1,new List<Offer__c>([SELECT Id FROM Offer__c WHERE Id = :offr3.Id AND Offer_Identifier__c LIKE 'ACB-002']).size());
      
    }
}