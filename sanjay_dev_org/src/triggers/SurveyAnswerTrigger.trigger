trigger SurveyAnswerTrigger on Survey_Answer__c (before insert , before update) 			
{
	Set<Id> questionIds = new Set<Id>();
	Set<Id> saIds = new Set<Id>();
	for(Survey_Answer__c ansObj: Trigger.new)
	{
		questionIds.add(ansObj.Survey_Question__c);	
		if(ansObj.Survey_Assignment__c != null)  
		{	
			saIds.add(ansObj.Survey_Assignment__c);					
		}						
	}
	
	System.debug('questionIds--'+questionIds+'saIds----'+saIds);							
	Map<Id,Survey_Question__c> mapQuestion;
	if(questionIds.size() > 0 && saIds.size() > 0)
	{
		//This map stores 
		mapQuestion= new Map<Id,Survey_Question__c>([select Id,isRequirement__c,Controlling_Question__c,Controlling_Rule__c from Survey_Question__c where id in :questionIds]);
		System.debug('---mapQuestion-----'+mapQuestion);
		
			if(mapQuestion != null)
			{				
					Set<Id> controllingIds = new Set<Id>();
					for(Survey_Question__c ques : mapQuestion.values())
					{
						if(ques.Controlling_Question__c != null && ques.Controlling_Rule__c != null)
						{
							System.debug('controling QSN-----'+ques);
							controllingIds.add(ques.Controlling_Question__c);
						}
						else
						{
							System.debug('Not Controlling QSN-----'+ques);
							for(Survey_Answer__c ansObj: Trigger.new)
							{
								if(ansObj.Survey_Question__c ==  ques.id)
								{
									
				 					System.debug('---ques---'+ques);
				 					System.debug('-----1-------'+ques.isRequirement__c);
				 					System.debug('-----2-------'+ansObj.Response_Text__c);
				 					
									if(ques.isRequirement__c && (ansObj.Response_Text__c == null || ansObj.Response_Text__c.trim() == ''))
									{
										system.debug('Required answer---'+ques);
										ansObj.addError('Required answer');
									}									
								}													
							}							
						}
					}
				
					if(controllingIds.size() > 0)
					{
						Map<Id,String> mapControllingAns = new Map<Id,String>();
						for(Survey_Question__c ques : [select Id, (select Id,Response_Text__c from Survey_Answers__r where Response_Text__c != null And Survey_Assignment__c in :saIds) from Survey_Question__c where id in :controllingIds])
						{  
							System.debug('---------ques--------'+ques);
							String respText = '';
							System.debug('--ques.Survey_Answers__r------'+ques.Survey_Answers__r);
							
							if(ques.Survey_Answers__r.size() > 0)
							{
								for(Survey_Answer__c answer : ques.Survey_Answers__r)
								{
									respText = answer.Response_Text__c;  
								}
								System.debug('---ques.Id--'+ques.Id);		
								System.debug('---ans--'+respText);
								mapControllingAns.put(ques.Id,respText);																		
						   }
						}
						
						     
						if(mapControllingAns != null)
						{
							for(Survey_Question__c qsnObj: [select Id, Controlling_Rule__c,Controlling_Question__c From Survey_Question__c where Controlling_Question__c in: mapControllingAns.keyset()])
							{
								System.debug('my Qsn---'+qsnObj);
								
								for(Id Key: mapControllingAns.keyset())
								{		
									if(qsnObj.Controlling_Question__c == Key)
									{
										String respText = mapControllingAns.get(Key);
									
										if(qsnObj.Controlling_Rule__c.containsIgnoreCase(respText+'=optional'))
										{
											System.debug('-111111');
										}
										if(qsnObj.Controlling_Rule__c.containsIgnoreCase(respText+'=required'))
									    {
									    	System.debug('-22222----');
									    	for(Survey_Answer__c ansObj: Trigger.new)
											{
												if(ansObj.Survey_Question__c ==  qsnObj.id)
												{
													if(ansObj.Response_Text__c == null || ansObj.Response_Text__c.trim() == '')
													{	
														System.debug('-22222--0000--');		
													 	ansObj.addError('Required answer');
													} 
												}
											}
									    	
									    }   
									}
								}
								
								
								
							}
						}
						
						
										
				    }
				    
				    
				    
			}
	    }	
		
		
		
		
				
}