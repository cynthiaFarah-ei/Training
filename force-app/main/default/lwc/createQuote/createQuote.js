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

export default class CreateQuote extends NavigationMixin(LightningElement) {
    @api recordId;
    @track quoteId;
    
    // Schema field references
    startDate = 'Start_Date__c';
    endDate = END_DATE;
    paymentTerms = PAYMENT_TERMS;
    gracePeriod = GRACE_PERIOD;
    retailSales = RETAIL_SALES_CATEGORY;
    leaseDuration = LEASE_DURATION;
    rentReview = RENT_REVIEW_FREQUENCY;
    opportunityId = OPPORTUNITY_ID;
    
    // Lease logic flags
    leaseType = '';
    retail = false;
    land = false;
    officeOrRetail = false;
    paymentTermsValue;
    leaseDurationValue;
    
    uploadedImgName = '';
    
    // Retrieve Lease Type
    @wire(getRecord, { recordId: '$recordId', fields: [LEASE_TYPE] })
    wiredOpportunity({ error, data }) {
        if (data) {
            const lease = getFieldValue(data, LEASE_TYPE);
            this.leaseType = lease;
            
            // Reset flags
            this.retail = false;
            this.land = false;
            this.officeOrRetail = false;
            
            switch (lease) {
                case 'Office':
                this.officeOrRetail = true;
                break;
                case 'Retail':
                this.retail = true;
                this.officeOrRetail = true;
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
    
    get seeUpload() {
        return this.leaseDurationValue > 30;
    }
    
    handleLeaseDurationChange(event) {
        this.leaseDurationValue = parseInt(event.target.value, 10);
    }
    
    get acceptedFormats() {
        return ['.pdf', '.png'];
    }
    
    handleUploadFinished(event) {
        const uploadedFiles = event.detail.files;
        if (uploadedFiles.length > 0) {
            this.uploadedImgName = uploadedFiles[0].name;
        }
    }
    
    handleSuccess(event) {
        const qId = event.detail.id;
        this.quoteId = qId;
        console.log('Quote created with Id:', qId);
        
        this.dispatchEvent(new ShowToastEvent({
            title: 'Success',
            message: 'Quote successfully created!',
            variant: 'success'
        }));
        
        this.navigateToQuote(qId);
    }
    
    handleError(event) {
        const detail = event?.detail || 'Unknown error';
        console.error('Error creating quote:', detail);
        
        this.dispatchEvent(new ShowToastEvent({
            title: 'Error',
            message: typeof detail === 'string' ? detail : JSON.stringify(detail),
            variant: 'error'
        }));
    }
    handleSubmit(event) {
        // Prevent default form submit
        event.preventDefault();
        
        const fields = event.detail.fields;
        
        // Inject value for land quotes
        if (this.land) {
            fields.Payment_Terms__c = 4;
        }
        
        this.template.querySelector('lightning-record-edit-form').submit(fields);
    }
    
    
    navigateToQuote(qId) {
        this[NavigationMixin.Navigate]({
            type: 'standard__recordPage',
            attributes: {
                recordId: qId,
                objectApiName: 'Quote__c',
                actionName: 'view'
            }
        });
    }
}
