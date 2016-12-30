@isTest
public class OnLineExamController_TestClass
{
    static testMethod void OnLineExamControllerTestt()
    {
        OnLineExamController obj= new OnLineExamController();
        
         Test.startTest();
        
         Paper__c paper= new Paper__c(name='401-DEV');
         
        
         insert paper;
         obj.selectedPaper='404 Exam';
        
         obj.user_var_mp.put('sanjay','sanjay@briskminds.com');
       
         obj.RightShift();        
         obj.Right_Lst.add('pankaj');
         obj.Right_Mp.put('sanjay','sanjay@briskminds.com');
        
         
         obj.LeftShift();
         obj.Left_Lst.add('sanjay');
         obj.Left_Mp.put('sanjay','sanjay@briskminds.com');
         
        
         obj.emailSent();
         
        
         Test.stopTest();
    }
}