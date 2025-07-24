import { LightningElement, api, wire, track } from 'lwc';
import { getRecord } from "lightning/uiRecordApi";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { updateRecord } from "lightning/uiRecordApi";
import getContactsFullName from '@salesforce/apex/GetRelatedContacts.getContactsFullName';
import { CloseActionScreenEvent } from 'lightning/actions';
import getDocumentsForAccount from '@salesforce/apex/GetDocumentsForObject.getDocumentsForAccount';
import getDocumentsForContacts from '@salesforce/apex/GetDocumentsForObject.getDocumentsForContacts';

const FIELDSFROMWORKORDER = ["WorkOrder.AccountId"];
const FIELDSFROMACCOUNT = ["Account.Name"];

export default class CallingWorkOrderForReview extends LightningElement {
    isOpen = true;
    
    @api recordId; // Work Order Id
    workOrder;
    accountId;
    accountName;
    contacts;
    contactIds;
    contactsErrors;
    description;
    @track accountDocuments;
    selectedDocs;
    
    
    // get account Id from work order
    // done
    @wire(getRecord, { recordId: "$recordId", fields: FIELDSFROMWORKORDER })
    wiredWorkOrder({ error, data }) {
        if (error) {
            this.showError(error, "Error loading Work Order");
        } else if (data) {
            this.workOrder = data;
            this.accountId = data.fields.AccountId.value;
            console.log("Account ID from Work Order:", this.accountId);
        }
    }
    // Get Account Name from the Account
    // done
    @wire(getRecord, { recordId: "$accountId", fields: FIELDSFROMACCOUNT })
    wiredAccount({ error, data }) {
        if (error) {
            this.showError(error, "Error loading Account");
        } else if (data) {
            this.accountName = data.fields.Name.value;
            console.log("Account Name:", this.accountName);
        }
    }
    
    
    showError(error, title) {
        let message = "Unknown error";
        if (Array.isArray(error.body)) {
            message = error.body.map((e) => e.message).join(", ");
        } else if (typeof error.body.message === "string") {
            message = error.body.message;
        }
        this.dispatchEvent(
            new ShowToastEvent({
                title: title,
                message,
                variant: "error",
            })
        );
    }
    
    // get contacts (id, fname, lname) of this account
    // create list of contact Ids
    // done
    @wire(getContactsFullName, { accountId: "$accountId" }) 
    wired_getContacts({error, data}){
        if (data) {
            this.contacts = data;
            this.contactIds = this.contacts.map(contact => contact.Id);
            console.log('contact ids: ',JSON.stringify( this.contactIds));
            console.log('contact : ',JSON.stringify( this.contacts));
            this.contactsErrors = undefined;
            // console.log("contacts ok ");
        } else if (error) {
            this.contactsErrors = error;
            this.contacts = undefined;
            // console.log("contacts not fetching ");
            
        }
    }
    
    // get documents of this account 
    // returns list(docId, docName)
    // to change
    @wire(getDocumentsForAccount, { accountId: "$accountId" })
    wired_getDocForAcc({ error, data }) {
        if (error) {
            this.showError(error, "Error loading Account Documents");
        } else if (data) {
            this.accountDocuments = data;
            // as id and name => data.Id, data.Name
        }
    }
    // Get Contacts documents by contact id
    // result {contactId, list of (docId, docName)}
    
    contactDocsArray = []; // Array of { contactId,docId, docNames }
    // to change
    @wire(getDocumentsForContacts, { contactIds: "$contactIds" })
    wired_getDocForContacts({ error, data }) {
        if (error) {
            this.showError(error, "Error loading documents");
        } else if (data) {
            console.log("contact doc is fetched");            
            // Convert map to array for template rendering
            this.contactDocsArray = Object.keys(data).map(contactId => {
                // from db data get contactId, 
                // get contact from contacts where id = this id so i can get contact Name
                const contact = this.contacts.find(c => c.Id === contactId);
                return {
                    contactId,
                    contactName: contact 
                    ? (contact.FirstName || contact.LastName 
                        ? `${contact.FirstName || ''} ${contact.LastName || ''}`.trim() 
                        : contactId) 
                        : contactId,
                    docsRecords: data[contactId]
                    // docsRecords list of {docId,docName}
                    };
                });
                
                console.log("contacts documents is fetching : ", JSON.stringify(data));
            }
        }
        
        
        
        handleDescription(event){
            this.description = event.target.value;
        }
        
        handleCancel() {
            // Close the quick action
            this.dispatchEvent(new CloseActionScreenEvent());
        }
        
        handleCheckboxChange(event) {
            const accountId = this.accountId;
            const docName = event.target.value;
            const checked = event.target.checked;
            
            if (!this.selectedDocs) {
                this.selectedDocs = [];
            }
            
            if (checked) {
                this.selectedDocs.push({ accountId, docName });
            } else {
                // Remove from list
                this.selectedDocs = this.selectedDocs.filter(
                    doc => !(doc.accountId === accountId && doc.docName === docName)
                );
            }
            
            console.log('Selected Docs (Accounts):', this.selectedDocs);
        }
        
        handleContactCheckboxChange(event) {
            const contactId = event.target.dataset.contactId;
            const docName = event.target.dataset.docName;
            const checked = event.target.checked;
            
            if (!this.selectedDocs) {
                this.selectedDocs = [];
            }
            
            if (checked) {
                this.selectedDocs.push({ contactId, docName });
            } else {
                // Remove from list
                this.selectedDocs = this.selectedDocs.filter(
                    doc => !(doc.contactId === contactId && doc.docName === docName)
                );
            }
            
            console.log('Selected Docs (Contacts):', this.selectedDocs);
        }
        
        
        
        
        
        handleSubmit() {
            // all inputs in an array
            const allValid = [...this.template.querySelectorAll('lightning-input')]
            .reduce((validSoFar, inputField) => {
                inputField.reportValidity();
                return validSoFar && inputField.checkValidity();
            }, true);
            // check if input is invalid and report(red message if invalid)
            
            if (!allValid) {
                // eza chi invalid stop code and toast
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Validation Error',
                        message: 'Please fill in the required fields.',
                        variant: 'error'
                    })
                );
                return;
            }
            
            const fields = {
                Id : this.recordId,
                Description : this.description,
                Approval_Status__c : 'Call for Review'
            }
            // sar mtl object with those fields
            const recordInput ={fields};
            
            updateRecord(recordInput)
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Work Order updated successfully!',
                        variant: 'success'
                    })
                );
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Update Failed',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
            // const selectedArray = Array.from(this.selectedDocs);
            // const resultMap = selectedArray.map(doc => ({
            //     entityId: this.accountId,
            //     documentName: doc
            // }));
            
            console.log('Final result:', JSON.stringify(this.selectedDocs));
            
            // // create map [entityId, doc name]
            // const resultList = [];
            
            // this.selectedDocs.forEach(docName => {
                //     resultList.push({
            //         entityId: this.accountId,
            //         docName: docName
            //     });
            // });
            
            // console.log('Submitted Docs:', JSON.stringify(resultList));
            
            
            
            // to close
            this.dispatchEvent(new CloseActionScreenEvent());
        }
        
    }
    