@isTest
public with sharing class InsertBeforeTriggerTest 
{
	static testMethod void InsertBeforeTrigger_test()
	{
		test.starttest();
		TriggerObject__c TObj1= new TriggerObject__c(Number__c=1,Name='One');
		insert TObj1;
		TriggerObject__c TObj2= new TriggerObject__c(Number__c=2,Name='Two');
		insert TObj2;
		test.stoptest();
		
	}

}