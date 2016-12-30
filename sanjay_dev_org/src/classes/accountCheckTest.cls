@isTest 
public class accountCheckTest {
    @isTest
    public static void unit1() {
    
        
        Account acc = new Account(Name='Test1');
        insert acc;   
        system.assert(acc.id!=null);
        
        List<contact> cont = [Select id from contact where AccountId  =: acc.id];
        system.assert(cont.size()==1);

    }
     
     
}