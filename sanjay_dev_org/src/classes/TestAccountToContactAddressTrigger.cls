@isTest
class TestAccountToContactAddressTrigger{

    static testMethod void testContactTrigger1(){
    
     Contact cont= new Contact(LastName='test contact');
     insert cont;
    }

    static testMethod void testContactTrigger2(){
    
        Account acct = new Account(name='test account');
        acct.BillingStreet='Raja Park';
        acct.BillingCity='Jaipur';
        acct.BillingPostalCode='302002';
        acct.BillingState='Rajasthan';
        acct.BillingCountry='India';   
    
        insert acct;  
    
        Contact cont= new Contact(LastName='test contact');
        cont.AccountId= acct.Id;  
         
        insert cont;    
    }
    
     static testMethod void testContactTrigger3(){
    
        Account acct = new Account(name='test account');
        acct.BillingStreet='Raja Park';
        acct.BillingCity='Jaipur';
        acct.BillingPostalCode='302002';
        acct.BillingState='Rajasthan';        
    
        insert acct;  
    
        Contact cont= new Contact(LastName='test contact');
        cont.AccountId= acct.Id;  
         
        insert cont;    
    }
}