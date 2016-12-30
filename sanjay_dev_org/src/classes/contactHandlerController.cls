public class contactHandlerController {

        public static void contCountMethod(Set<Id> accountIds){
            List<Account> accountList = [Select Id, aaaabbbb__MyContacts__c,(Select Id from Contacts) from Account Where Id In :accountIds];
            for(Account acc : accountList){
                acc.aaaabbbb__MyContacts__c = acc.Contacts.size();
            }
            update accountList;          
        }
}