import { LightningElement } from 'lwc';

export default class CalculatorComponent extends LightningElement {
    equation='';
    chars1 = ['(', ')', '%', '/'];
    chars2 = ['7', '8', '9', '*'];
    chars3 = ['4', '5', '6', '-'];
    chars4 = ['1', '2', '3', '+'];

    chars = ['(', ')', '%', '/', '7', '8', '9', '*', '4', '5', '6', '-', '1', '2', '3', '+']
    .map((char, index) => {
        return { id: `char-${index}`, value: char };
    });
    result;
    // changeEquation(event){
    //     // not used
    //     this.equation = event.target.value;
    // }

    removeLastChar(){
        // del to remove last char
       this.equation =  this.equation.slice(0,this.equation.length-1);
    //    this.result = eval('12*5/4*(7+1)');
    }

    addCharToEquation(event){
        this.equation += event.target.label;
    }

    clearEquation(){
        this.equation = '';
        this.result = '';
    }
    getResult(){
        this.result = eval(this.equation);
    }


}