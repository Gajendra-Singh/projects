trigger OpportunityTrigger on Opportunity (after insert) 
{
	for(Opportunity oppObj: Trigger.new)
		{			
			ProgressBarController.ProcessOpportunity(oppObj.Id); 
			
		} 
	
}