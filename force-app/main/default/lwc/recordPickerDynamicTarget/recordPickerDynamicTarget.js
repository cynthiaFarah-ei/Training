import { LightningElement } from 'lwc';

export default class RecordPickerDynamicTarget extends LightningElement {
    selected = 'Account';

    get options() {
        return [
            { label: 'Account', value: 'Account' },
            { label: 'Contact', value: 'Contact' }
        ];
    }
    
    handleChange(event) {
        this.selected = event.detail.value;
    }
    
    get placeholder(){
        if(this.selected === 'Account'){
            return 'Search Accounts...';
        } else if(this.selected === 'Contact'){
            return 'Search Contacts...';
        }
    }

    get displayInfo() {
        if (this.selected === 'Account') {
            return {
                primaryField:'Name' ,
                additionalFields: [ 'Type']
            };
        } else if (this.selected === 'Contact') {
            return {
                primaryField: 'Name' ,
                additionalFields: ['Title']
            };
        }
        return {
            primaryField: 'Name'
        };
    }
    
    
    get matchingInfo() {
        if (this.selected === 'Account') {
            return {
                primaryField: { fieldPath: 'Name' },
                additionalFields: [{ fieldPath: 'Type' }]
            };
        } else if (this.selected === 'Contact') {
            return {
                primaryField: { fieldPath: 'Name' },
                additionalFields: [{ fieldPath: 'Phone' }]
            };
        }
        return {
            primaryField: { fieldPath: 'Name' }
        };
    }
    visible = true;
    handleRecordChange(event) {
        const selectedId = event.detail.recordId;
        
        if (selectedId) {
            // A record was selected
            this.visible = false;
        } else {
            // Selection was cleared (user clicked X)
            this.visible = true;
        }
    }
    
}