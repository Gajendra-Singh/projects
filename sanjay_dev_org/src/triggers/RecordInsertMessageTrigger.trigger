trigger RecordInsertMessageTrigger on Lead (after insert) 
{
	    for(Lead Obj: Trigger.new)
		{			
			RecordInsertMessageController.ProcessLead(Obj.OwnerId, Obj.Id); 
			
		}  		
}