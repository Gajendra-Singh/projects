public with sharing class AssignmentController 			
{                                                                                        
	
		public List<Survey_Assignment__c> surveyAssignmentList{get;set;}
		
																									
		public AssignmentController()
		{
			surveyAssignmentList= [Select id, name from Survey_Assignment__c];  
			
		}
}