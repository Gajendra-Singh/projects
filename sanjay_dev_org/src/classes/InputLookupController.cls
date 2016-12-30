public class InputLookupController   
{     
   public String name{get{return 'Account';}}
   @RemoteAction //remote action annotation 
   public static List<sObject> getList(String MyString, String sObjVal, String fieldVal)   
   {  			 
   			//List<String> listofitems= new List<String>();
   			//Map<ID, String> m1 = new Map<ID, String>();
   			//System.debug('mystring'+MyString);
   			//System.debug('sObjVal1 --'+sObjVal1);
		   	 // create the filter text
		   	 System.debug('MyString----'+MyString+'sObjVal------'+sObjVal+'fieldVal---'+fieldVal);
		   	 String filter = ' like \'%' + String.escapeSingleQuotes(MyString) + '%\'';	 
		   	 // dynamic soql query  	
		   	 String soql='SELECT '+fieldVal+' From '+sObjVal +' where Name ' +filter ;	
		   	 System.debug('soql--'+soql);
		   	// String soql='SELECT Name From Merchandise__c '+ 'Where name '+filter ;		   	   	 
		  	List<sObject> L = new List<sObject>();
	        try 
	        {
	            L = Database.query(soql);		  
	            
	        }
	        catch (QueryException e) 
	        {		
	            System.debug('e--'+e) ; 
	        }        
	         
    	   return L;    	 
   }  
}