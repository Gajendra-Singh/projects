public class MessageMaker1
{
    
    public void test()
    {
        
         
     	set<integer> s= new set<integer>();
        s.add(1);
        s.add(2);
        s.add(3);
        s.add(4);
        s.add(5);
        s.add(2);
        
        Iterator<integer> iter=s.iterator();
        while(iter.hasNext())
        {
            System.debug(iter.next());
        }
        
              
    }

}