public with sharing class asyncApexCase 
{
	@future
	public static void ProcessCase(Id caseId)   
	{
		List<Case> CaseList=  [Select id,Description,OwnerId from Case where id=:caseId ];
				
		List<CaseCheck__c> CaseCheckList = new List<CaseCheck__c>();   
		CaseCheckList=[Select Id,KeyWord__c,OwnerId From CaseCheck__c];	
		
		List<Case> CaseListToUpdate= new List<Case>();
	    			
	    Integer LblBreakVar=0;       
	   
		  for(Case CaseObj:CaseList)   	      			    
		   {	
				String DescriptionStr='';
				DescriptionStr=CaseObj.Description;
						
				if(String.isNotBlank(DescriptionStr)) 
				{
						for(CaseCheck__c CaseCheckObj: CaseCheckList)
						{							
								String ChackCaseKeywordStr=CaseCheckObj.KeyWord__c;							
								List<String> ChackCaseKeywordList = new List<String>();
								ChackCaseKeywordList= ChackCaseKeywordStr.split(',');	
								
								for(String RecordValue : ChackCaseKeywordList)
								{
									if(DescriptionStr.containsIgnoreCase(RecordValue))
									{
										CaseObj.OwnerId= CaseCheckObj.OwnerId;
										System.debug('---True(OwnerId)---'+CaseObj.OwnerId);
										CaseListToUpdate.add(CaseObj);
										LblBreakVar=1;
										break;
									}
									else
									{
										LblBreakVar=0;
										System.debug('---False(OwnerId)---'+CaseObj.OwnerId);
										
									}
									
								}
								
								if(LblBreakVar==1)
								{
									break;
								}							
						}
				}  
				else  
				{
					System.debug('---Empty Description String --');   
				}
		   }
		
			if(CaseListToUpdate.size()>0)
			{
				System.debug('000');
				update CaseListToUpdate[0];
			}		  
	}  
}