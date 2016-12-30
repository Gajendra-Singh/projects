@isTest
public class TestDataFactory {
    public static List<Account> createAccountsWithContacts(Integer numAccts, Integer numContPerAcct) {
        List<Account> accts = new List<Account>();
        
        for(Integer i=0;i<numAccts;i++) {
            Account a = new Account(Name='TestAccount' + i);
            accts.add(a);
        }
        insert accts;        
        
        List<Contact> conts = new List<Contact>();            
        for (Integer j=0;j<numAccts;j++) {
            Account acct = accts[j];
            // For each account just inserted, add conatcts
            Integer posNegDiv = numContPerAcct/2;
            for (Integer k=0;k<posNegDiv;k++) {
                conts.add(new Contact(LastName='TestContact'+ k, 
                                      AccountId=acct.Id,
                                      aaaabbbb__Type__c='Positive',
                                      aaaabbbb__Amount_X__c = k));                
            }
            for (Integer k=0;k<posNegDiv;k++) {
                conts.add(new Contact(LastName='TestContact'+ k, 
                                      AccountId=acct.Id,            
                                      aaaabbbb__Type__c='Negative',
                                      aaaabbbb__Amount_Y__c = k));                
            }        
        }    
        // Insert all contacts for all accounts.
        insert conts;
        
        return accts;
    }
}