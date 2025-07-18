import { LightningElement, track, api } from 'lwc';

export default class PromoComponent extends LightningElement {
    x='Cynthia ';
    @track names = ['cynthia', 'maria', 'anthony'];
    displayX = false;
    connectedCallback(){
        console.log('connected callback fires');
    }
    displayX=true;
    renderedCallback(){
        console.log('rendered callback fires');

    }
    // without track in alert it changed but in page no use track to rerender values
    // if we reassign names kela bt3ml rerend
    handleClick(){
        this.names[0]= 'maria';
        alert('hello ' + this.names);
    }
    toggleX(){
        this.displayX = !this.displayX;
    }


    counter=0;
    incCounter(){
        this.counter++;
    }
    decCounter(){
        this.counter--;
    }
}