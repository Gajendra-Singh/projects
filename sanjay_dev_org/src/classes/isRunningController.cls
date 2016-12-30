public class isRunningController{
    
    public isRunningController(){  
    }
        
    Boolean isError = true;
    String str ='';
    
    public void methodTest(){
        if(!Test.isRunningTest()){
          isError = false;
          str='false';
        }
        if(isError){
          // alert the user there is a problem, and do some cleanup
          str='true';       
        }
        
      system.debug('----test---'+str);
    }
}