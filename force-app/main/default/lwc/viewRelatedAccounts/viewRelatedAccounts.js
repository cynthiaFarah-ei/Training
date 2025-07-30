import { LightningElement, api, wire, track } from 'lwc';
import getAccountsLinkedTocontact from '@salesforce/apex/GetAccountsForContact.getAccountsLinkedTocontact';
import getContactsRelatedToAccounts from '@salesforce/apex/GetAccountsForContact.getContactsRelatedToAccounts';
import getAllContactsForRelatedAccounts from '@salesforce/apex/GetAccountsForContact.getAllContactsForRelatedAccounts';

export default class ViewRelatedAccounts extends LightningElement {
    @api recordId;
    // @track accountOptions = [];
    // @track selectedContactIds = [];
    
    // connectedCallback() {
    //     getAllContactsForRelatedAccounts({contactId: "$recordId"})
    //     .then(result => {
    //         const accountsSet = new Set();
    //         const selectedIds = [];
    //          console.log('ACR Result:', JSON.stringify(result));
    //         result.forEach(acr => {
    //             if (acr.Account && acr.Account.Name) {
    //                 accountsSet.add(JSON.stringify({
    //                     label: acr.Account.Name,
    //                     value: acr.AccountId
    //                 }));
    //             }
                
    //             // Add contact to selected list if ID exists
    //             if (acr.ContactId) {
    //                 selectedIds.push(acr.ContactId);
    //             }
    //         });
            
    //         this.accountOptions = Array.from(accountsSet).map(item => JSON.parse(item));
    //         this.selectedContactIds = selectedIds;
    //     })
    //     .catch(error => {
    //         console.error('Error fetching data:', error);
    //     });
    // }
    accountOptions = [];
    contactOptions = [];
    selectedContacts = [];
    selectedAccountId;
    
    allAccounts = [];
    allContacts = []; // store all contacts once
    reqOptions;
    @wire(getAccountsLinkedTocontact, { contactId: "$recordId" })
    wired_getAccounts({ error, data }) {
        if (data) {
            this.allAccounts = data;
            this.accountOptions = data.map(acr => ({
                    label: acr.Account.Name,
                value: acr.AccountId
            }));
    
            const accountIds = data.map(acr => acr.AccountId);
    
            // Get ALL related contacts once
            if (accountIds.length > 0) {
                getContactsRelatedToAccounts({ accountIds })
                .then(result => {
                        this.allContacts = result;
                    // Optionally pre-select first account
    
                    this.selectedAccountId = accountIds[0];
                    this.filterContacts(this.selectedAccountId);
    
                })
                .catch(error => {
                        console.error('Error fetching contacts:', error);
                });
            }
        } else if (error) {
            console.error(error);
        }
    }
    
    handleAccountChange(event) {
        // take id of acc 
        this.selectedAccountId = event.detail.value;
        // filter contacts based by acc id
        this.filterContacts(this.selectedAccountId);
    }
    
    filterContacts(accountId) {
        // from all contacts filter where accounid = selected 
        // ten map it to become label - value
        const filtered = this.allContacts
        .filter(c => c.AccountId === accountId)
        .map(c => {
                const firstName = c.FirstName || '';
            const lastName = c.LastName || '';
            return {
                label: `${firstName} ${lastName}`.trim(),
                value: c.Id
            };
        });
        this.contactOptions = filtered;
        this.selectedContacts = []; // or pre-fill if needed
    }
    
    handleContactsChange(event){
        const selectedOptionsList = event.detail.value;
        console.log(`Contacts selected: ${selectedOptionsList}`);
    }
}
