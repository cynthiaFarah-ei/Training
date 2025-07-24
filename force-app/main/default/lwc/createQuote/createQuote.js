import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { NavigationMixin } from 'lightning/navigation';

import LEASE_TYPE from "@salesforce/schema/Opportunity.Lease_Type__c";

import START_DATE from '@salesforce/schema/Quote__c.Start_Date__c';
import END_DATE from '@salesforce/schema/Quote__c.End_Date__c';
import PAYMENT_TERMS from '@salesforce/schema/Quote__c.Payment_Terms__c';
import GRACE_PERIOD from '@salesforce/schema/Quote__c.Grace_Period__c';
import RETAIL_SALES_CATEGORY from '@salesforce/schema/Quote__c.Retail_Sales_Category__c';
import LEASE_DURATION from '@salesforce/schema/Quote__c.Lease_Duration__c';
import RENT_REVIEW_FREQUENCY from '@salesforce/schema/Quote__c.Rent_Review_Frequency__c';
import OPPORTUNITY_ID from '@salesforce/schema/Quote__c.Opportunity__c';

export default class CreateQuote extends LightningElement {
    @api recordId;
    @api objectApiName;
    @track quoteId; // The newly created Quote Id
    
    // Quote field schema references
    startDate = START_DATE;
    endDate = END_DATE;
    paymentTerms = PAYMENT_TERMS;
    gracePeriod = GRACE_PERIOD;
    retailSales = RETAIL_SALES_CATEGORY;
    leaseDuration = LEASE_DURATION;
    rentReview = RENT_REVIEW_FREQUENCY;
    opportunityId  = OPPORTUNITY_ID;
    
    // Lease type flags
    leaseType = '';
    retail = false;
    land = false;
    officeOrRetail = false;
    paymentTermsValue;
    leaseDurationValue;
    
    toast(title, msg, variant){
        this.dispatchEvent(new ShowToastEvent({
            title: title,
            message: msg,
            variant:variant
        }));
    }
    
    navigateToQuote(qId){
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: qId,
                objectApiName: 'Quote__c', 
                actionName: 'view'
            },
        });
    }
    // Wire to get Opportunity data
    @wire(getRecord, { recordId: '$recordId', fields: [LEASE_TYPE] })
    wiredOpportunity({ error, data }) {
        if (data) {
            const lease = getFieldValue(data, LEASE_TYPE);
            // const lease = data.fields.LEASE_TYPE.value;
            this.leaseType = lease;
            
            // Reset flags first
            this.retail = false;
            this.land = false;
            this.officeOrRetail = false;
            
            // Set appropriate flags
            switch (lease) {
                case 'Office':
                this.officeOrRetail = true;
                break;
                case 'Retail':
                this.retail = true;
                this.officeOrRetail = true; // Retail also uses office fields
                break;
                case 'Land':
                this.land = true;
                this.paymentTermsValue = 4;
                break;
            }
        } else if (error) {
            console.error('Error fetching Opportunity:', error);
        }
    }
    
    get seeUpload(){
        return this.leaseDurationValue > 30 ? true:false;
    }
    handleLeaseDurationChange(event){
        this.leaseDurationValue = event.target.value;
    }
    get acceptedFormats() {
        return ['.pdf', '.png'];
    }
    handleSuccess(event) {
        const qId = event.detail.id;
        this.quoteId = event.detail.id; // The newly created Quote Id from the form success event
        console.log('Quote created with Id:', this.quoteId);
        
        // this.toast('Quote Creation','Quote is successfully created' ,'success');
        // setTimeout(this.navigateToQuote(qId), 1000);
        this.closeAction();

    }
    handleError(event){
        console.log('error creating quote');
    }
    
    uploadedImgName = '';
    
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        if (uploadedFiles.length > 0) {
            this.uploadedImgName = uploadedFiles[0].name;
        }
    }
    
}
