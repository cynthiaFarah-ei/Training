import { LightningElement, api } from 'lwc';

export default class ParentComponent extends LightningElement {

    status;
    child1Status = 'select';// child bl awal select 
    child2Status = 'select';
    label;
    handleChildEvent(event){
        this.status = event.detail.childstatus;
        this.label = event.detail.label; // to know which child is changed
        if(this.label === "Child1"){
            this.child1Status = this.status;
        }else {
            this.child2Status = this.status
        }

    }

    @api
    resetChildren() {
        console.log('Parent resetting children...');
        const children = this.template.querySelectorAll('c-child-component');
        children.forEach(child => child.resetStatus());
    }
}