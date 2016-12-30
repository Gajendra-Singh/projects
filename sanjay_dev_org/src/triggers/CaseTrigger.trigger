trigger CaseTrigger on Case (after insert)      
{  				
		for(Case CaseObj: Trigger.new)
		{		
			//Future Method Calling	  
			asyncApexCase.ProcessCase(CaseObj.Id); 
			
		}
}