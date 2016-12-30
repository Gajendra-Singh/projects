@isTest
private class ContactTriggerTest{

    @testSetup static void dataSetup(){
        // Test data setup
        // Create two account with ten contact by calling a utility method
        Account[] accts = TestDataFactory.createAccountsWithContacts(2,10);           
        System.assert(accts.size() == 2);         
    }
    
    @isTest static void unitInsert() { 
          
        Account[] accts =[Select Id from Account Limit 2];
          
        Account acctTest1 = [Select Id, aaaabbbb__MyContacts__c, aaaabbbb__Rollup_Amount__c, aaaabbbb__Rollup_Amount_X__c, aaaabbbb__Rollup_Amount_Y__c  From Account Where Id =:accts[0].Id]; 
        System.assert(acctTest1.aaaabbbb__MyContacts__c == 10);          
        System.assert(acctTest1.aaaabbbb__Rollup_Amount_X__c == 10);   
        System.assert(acctTest1.aaaabbbb__Rollup_Amount_Y__c == 10);   
        System.assert(acctTest1.aaaabbbb__Rollup_Amount__c == 20);                          
             
        Account acctTest2 = [Select Id, aaaabbbb__MyContacts__c, aaaabbbb__Rollup_Amount__c, aaaabbbb__Rollup_Amount_X__c, aaaabbbb__Rollup_Amount_Y__c From Account Where Id =:accts[1].Id]; 
        System.assert(acctTest2.aaaabbbb__MyContacts__c == 10);                               
        System.assert(acctTest2.aaaabbbb__Rollup_Amount_X__c == 10);  
        System.assert(acctTest2.aaaabbbb__Rollup_Amount_Y__c == 10);   
        System.assert(acctTest2.aaaabbbb__Rollup_Amount__c == 20);                                      
                            
    }
    
    @isTest static void unitUpdate() { 
        
        Account[] accts =[Select Id from Account Limit 2];
        
        List<Contact> contList1 = new List<Contact>([Select id, aaaabbbb__Amount_X__c from contact where AccountId =:accts[0].Id]);                      
        List<Contact> contList2 = new List<Contact>([Select id from contact where AccountId =:accts[1].Id]);  
        
        System.assert(contList1.size() == 10);  
        System.assert(contList2.size() == 10); 
        
        for(Integer i=0; i<4; i++){        
            contList1[i].AccountId  = accts[1].Id; 
            contList1[i].aaaabbbb__Amount_X__c  += 1;
        }
        
        update contList1;    
        
        Account acctTest1_update = [Select Id, aaaabbbb__MyContacts__c, aaaabbbb__Rollup_Amount__c, aaaabbbb__Rollup_Amount_X__c, aaaabbbb__Rollup_Amount_Y__c  From Account Where Id =:accts[0].Id]; 
        System.assert(acctTest1_update.aaaabbbb__MyContacts__c == 6);  
        System.assert(false, acctTest1_update.aaaabbbb__Rollup_Amount_X__c);                           
             
        Account acctTest2_update = [Select Id, aaaabbbb__MyContacts__c From Account Where Id =:accts[1].Id]; 
        System.assert(acctTest2_update.aaaabbbb__MyContacts__c == 14);                                                                                         
        
    }  
    
    @isTest static void unitDelete() { 
         
         Account[] accts =[Select Id from Account Limit 1];
        
         List<Contact> contList1 = new List<Contact>([Select id from contact where AccountId =:accts[0].Id]);    
         delete contList1;                
        
         Account acctTest1_delete = [Select Id, aaaabbbb__MyContacts__c From Account Where Id =:accts[0].Id]; 
         System.assert(acctTest1_delete.aaaabbbb__MyContacts__c == 0);          
       
         undelete contList1;
         Account acctTest1_undelete = [Select Id, aaaabbbb__MyContacts__c From Account Where Id =:accts[0].Id]; 
         System.assert(acctTest1_undelete.aaaabbbb__MyContacts__c == 10);                                          
    } 
          
}