@isTest
public with sharing class Exercise3_Test {
    
    @TestSetup
    static void makeData(){

        // Test Account
        Account acc = new Account(Name = 'Test Account');
        insert acc;

        // Test Opportunity linked to Account
        Opportunity opp1 = new Opportunity(Name = 'Test Opportunity 1', AccountId = acc.Id, CloseDate = Date.today(),StageName = 'Prospecting');
        insert opp1;

        // Test Quote linked to opportunity
        Quote__c quote1 = new Quote__c(Name = 'Test Quote',Opportunity__c = opp1.Id);
        insert quote1;
    }

    @isTest
    static void checkCompetitorLinks_TestOpportunity(){

        // Querying the created records in the test setup
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp1 = [SELECT Id FROM Opportunity LIMIT 1];

        // Creating a competitor linked to the account and opportunity named Competitor 1
        Competitor__c comp1 = new Competitor__c(Account__c = acc.Id, Opportunity__c = opp1.Id, Name = 'Competitor 1');
        insert comp1;

        // Creating another opportunity linked to the Account
        Opportunity opp2 = new Opportunity(Name = 'Test Opportunity 2', AccountId = acc.Id, CloseDate = Date.today(),StageName = 'Prospecting');
        insert opp2;

        // Defining another competitor
        Competitor__c comp2 = new Competitor__c(Account__c = acc.Id, Opportunity__c = opp2.Id, Name = 'Competitor 2');
    
        // Trying to insert the competitor
        try{
            insert comp2; // hay bada t3ml error so catch it 
            // hay l assert fails the test l2n ma lzm asln t2t3 3leya lzm 3l insert t3ml error w tru7 3l catch 
            //  eza ejit 3a hay mn3ml fail la test
            System.assert(true, 'The competitor should not be able to be created'); // The code should set an error on the above line and if it succeedes then this assertion will fire
        } catch(Exception ex){
            // Checking if this is the message that is displayed (Not a message from another validation rule or such)
            // hay error li hateneha bs elna eno account already linked to an opportunity 
            System.assert(ex.getMessage().contains(Label.OpportunityError));
            System.assert(ex.getMessage().contains('this account already linked to an opportunity'));
        }
    }

    @isTest
    static void checkCompetitorLinks_TestQuote(){

        // Querying the created records in the test setup
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Quote__c quote1 = [SELECT Id FROM Quote__c LIMIT 1];

        // Creating a competitor linked to the account and opportunity named Competitor 1
        Competitor__c comp1 = new Competitor__c(Account__c = acc.Id, Quote__c = quote1.Id, Name = 'Competitor 1');
        insert comp1;

        // Creating another opportunity linked to the Account
        Quote__c quote2 = new Quote__c(Name = 'Test Quote 2',Opportunity__c = opp1.Id);
        insert quote2;

        // Defining another competitor
        Competitor__c comp2 = new Competitor__c(Account__c = acc.Id, Quote__c = quote2.Id, Name = 'Competitor 2');

        // Trying to insert the competitor
        try{
            insert comp2;
            System.assert(true, 'The competitor should not be able to be created'); // The code should set an error on the above line and if it succeedes then this assertion will fire
        } catch(Exception ex){
            // Checking if this is the message that is displayed (Not a message from another validation rule or such)

            // System.assert(ex.getMessage().contains(Label.QuoteError)); // label l add error
            System.assert(ex.getMessage().contains('this acc already linked to a quote')); // label l add error
        }
    }

    @isTest
    static void assignCompetitorToAccount_Test(){

        // Querying the created records in the test setup
        Account acc = [SELECT Id FROM Account LIMIT 1];
        Opportunity opp1 = [SELECT Id FROM Opportunity LIMIT 1];
        Quote__c quote1 = [SELECT Id FROM Quote__c LIMIT 1];

        // Creating a competitor
        Competitor__c comp = new Competitor__c(Name = 'Test Competitor', Quote__c = quote1.Id, Account__c = acc.Id);

        // The Test.startTest and Test.stopTest methods will reset the DML limits
        Test.startTest();
        insert comp;
        Test.stopTest();

        // Asserting that the size of the list is not 0 (ie: A record has been created)
        System.assertNotEquals(0, new List<Competitor__c>([SELECT Id FROM Competitor__c WHERE Opportunity__c = :opp1.Id]).size());
    }

}