import { LightningElement, api } from 'lwc';

export default class ChildComponent extends LightningElement {
    @api label; // parent by3tia yeha eza hi child 1 or 2
    @api status = 'select'; // def value
    get statusButtonVariant() {
        return this.status === 'select' ? 'success' : 'destructive';
    }
    
    toggleStatus(){
        this.status = this.status === 'select'? 'deselect' : 'select';
        
        const sendEvent = new CustomEvent('changechildstatus',{
            bubbles: true,
            composed: true,
            detail : {childstatus: this.status, label : this.label}
        });
        
        this.dispatchEvent(sendEvent);
    }
    
    @api resetStatus() {
        this.status = 'deselect';
        const sendEvent = new CustomEvent('changechildstatus',{
            bubbles: true,
            composed: true,
            detail : {childstatus: this.status, label : this.label}
        });
        
        this.dispatchEvent(sendEvent);
    }
}