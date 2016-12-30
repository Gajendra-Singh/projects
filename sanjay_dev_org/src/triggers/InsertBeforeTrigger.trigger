trigger InsertBeforeTrigger on TriggerObject__c (before Insert) 
{	
	List<TriggerObject__c> newObjList = new List<TriggerObject__c>(Trigger.new);
	List<TriggerObject__c> RevObjList = new List<TriggerObject__c>();
		
    List<TriggerObject__c> OldObjList = new List<TriggerObject__c>();
    
	OldObjList=[Select Id,Number__c From TriggerObject__c ORDER BY Number__c];
			
	Integer newSize=Trigger.new.size();
	
	for(Integer i=newObjList.size()-1; i>=0; i--)
	{	
		RevObjList.add(newObjList.get(i));		
	}
	
	for(Integer i=0; i<RevObjList.size();i++)
	{		
		RevObjList.get(i).Number__c= i+1;
	}	 
	 	
	for(Integer i=0; i<OldObjList.size();i++)
	{	
		OldObjList.get(i).Number__c= newSize+1+i;	
	}
	  
	update OldObjList;  
	
}