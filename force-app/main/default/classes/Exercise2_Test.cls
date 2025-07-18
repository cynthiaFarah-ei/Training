@IsTest
public class Exercise2_Test {
   
    @IsTest
    static void countAccountContacts(){
        
        Account acc = new Account(Name = 'ABB lab');
        insert acc;
        List <Contact> contactsToAdd = new List<Contact>();
        Contact contact1 = new Contact(FirstName='Cynthia', LastName='Smith', AccountId=acc.Id);//counted
        Contact contact2 = new Contact(FirstName='', LastName='Smith', AccountId=acc.Id);//counted
        Contact contact3 = new Contact(FirstName='Anthony', LastName='Farah', AccountId=acc.Id);// not counted
        Contact contact4 = new Contact(FirstName='', LastName='James', AccountId=acc.Id);// counted
        contactsToAdd.add(contact1);
        contactsToAdd.add(contact2);
        contactsToAdd.add(contact3);
        contactsToAdd.add(contact4);
        insert contactsToAdd;
        Account accInserted1 = [SELECT Contacts_Occurences__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(3,accInserted1.Contacts_Occurences__c );

        contact3.LastName = 'Smith';
        Update contact3;
        Account accInserted2 = [SELECT Contacts_Occurences__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(4,accInserted2.Contacts_Occurences__c );

        contact3.LastName = 'Farah';
        Update contact3;
        Account accInserted3 = [SELECT Contacts_Occurences__c FROM Account WHERE Id = :acc.Id];
        System.assertEquals(3,accInserted3.Contacts_Occurences__c );

        // Test.startTest();
        // System.runAs(contextuser){
            
        // }
        // Test.stopTest();
        
    }
}