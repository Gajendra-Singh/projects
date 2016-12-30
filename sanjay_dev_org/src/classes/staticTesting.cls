public class staticTesting {

    public string tem1;
    public static Integer tem2{get; set;}

        public staticTesting()
        {
                 
        	tem1='Non Static Data Member';
        	tem2=50;        
        }
        
        public void  test()
        {        	   
           //tem2 =60; 	
            system.debug(tem2);
        }             

}