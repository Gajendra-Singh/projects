@isTest     
public with sharing class autoCompleteTypeaheadController_Test 
{
    static testMethod void autoCompleteTypeaheadControllertest()
    {
        Account acc= new Account(name='Burlington Textiles Corp of America');
        insert acc;
        Test.startTest();
        
        autoCompleteTypeaheadController.getList('a','Account', 'Name');
        
        Test.stopTest();     
        
    }
    
    static testMethod void autoCompleteTypeaheadControllertest1()
    {
        Account acc= new Account(name='Burlington Textiles Corp of America');
        insert acc;
        Test.startTest();
        
        autoCompleteTypeaheadController.getList('a','Account', 'Nae');
        
        Test.stopTest();     
        
    }
}