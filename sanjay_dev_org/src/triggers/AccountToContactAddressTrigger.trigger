trigger AccountToContactAddressTrigger on Contact (before Insert){
    try{
         
       set<id> accountIdSet= new set<id>();       
       for(Contact c:Trigger.new){           
           accountIdSet.add(c.AccountId);       
       }       
         
        Map<Id, Account> map1= new Map<Id, Account>([SELECT BillingStreet, BillingCity, BillingPostalCode, BillingState, BillingCountry FROM Account Where ID IN: accountIdSet]); 
       
        for(Contact c: Trigger.new){        
            Account acc= new Account();
            acc=map1.get(c.AccountId);             
           
            if(acc.BillingStreet!= null && acc.BillingCity!=null && acc.BillingPostalCode!=null && acc.BillingState!=null && acc.BillingCountry!=null){                           
                c.OtherStreet = acc.BillingStreet;
                c.OtherCity= acc.BillingCity;
                c.OtherPostalCode= acc.BillingPostalCode;
                c.OtherState= acc.BillingState;
                c.OtherCountry= acc.BillingCountry;       
            }
            else{                 
                c.addError('Please Fill all the Fields of Account Billing Address');
            }    
         }
    }
    catch(Exception e){        
         for(Contact c: Trigger.new){        
           c.addError(e.getMessage());        
        }    
    }
}