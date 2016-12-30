public with sharing class ContactTriggerHandler{
    
    /**
    * This method will execute after contact are inserted.
    **/
    public static void OnAfterInsert(List<Contact> newContacts,Map<Id,Contact> newContactMap){
        afterInsertContactBusinessRules( newContacts, newContactMap );
    }
    
    /**
    * This method will execute after contact are updated.
    **/
    public static void OnAfterUpdate(List<Contact> newContacts,Map<Id,Contact> newContactMap,List<Contact> oldContacts,Map<Id,Contact> oldContactMap){
        afterUpdateContactBusinessRules(newContacts, newContactMap, oldContacts, oldContactMap);           
    }
    
    /**
    * This method will execute after contact are deleted.
    **/
    public static void OnAfterDelete(List<Contact> oldContacts, Map<Id,Contact> oldContactMap){
        afterDeleteContactBusinessRules(oldContacts, oldContactMap);
    }        
    
    /**
    * This method will execute after contact are undeleted.
    **/
    public static void OnAfterUndelete(List<Contact> newContacts,Map<Id,Contact> newContactMap){
        afterUndeleteContactBusinessRules(newContacts, newContactMap);
    }
    
    
    /**
    * This method handle business rules after insertion of Contact.
    **/
    private static void afterInsertContactBusinessRules( List<Contact> newContacts, Map<Id,Contact> newContactsMap ){      
        
        Set<Id> accountIds = newtriggerMethod(newContacts);      
        
        //Populating Contact Count field in Account Object.
        if(accountIds.size()> 0){
            contCountMethod(accountIds);
        }   
        
        // To calulate Roll-up on Account Positive & Negative
        rollupchild(newContacts,new Map<Id,Contact>());     
    }
    
    /**
    * This method handle business rules after updation of Contact.
    **/
    private static void afterUpdateContactBusinessRules(List<Contact> newContacts, Map<Id,Contact> newContactsMap, List<Contact> oldContacts, Map<Id,Contact> oldContactMap){
        
        // Contact Count Bussiness Logic
        Set<Id> accountIds = new Set<Id>();
        for(Contact con : newContacts){            
            Contact oldContact = oldContactMap.get(con.Id);              
            //Checking whether oldValue is different with new value or not
            if(con.AccountId != oldContact.AccountId){                    
                accountIds.add(con.AccountId);  
                accountIds.add(oldContact.AccountId);                             
            }       
        }                    
        
        if(accountIds.size()>0){                
            contCountMethod(accountIds);            
        }
        
        // Roll-up Posive & Negative Bussiness Logic
        Set<Id> accountIdsPosNeg = new Set<Id>();
        for(Contact con : newContacts){            
            Contact oldContact = oldContactMap.get(con.Id);              
            //Checking whether oldValue is different with new value or not
            if(con.aaaabbbb__Amount_X__c != oldContact.aaaabbbb__Amount_X__c || con.aaaabbbb__Amount_Y__c != oldContact.aaaabbbb__Amount_Y__c || con.aaaabbbb__Type__c!= oldContact.aaaabbbb__Type__c){                        
                accountIdsPosNeg.add(con.AccountId);   
            }       
        }                    
        
        if(accountIdsPosNeg.size()>0){                
            List<Contact> contList = [Select id, AccountId, aaaabbbb__Amount_X__c, aaaabbbb__Amount_Y__c, aaaabbbb__Type__c from contact where AccountId IN :accountIdsPosNeg];
            rollupLogic(contList);
        }        
               
    }
    
    /**
    * This method handle business rules after deletion of Contact.
    **/
    private static void afterDeleteContactBusinessRules(List<Contact> oldContacts,Map<Id,Contact> oldContactMap){
        
        Set<Id> accountOldIds = newtriggerMethod(oldContacts);    
                
        //Populating Contact Count field in Account Object for deleted Contacts
        if(accountOldIds.size()> 0){
            contCountMethod(accountOldIds);
        }
        
        // To calulate Roll-up on Account Positive & Negative
        rollupchild(oldContacts,new Map<Id,Contact>());     
                           
    }            
    
    /**
    * This method handle business rules after undeletion of Contact.
    **/
    private static void afterUndeleteContactBusinessRules(List<Contact> newContacts, Map<Id,Contact> newContactMap){
        
        // This rule is same as Insert Bussiness Rule
        afterInsertContactBusinessRules( newContacts,newContactMap );
    }
    
    /**    
        Logic to return set for Trigger.new
    **/
    public static set<Id> newtriggerMethod(List<Contact> newContacts){
            
        Set<Id> accountIds = new Set<Id>();        
        for(Contact cont : newContacts){
            if(cont.AccountId != null){
                accountIds.add(cont.AccountId);
            }
        }
        
        return accountIds;
    }
    
    /**
        Logic to populate the value of the Account field on the Account Object.
    **/
    public static void contCountMethod(Set<Id> accountIds){
    
        if(accountIds != null){                        
            List<Account> accountList = [Select Id, aaaabbbb__MyContacts__c,(Select Id from Contacts) from Account Where Id In :accountIds];
            for(Account acc : accountList){
                acc.aaaabbbb__MyContacts__c = acc.Contacts.size();
            }
            
            update accountList;          
        }
            
    }
    
    /**
        Logic for Roll-Up Positive & Negative
    **/
    public static void rollupchild(List<Contact> newContacts, Map<Id,Contact> newContactsMap){
            
            // Logic to send the List for new values in Inset/Delete/Update/undelete case
            if(newContacts.size()>0){            
                rollupLogic(newContacts);            
            }         
    }
    
    /**
        Roll-Up Bussiness Logic
    **/
    public static void rollupLogic(List<Contact> newContacts){
        
            Map<Id,Id> Pos_cont_accIdListMap = new Map<Id,Id>();
            Map<Id,Id> Neg_cont_accIdListMap = new Map<Id,Id>();
            Map<Id,Id> Tot_cont_accIdListMap = new Map<Id,Id>();
            //system.assert(false , newContacts);
            for(Contact cont : newContacts){
                if(cont.AccountId != null){
                    if(cont.aaaabbbb__Type__c =='Positive'){
                        Pos_cont_accIdListMap.put(cont.Id, cont.AccountId);
                        Tot_cont_accIdListMap.put(cont.Id, cont.AccountId); 
                    }
                    if(cont.aaaabbbb__Type__c =='Negative'){
                        Neg_cont_accIdListMap.put(cont.Id, cont.AccountId);
                        Tot_cont_accIdListMap.put(cont.Id, cont.AccountId); 
                    }
                }               
           }  //system.assert(false, 'positiveContactIds--->'+positiveContactIds+ 'negativeContactIds-->'+ negativeContactIds + 'totalContactIds-->'+totalContactIds );
            
               
    }       
}