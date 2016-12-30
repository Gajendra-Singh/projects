trigger InsertToDailyRate on Week_Rate__c (after insert, after update) 
{
  
   if(Trigger.old!=null)
   { 
        System.debug('E1'+Trigger.old);
        List< DailyRate__c> toUpdate = new List< DailyRate__c>();        
        List< DailyRate__c> toDel = new List< DailyRate__c>();
        List<DailyRate__c> obj_Lst1 = new  List<DailyRate__c>();
        for(Week_Rate__c WRc: Trigger.old)
        {
          
          if( WRc.weekDate__c==null)
          {
              System.debug('ioioioio');
              
              for(Week_Rate__c WRc1: Trigger.new)
              {      
                    for(Integer i=0;i<=6;i++)
                    {      
                        obj_Lst1.add(new DailyRate__c (Week_Rate__c=WRc1.id,Daily_Date__c=WRc1.weekDate__c.addDays(i)));
                                
                    }    
             }    
           
            insert obj_Lst1;   
          
          }
          else
          {
                
             Week_Rate__c id_var= Trigger.oldMap.get(WRc.id); 
             
             String temp= id_var.id;        
             
             toUpdate= [Select id,Daily_Date__c from DailyRate__c WHERE Week_Rate__c= : temp];
           }
                  
        } 
        
        for(Week_Rate__c WRc: Trigger.new)
        {        
            if(WRc.weekDate__c==null)
            {     
             
              system.debug('Entetr');
              String temp=WRc.id;
              toDel= [Select id from DailyRate__c WHERE Week_Rate__c= : temp];
              
              
            }
            else
            {        
                for(Integer i=0;i<toUpdate.size();i++)
                {
                     toUpdate[i].Daily_Date__c= WRc.weekDate__c.addDays(i);
                }
            }
        }
      
        
        if(toUpdate.size()>0)
        {System.debug('22');
        update toUpdate;
        }
          if(toDel.size()>0)
        {
        System.debug('11');
        delete toDel;
        }
        
     }
     else
     {          
          System.debug('E2');
          List<DailyRate__c> obj_Lst = new  List<DailyRate__c>();
          
            for(Week_Rate__c WRc: Trigger.new)
            {      
                for(Integer i=0;i<=6;i++)
                {      
                    obj_Lst.add(new DailyRate__c (Week_Rate__c=WRc.id,Daily_Date__c=WRc.weekDate__c.addDays(i)));
                            
                }    
            }    
           
            insert obj_Lst;   
      }
      
 }