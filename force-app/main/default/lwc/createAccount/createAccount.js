import { LightningElement } from 'lwc';
import createAccount from '@salesforce/apex/CreateAccountImperative.createAccount';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

export default class CreateAccount extends NavigationMixin(LightningElement) {
    accountName='';
    account;
    errors;
    spinnerVisible = false;
    
    handleInputChange(event){
        this.accountName = event.target.value;
    }
    toast(title, msg, variant){
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: msg,
            variant:variant
        }));
    }
    
    navigateToAcc(accId){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: accId,
                objectApiName: 'Account', // Always add objectApiName when using standard__recordPage
                actionName: 'edit',
            },
        });
    }
    
    addAccount(){
        this.spinnerVisible = true;
        
        if(this.accountName === ' '){
            // just to try get error from throw
            this.toast('Account Creation Failed', 'Please fill the account name.', 'error');
            this.spinnerVisible = false;
            return;
        }
        
        createAccount({accName: this.accountName})
        .then((result) => {
            this.account = result;
            
            this.toast( 'Account Creation','Account is successfully created.', 'success' );
            
            this.spinnerVisible = false;
            
            // Use arrow function to preserve `this` context
            setTimeout(this.navigateToAcc(this.account.Id), 500); // 1 seconds delay
        })
        .catch(error => {
            this.errors = error;
            // Extract readable error message
            let errorMessage = 'There was an error';
            
            errorMessage = this.errors.body.message;
            this.toast('Account Creation',errorMessage ,'error');
            this.spinnerVisible = false;
        });
    }    
}