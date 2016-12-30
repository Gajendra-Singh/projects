public class SearchController 
{

public Map<Id,Property__c> searchResults {get; set;}
public List<SelectOption> mapvalue_lst {get; set;}
public String RadioValue{get; set;} 
public List<Week_Rate__c> list53{get;set;}
public SearchController() 
{
    searchResults= new Map<Id,Property__c>();
    mapvalue_lst= new List<SelectOption>();
    RadioValue='';
    list53= new List<Week_Rate__c>();
}
    
public String searchText
{
    // get is used to send the text to the visual force page.
    get
    {
        if(searchText==null)
        searchText='';
        return searchText;
    }   
    set;
} 

public void search()
{     
	mapvalue_lst.clear();   
    String qry='Select ID, Name From Property__c WHERE name LIKE \'%' +searchText+ '%\'';
    SearchResults = new Map<Id,Property__c>((List<Property__c>)Database.query(qry));
    
    for(Id key:SearchResults.keySet())
    {
    	mapvalue_lst.add(new SelectOption((String)SearchResults.get(key).name,(String)SearchResults.get(key).name));
    	mapvalue_lst.sort();
    }    
}

public void itemDate53()
{
	list53.clear();
	for(integer i=0;i<53;i++)
	{
	   list53.add(new Week_Rate__c());
	
	}
	
	for(Week_Rate__c ss: list53)
	{
		System.debug('pANY'+ss);
	}
	
}

public void itemDate53insert()
{
	for(Week_Rate__c ss: list53)
	{
		System.debug('wwpANY'+ss.weekDate__c);
	}
}



}