import { LightningElement, wire, track, api} from 'lwc';
import getAccounts from '@salesforce/apex/MyLWCController.getAccounts';

export default class DisplayAccountsWithLimit extends LightningElement {
    maxRecords = 10;
    maxRec = 4;
    // @wire(getAccounts,{maxRecords:"$maxRecords"}) accounts;
    // in html accounts.data
    
    handleMaxRecChange(event){
        if(event.target.value == null){
            this.maxRec=0;
        }
        this.maxRec = event.target.value;
    }
    accounts;
    errors;
    @wire(getAccounts, { maxRecords: "$maxRec" })
    wired_getAccounts({ error, data }) {
        if (data) {
            this.accounts = data;
            this.errors = undefined;
        } else if (error) {
            this.errors = error;
            this.accounts = undefined;
        }
    }
    
}