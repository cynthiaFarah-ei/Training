import { LightningElement, wire } from 'lwc';
import getTopAccounts from '@salesforce/apex/TopAccounts.getTopAccounts';
export default class Top5Accounts extends LightningElement {

    amount ;
    accounts;
    errors;

     handleAmountChange(event){
        if(event.target.value == null){
            this.amount = 0;
        }
        this.amount = event.target.value;
    }
     @wire(getTopAccounts, {amount:"$amount"}) 
        wired_getAccounts({error, data}){
            if (data) {
                console.log('data '+JSON.stringify(data) );
                 this.accounts = data;
                this.errors = undefined;
            } else if (error) {
                this.errors = error;
                console.log('Error :'+ JSON.stringify(this.errors));
                this.accounts = undefined;
            }
        }
}