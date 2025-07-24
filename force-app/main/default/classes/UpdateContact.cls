public with sharing class UpdateContact {
    @AuraEnabled
    public static Contact updateContact(Id contactId, String fname, String lname, String email, String phone) {
        try {
            if (contactId != null && String.isNotBlank(fname) && String.isNotBlank(lname)) {
                String fullName = fname + lname;
                if (fullName.length() <= 10) {
                    Contact c = new Contact(
                        Id = contactId,
                        FirstName = fname,
                        LastName = lname,
                        Email = email,
                        MobilePhone = phone
                    );
                    update c;
                    return c;
                } else {
                    throw new AuraHandledException('Full name must be 10 characters or less.');
                }
            } else {
                throw new AuraHandledException('Missing required fields.');
            }
        } catch (Exception e) {
            throw new AuraHandledException('Error updating contact: ' + e.getMessage());
        }
    }
}
