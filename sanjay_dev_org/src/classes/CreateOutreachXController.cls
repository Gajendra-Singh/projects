public with sharing class CreateOutreachXController 			
{
	//List of Account Object.
	public List<Account> AccList {get;set;}
    public ApexPages.StandardSetController standardController;
    // Set of Account Ids
    public Set<Id> AccIds = new Set<Id>();
    
    public String nameTxt{get;set;}  
    public String LastnameTxt{get;set;}      		
    
    public Contact cont{get;set;} 

	//constructor
    public CreateOutreachXController(ApexPages.StandardSetController standardController)
    {
    	cont= new Contact();
        this.standardController = standardController;
        AccList = new List<Account>();
        for (Account acc : (List<Account>)standardController.getSelected())
        { 
            AccIds.add(acc.Id);
        }
        AccList = [SELECT  Id,Name FROM Account WHERE ID IN: AccIds];       
    }
    
    // Save Button code
    public PageReference CreateContacts()
    {
    	List<Contact> contactList = new List<Contact>();   
    	    	  
    	for(Account acc: AccList)
    	{
    		//Contact contactObj = new Contact(FirstName='Mani',LastName='Test',Account=acc.id);           		
    		contactList.add(new Contact(FirstName=cont.FirstName,LastName=cont.LastName, Accountid=acc.id)); 
    	}  
    	    	
    	insert contactList;
    	
    	return new PageReference('https://ap2.salesforce.com/003/o');

    }
    
    //cancel Button code
    public PageReference cancelBtn()
    {
    	return new PageReference('https://ap2.salesforce.com/001?fcf=00B280000032c8P');
    }

}