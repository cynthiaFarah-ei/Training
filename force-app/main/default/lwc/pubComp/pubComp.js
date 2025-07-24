import { LightningElement, wire } from 'lwc';
import { fireEvent } from 'c/pubsub';
import {CurrentPageReference} from 'lightning/navigation';
export default class PubComp extends LightningElement {

    text;
    @wire(CurrentPageReference) pageRef;

    handleTextChange(event){
        this.text = event.target.value;
    }

     publishEvent() {
        if (this.pageRef) {
            fireEvent(this.pageRef, 'sendTextEvent', this.text);
        } else {
            console.warn('PageRef not ready yet.');
        }
    }
}