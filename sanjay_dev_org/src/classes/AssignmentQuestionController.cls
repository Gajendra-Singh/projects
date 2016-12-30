public with sharing class AssignmentQuestionController 
{		
	
		public String assignId{get; set;}			
		public Map<Survey_Question__c, List<Survey_Choice__c>> qsnChoiceMap {get; set;}
		//public Map<Survey_Question__c, Map<Survey_Choice__c, Survey_Answer__c>> qsnChoiceMap {get; set;}
				
		// Constructor       					
		public AssignmentQuestionController()				                                                        	
		{
				// this is to store assignment Id   
				assignId= ApexPages.currentPage().getParameters().get('id');			
				   
				qsnChoiceMap = new  Map<Survey_Question__c, List<Survey_Choice__c>>();  
				
			    List<Survey_Formate__c> surveyFormatLst = new List<Survey_Formate__c>();
			
			    List<Survey_Question__c> surveyQuestionLst = new List<Survey_Question__c>();
				
				//Query to Access Child to Parent Records
				surveyFormatLst = [Select Survey_Question__r.Id, Survey_Question__r.name from Survey_Formate__c where Survey_Assignment__c=:assignId];
				
				set<String> idSet = new set<String>();
				
				for(Survey_Formate__c  Obj: surveyFormatLst)     
				{
					idSet.add(Obj.Survey_Question__r.Id);  
				}
				
				//Query to Access Parent to Child Records 
				//surveyQuestionLst = [SELECT id, name, Question_Type__c, Controlling_Question__c, Controlling_Rule__c, IsHide__c, IsRequirement__c,  (SELECT Choice_Text__c FROM Survey_Choices__r) FROM Survey_Question__c where id  IN : idSet];
				 surveyQuestionLst = [SELECT id, name, Question_Type__c, Controlling_Question__c, Controlling_Rule__c, IsHide__c, IsRequirement__c,  (SELECT Choice_Text__c FROM Survey_Choices__r), (SELECT Response_Text__c FROM Survey_Answers__r)  FROM Survey_Question__c where id  IN : idSet];
				           
				for(Survey_Question__c Objqsn: surveyQuestionLst)     
				{      
					List<Survey_Choice__c> surveyListTemp = new List<Survey_Choice__c>();		
					//Map<Survey_Choice__c, Survey_Answer__c>	surveyMapTemp = new Map<Survey_Choice__c, Survey_Answer__c>();
					for(Survey_Choice__c ObjChoice : Objqsn.Survey_Choices__r)
					{	
						surveyListTemp.add(ObjChoice);						                                                  
					}     
					
					qsnChoiceMap.put(Objqsn,surveyListTemp);             
				}   						
				 
		} 
			
}