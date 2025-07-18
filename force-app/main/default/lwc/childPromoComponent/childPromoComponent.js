import { LightningElement , api} from 'lwc';

export default class ChildPromoComponent extends LightningElement {
    @api message;
    @api count;
}