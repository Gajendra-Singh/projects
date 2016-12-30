trigger updateMyContactTest on Contact (after Insert, after update, after delete, after undelete) {

            set<id> accountIds= new set<id>();
            for(contact cont : Trigger.new){
                accountIds.add(cont.AccountId);        
            }            
            
            List<Account> accList= new List<Account>();
            
            if(accountIds!=null){
               accList= [Select id, aaaabbbb__MyContacts__c, (select id from contacts) from Account where id in : accountIds];           
            }      
                    
            Set<Id> contactIds = new Set<Id>();
            if(accList!=null){        
                for(Account acc: accList){               
                       for(Contact cont: acc.contacts){
                           contactIds.add(cont.Id);
                       }             
                }
                
            }
            
            for(Account acc: accList){        
                acc.aaaabbbb__MyContacts__c = contactIds.size();           
            }
             
            if(accList.size()>0){            
                update accList; 
            } 
      
             
            if(Trigger.isUpdate){       
            
                set<id> accountOldIds= new set<id>();
                for(contact cont : Trigger.old){
                    accountOldIds.add(cont.AccountId);
                   // system.assert(false, 'testst'+ accountOldIds) ;      
                }
                
                List<Account> accOldList= new List<Account>();
                
                if(accountOldIds!=null){
                   accOldList= [Select id, aaaabbbb__MyContacts__c, (select id from contacts) from Account where id in : accountOldIds];           
                }      
                        
                Set<Id> contactOldIds = new Set<Id>();
                if(accOldList!=null){        
                    for(Account acc: accOldList){               
                           for(Contact cont: acc.contacts){
                               contactOldIds.add(cont.Id);
                           }             
                    }
                    
                }
                
                //system.assert(false, 'sanjay'+contactOldIds);
                for(Account acc: accOldList){        
                    acc.aaaabbbb__MyContacts__c = contactOldIds.size();           
                }
                 
                if(accOldList.size()>0){
                    update accOldList;  
                }        
           
          }
}