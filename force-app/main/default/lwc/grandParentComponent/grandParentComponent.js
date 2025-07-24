import { LightningElement, track } from 'lwc';

export default class GrandParentComponent extends LightningElement {
    @ track count = 2;
    child1status='select';
    child2status='select';
    status;
    label;
    handleSelectionChange(event) {
        console.log('child handler on grand parent');
        this.label = event.detail.label;
        if(this.label === 'Child1'){
            this.child1status = event.detail.childstatus;
        }else if(this.label === 'Child2'){
            this.child2status = event.detail.childstatus;
        }
    }
    get statusCount(){ this.count = 0;
        if(this.child1status === 'select') ++this.count;
        if(this.child2status === 'select') ++ this.count;
        return this.count;
    }

    resetAllChildren(){
        console.log('in reset all children 1');
    const parent = this.template.querySelector('c-parent-component');
    console.log('in reset all children 1 between');
    if (parent) {
        this.count = 0;
        parent.resetChildren(); // Call the @api method exposed in the parent
    }
    }
}