global with sharing class AngularDemoController {
   // hardcode an account id for demo purposes
   static String accountId = '00128000005dTAM';
 
   global static String getAccount() {
       return JSON.serialize([select name, billingstreet,
           billingcity, billingstate, billingpostalcode
           from account where id = :accountId][0]);
   }    
 
   global static String getContacts() {
       return JSON.serialize([select id, name, email
           from contact where accountId = :accountId]);
   }
   
   
   @remoteAction
   public static List<Account> getTestAccountList(){   
      return [Select Id, Name from Account Limit 10];   
   }
   
    @remoteAction
   public static List<Opportunity> getTestOpportunityList(){   
      return [Select Id, Name from Opportunity Limit 10];   
   }
   
   
}