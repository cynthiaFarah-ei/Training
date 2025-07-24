import { LightningElement , api, wire} from 'lwc';
import GetOpportunities from '@salesforce/apex/GetOpportunitiesByAccount.GetOpportunities';
const COLUMNS = [
    { label: 'Id', fieldName: 'Id' },
    { label: 'Opp Name', fieldName: 'Name',  
        cellAttributes: {
          class: { fieldName: 'stageClass' }
        } },
    { label: 'Stage', fieldName: 'StageName',  
        cellAttributes: {
          class: { fieldName: 'stageClass' }
        } 
     },
    { label: 'Amount', fieldName: 'Amount', type: 'currency' }
];
export default class DisplayRelatedOpps extends LightningElement {

    @api recordId;
    opps;
    errors;
    columns = COLUMNS;
//    connectedCallback() {
//         window.clearTimeout(this.delayTimeout);
//         this.delayTimeout = setTimeout(() => {
//         //    alert(this.recordId)
//         }, 0);
//     }
    @wire(GetOpportunities, { accountId: "$recordId" }) 
    wired_getOpps({error, data}){
        if (data) {
             this.opps = data.map(row => ({
            ...row,
            stageClass: row.StageName === 'Closed Lost'
                ? 'slds-text-color_error'
                : ''
        }));
            this.errors = undefined;
        } else if (error) {
            this.errors = error;
            this.opps = undefined;
        }
    }
}