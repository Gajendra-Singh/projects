trigger accountAddressTest on Contact (before Insert, Before update) {

   try{   
        set<id> accountIds= new set<id>();
        for(contact cont : Trigger.new){
            accountIds.add(cont.AccountId);        
        }
        
        Map<Id, Account> map1= new Map<Id, Account>([Select BillingStreet, BillingCity, BillingCountry, BillingPostalCode, BillingState from Account where id in : accountIds]);
        
        for(contact cont: Trigger.new){    
        Account acc= new Account();
        acc= map1.get(cont.AccountId);
        
        if(acc.BillingStreet!=null && acc.BillingCity!=null && acc.BillingCountry!=null && acc.BillingState!=null && acc.BillingPostalCode != null){
         
         cont.otherStreet= acc.BillingStreet;
         cont.othercity = acc.BillingCity;
         cont.otherPostalcode = acc.BillingPostalCode;
         cont.otherState = acc.billingState;
         cont.otherCountry= acc.BillingCountry;
        
        }
        else{
            cont.addError('Sanjay Error');
        }
        
        
        }
        
   }
   catch(Exception e){
   
        for(contact cont: Trigger.new){
            cont.addError(e.getmessage());
        }
   
   }
        
    
    
}