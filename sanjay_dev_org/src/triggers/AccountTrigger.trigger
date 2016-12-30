trigger AccountTrigger on Account (before insert) 
{
    List<Account> newObjList = new List<Account>(Trigger.new);
    
    Integer newSize=Trigger.new.size();
    
    List<Account> oldObjList = new List<Account>();
        
     oldObjList=[Select Id,Name From Account];
     
     List<Account> NewList = new List<Account>();
     
     for(Integer i=0;i<newSize;i++)
     {
        NewList.add(newObjList.get(i));
     }
     
     for(Integer i=0;i<oldObjList.size();i++)
     {
        NewList.add(oldObjList.get(i));
     }


    update NewList;  
}