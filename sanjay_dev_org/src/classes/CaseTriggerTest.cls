@isTest
public with sharing class CaseTriggerTest 
{
	static testMethod void CaseTrigger_Test()
	{
		Case caseObj= new Case(Description='aman sanjay aman');
		insert caseObj;	
		
	}
}