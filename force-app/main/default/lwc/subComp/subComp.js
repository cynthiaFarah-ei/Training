import { LightningElement , wire} from 'lwc';
import {CurrentPageReference} from 'lightning/navigation';
import { registerListener, unregisterAllListeners } from 'c/pubsub';

export default class SubComp extends LightningElement {
    text='';
    once=true;
    @wire(CurrentPageReference) pageRef;
    connectedCallback(){
        if(this.once){
            registerListener('sendTextEvent', this.setCaptureText, this);
            this.once = false;
        }
    }
    
    disconnectedCallback(){
        unregisterAllListeners(this);
    }
    setCaptureText(txt){
        this.text = txt;
    }
}