@isTest
public class accountList_TestClass
{
	static testMethod void myTest()
	{
		
		Test.startTest();
		
		List<Account> objList =new List<Account>( );
		
		
		Account obj =new Account();
		obj.name ='balram tyagi';
		obj.BillingState ='Muzaffarnagar';
		obj.fax ='0131';
		obj.phone ='2480660';
		obj.site ='Nirmana';
		
		accountList.wrapperClassForCheckBox ob1 = new  accountList.wrapperClassForCheckBox(obj);
        
		
		
		
		objList.add(obj);
       
		
		Account obj1 =new Account();
		
		
		obj1.name ='balram tyagi1';
		obj1.BillingState ='Muzaffarnagar1';
		obj1.fax ='01312';
		obj1.phone ='24806603';
		obj1.site ='Nirmana1';
		
		objList.add(obj1);
        
        insert objList;
		
		accountList objct = new accountList();
		
		objct.alphabet = 'All';
		objct.alphabet = 'a';		
		objct.counter = 100;
		objct.listDetail1();
		
		objct.check();		
			
		objct.Accept = '10';
        objct.noFromList11();
		
		objct.getCountRecords();
		objct.SelectedAccountId = obj.id;		
		objct.count = obj;
		objct.delAccount();
		objct.alphabet = 'a';		
		objct.getFilter();
		objct.alphabet = 'All';		
		objct.getFilter();
		objct.getItems();
		objct.getAccept();
		objct.setAccept('sahdev');
		
		objct.nextPage();
		objct.previousPage();
		objct.firstRecords();
        objct.pageNumber();
        
        objct.nofromPage = 25;
        objct.totalRecs = 30;
        objct.counter = 1;
		objct.lastRecords();
		
		objct.counter = 0;
		objct.getprev();
		
		objct.counter = 1;
		objct.getprev();
		
		objct.counter = 1;
		objct.nofromPage = 1;
		objct.totalRecs = 30;
		objct.getnxt();
		
		objct.counter = 10;
		objct.nofromPage = 10;
		objct.totalRecs = 3;
		objct.getnxt();
		
		objct.totalRecs = 30;
		objct.nofromPage = 25;		
		objct.getTotalPages();
		
		objct.totalRecs = 0;
		objct.nofromPage = 1;		
		objct.getTotalPages();
		
		objct.getStartNumberOnPage();
		
		objct.nofromPage = 20;
		objct.counter = 10;
		objct.totalRecs = 5;
		objct.getEndNumberOnPage();
		
		objct.nofromPage = 1;
		objct.counter = 1;
		objct.totalRecs = 50;
		objct.getEndNumberOnPage();		
		
		objct.pageNumberFormBoxInteger = 55;
		objct.nofromPage = 10;
		objct.totalRecs = 30;
		objct.counter = 1;
		objct.getpgNUmberFormBox12();
		
		objct.pageNumberFormBoxInteger = 0;
		objct.getpgNUmberFormBox12();	
		
		
		objct.nofromPage = 5;
		objct.totalRecs = 2;
		objct.getpgNUmberFormBox12();
		
		ob1.selectedCheckBox = true;		
		objct.wrapperClassForCheckBoxList.add(ob1);
		objct.processSelected();
		
		objct.getCsvMethod();
        
        
		Test.stopTest();
	}
	
}