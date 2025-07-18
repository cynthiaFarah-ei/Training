import { LightningElement , track} from 'lwc';

export default class UserProfileCard extends LightningElement {
    
    @track user1 = {
        name: 'cynthia farah',
        title: 'junior consultant',
        email: 'cynthia.farah@eit-mena.com',
        status: 'Online' // or 'Offline'
    };
    
    @track user2 = {
        name: 'anthony farah',
        title: 'developer',
        email: 'anthony@gmail.com',
        status: 'Offline' // or 'Offline'
    };
    @track displayedUser = this.user1;//def one reference in memory so we can use it to change value
    
    toggleUser(){
        if(this.displayedUser == this.user1){
            this.displayedUser = this.user2;
        }else{
            this.displayedUser = this.user1;
        }
    }
    
    get statusButtonVariant() {
        return this.displayedUser.status === 'Online' ? 'success' : 'destructive';
    }

    toggleStatus(){
        this.displayedUser.status = this.displayedUser.status === 'Online' ? 'Offline' : 'Online';
    }
}