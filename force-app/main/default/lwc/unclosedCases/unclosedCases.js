import { LightningElement, wire, api, track } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import getUnclosedCases from '@salesforce/apex/OpenToClosedCases.getUnclosedCases';
import closeCase from '@salesforce/apex/OpenToClosedCases.closeCase';
import { refreshApex } from '@salesforce/apex';

export default class UnclosedCases extends LightningElement {
   @track cases = [];
    @track isLoading = false;

    connectedCallback() {
        this.loadOpenCases();
    }

    async loadOpenCases() {
        this.isLoading = true;
        try {
            this.cases = await getUnclosedCases();
        } catch (error) {
            this.showToast('Error', 'Error loading cases', 'error');
            console.error(error);
        }
        this.isLoading = false;
    }

    async handleClose(event) {
        const caseId = event.target.dataset.id;
        this.isLoading = true;
        try {
            await closeCase({ caseId });
            this.showToast('Success', 'Case closed successfully', 'success');
            await this.loadOpenCases(); // refresh after closing
        } catch (error) {
            this.showToast('Error', 'Failed to close case', 'error');
            console.error(error);
        }
        this.isLoading = false;
    }

    showToast(title, message, variant) {
        this.dispatchEvent(new ShowToastEvent({ title, message, variant }));
    }
}