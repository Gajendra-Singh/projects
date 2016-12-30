@isTest
public class QuestionController_TestClass 
{
    static testMethod void QuestionControllerTest()
    {
        Test.startTest();     
        
        question__c qsn1= new question__c();
        
        qsn1.Name='1';
        qsn1.Question__c='Select input devices ?';
        qsn1.Point__c=3;
        qsn1.Multiple__c='YES';
        qsn1.Correct_Answer__c='MOUSE,KEYBOARD';      
        qsn1.ansno__c=2;
        qsn1.Paper__c='a0J28000000BHJX';
                
        insert qsn1;
        
        answer__c ans1= new answer__c();
        
        ans1.Name='KEYBOARD';
        ans1.Questionno__c=qsn1.Id;
        answer__c ans2= new answer__c();
        ans2.name='MONITOR';
        ans2.Questionno__c=qsn1.Id;
        answer__c ans3= new answer__c();
        ans3.Name='MOUSE';
        ans3.Questionno__c=qsn1.Id;
        answer__c ans4= new answer__c();
        ans4.Name='PRINTER';
        ans4.Questionno__c=qsn1.Id;
        
        
        insert ans1;
        insert ans2;
        insert ans3;
        insert ans4;
       
        QuestionController obj= new QuestionController(); 
        
        obj.counter=1;
        obj.limits=1;
        obj.paperTime=1;
        
        PageReference pageRef = Page.QuestionPage;
        system.Test.setCurrentPage(pageRef);
        
        System.debug('klfd'+obj.qsnLst.size());
        System.assert(obj.qsnLst.size()>0);
        
        System.assert(obj.OptionLst.size()>0);
        System.debug('kl'+obj.OptionLst.size());
        
        obj.StartExam();
        obj.removeToMap();
        System.assert(obj.all_Option_mp.size()>0);
        
        obj.Selected_Check_Options.add(ans1.Id);
        obj.Selected_Check_Options.add(ans3.id);          
        
        obj.addToMap();
        obj.ToGetRadioResult();
        obj.ToGetCheckBoxResult();
        obj.fatchFromMap();
        obj.submitbtn();
        obj.prvbtn();
        obj.nextbtn();
        obj.reviewbtn();        
        obj.close_Submit_btn();
        obj.Submitbtn1();
        obj.Submitbtn2();
        obj.getrev();
        obj.getprv();
        obj.getnxt();
        
        Test.stopTest();
        
    }
}