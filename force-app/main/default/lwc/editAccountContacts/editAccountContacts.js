import { LightningElement, track, api, wire } from 'lwc';
import getContacts from '@salesforce/apex/GetRelatedContacts.getContacts';
import updateContact from '@salesforce/apex/UpdateContact.updateContact';

export default class EditAccountContacts extends LightningElement {
    @api recordId;
    contactToEdit; // id
    @track isVisible = false;
    contactFirstName;
    contactLastName;
    contactEmail;
    contactPhone;

    contacts;
    errors;

    contactUpdated;

    //  @api recordId; 
//    connectedCallback() {
//         window.clearTimeout(this.delayTimeout);
//         this.delayTimeout = setTimeout(() => {
//            alert(this.recordId)
//         }, 0);
//     }
    @wire(getContacts,{accountId:"$recordId"})
    wired_getRelatedContacts({error, data}){
        if(data){
            this.contacts = data;
            // console.log("contactssss",this.contacts);
            this.errors = undefined;
        } 
        else if(error){
            this.errors = error;
            this.contacts = undefined;
        }
    }

    editContact(event){
        this.contactToEdit = event.target.dataset.contact;
        const contact = this.contacts.find(c => c.Id === this.contactToEdit);
        this.contactFirstName = contact.FirstName;
        this.contactLastName = contact.LastName;
        this.contactEmail = contact.Email;
        this.contactPhone = contact.MobilePhone;
        // this.isVisible = !this.isVisible;
        this.isVisible = true;

    }

    handleInputChange(event) {
        const field = event.target.dataset.field;
        const value = event.target.value;

        switch(field) {
            case 'FirstName':
                this.contactFirstName = value;
                break;
            case 'LastName':
                this.contactLastName = value;
                break;
            case 'Email':
                this.contactEmail = value;
                break;
            case 'Phone':
                this.contactPhone = value;
                break;
        }
    }
    
    Update() {
    updateContact({
        contactId: this.contactToEdit,
        fname: this.contactFirstName,
        lname: this.contactLastName,
        email: this.contactEmail,
        phone: this.contactPhone
    })
    .then((result) => {
        this.contactUpdated = result;
        this.closeModal(); 
    })
    .catch(error => {
        this.errors = error;
        console.error('Update failed', error);
    });
}


    closeModal() {
        this.isVisible = false;
    }
}