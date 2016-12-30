global with sharing class autoCompleteTypeaheadController 
{
        
    // This function is used to make list of items on KeyPress Event.
    @RemoteAction //remote action annotation 
   global static List<sObject> getRecordslst(String MyString, String sObjVal, String fieldVal)   
   {             
            //List<String> listofitems= new List<String>();
            //Map<ID, String> m1 = new Map<ID, String>();
            System.debug('mystring'+MyString);
            System.debug('sObjVal1 --'+sObjVal);
            System.debug('fieldVal--'+fieldVal);
             // create the filter text
             String filter = ' like \'%' + String.escapeSingleQuotes(MyString) + '%\'';  
             // dynamic soql query      
             String soql='SELECT '+fieldVal+' From '+sObjVal +' where Name ' +filter ;  
             System.debug('soql--'+soql);
            // String soql='SELECT Name From Merchandise__c '+ 'Where name '+filter ;                
            List<sObject> L = new List<sObject>();
            try 
            {
            					
                L = Database.query(soql);  
                system.debug('--L---'+L);       
                
            }
            catch (QueryException e) 
            {       
                System.debug('e--'+e) ; 
            }        
             
           return L;         
   }  
   
   
     // This function is used to make list of items on KeyPress Event.
    @RemoteAction //remote action annotation 
   global static string getRecordsList(String MyString)   
   {                  
           return 'sanjy';         
   }  
  
  

}