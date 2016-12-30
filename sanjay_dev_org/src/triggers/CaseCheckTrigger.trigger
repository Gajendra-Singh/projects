trigger CaseCheckTrigger on CaseCheck__c (before insert) 
{   			
		List<CaseCheck__c> OldObjList = new List<CaseCheck__c>();    
		OldObjList=[Select Id,KeyWord__c From CaseCheck__c];
	
		String StrNewTemp='';
		List<String> StrNewList= new List<String>();	
		for(CaseCheck__c sObjTemp: Trigger.new)
		{
			System.debug('---1st---');
			StrNewTemp=sObjTemp.KeyWord__c;  
			System.debug('---StrNewTemp---'+StrNewTemp);
			
			    if(String.isNotBlank(StrNewTemp)) 
				{
					StrNewList=StrNewTemp.split(',');
				}
				else
				{
					sObjTemp.addError('Null Value is not allowed');			
				}
				
			System.debug('---StrNewList---'+StrNewList.size());
			
		}
		
		if(String.isNotBlank(StrNewTemp)) 
		{			
				List<List<String>> ListOfList= new List<List<String>>();
				for(CaseCheck__c OldListTemp: OldObjList)
				{
					String StrTemp=OldListTemp.KeyWord__c;
					List<String> TempList =new List<String>();
					TempList= StrTemp.split(',');
					ListOfList.add(TempList);	
					System.debug('---2nd---');    
				}	
				  
				for(CaseCheck__c sObjTemp: Trigger.new)
				{	
					for(List<String> innerList: ListOfList)
					{
						System.debug('---innerList---'+innerList);
						for(String oldStr: innerList)
						{
								System.debug('---oldStr---'+oldStr);
							for(String NewStr: StrNewList)
							{
								System.debug('---NewStr---'+NewStr);
								if(NewStr.equalsIgnoreCase(oldStr))
								{
									System.debug(' oldStr.equalsIgnoreCase--'+NewStr);
									sObjTemp.addError('Duplicate Value Found in Record');
								}				
							}			
						}		
					}
				}
		}
		else
		{
			System.debug('---false tested---');
			
		}
}