@isTest
public with sharing class CreateOutreachXController_Test 
{
	static testMethod void CreateOutreachXControllertest()   
	{
        PageReference pageRef = Page.CreateOutreachX; 
    	Test.setCurrentPage(pageRef); 
		
		Account acc= new Account(name='Burlington Textiles Corp of America');
		insert acc;	
        Contact c = new Contact(FirstName='John',LastName='Doe',Accountid=acc.id);
    	insert c;
		Test.startTest();
		
		ApexPages.StandardSetController StandardsObjectController = new ApexPages.StandardSetController([SELECT Id, Name FROM Account WHERE ID =: acc.id]);  
		CreateOutreachXController COCobj  = new CreateOutreachXController(StandardsObjectController);        
        String nextPage = COCobj.CreateContacts().getUrl();
        String cancelPage = COCobj.cancelBtn().getUrl(); 
        COCobj.nameTxt='FirstName Text';
        COCobj.LastnameTxt= 'LastName Text';       
        COCobj.AccList.add(acc);
        COCobj.AccIds.add(acc.id);
        COCobj.CreateContacts();
        COCobj.cancelBtn(); 
        
		Test.stopTest();             
		
		
		
	}

}