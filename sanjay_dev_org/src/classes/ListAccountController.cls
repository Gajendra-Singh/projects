public class ListAccountController{
    
    // public variable
    public List<WrapperClass> listWrapper{set;get;}
    
    // constructor
    public ListAccountController(){
    
        listWrapper = new List<WrapperClass>();
        for(Account acc : [select Id,Name,Type,OwnerId from Account]){
        
            WrapperClass obj = new WrapperClass();
            obj.acc = acc;
            
            listWrapper.add(obj);
        }
    }

    public void checkedAccount(){
    
        for(WrapperClass wrObj : listWrapper){
            if(wrObj.isCheck == true){
                system.debug('##### = '+wrObj.acc.Name);
            }
        }
    }
    
    
    // wrapper class
    public class WrapperClass{
        public Account acc{set;get;}
        public Boolean isCheck{set;get;}
        
        public WrapperClass(){
            acc = new Account();
            isCheck = false;
        }
    }
}