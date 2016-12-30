public with sharing class ProgressBarController   
{
   public String stageValue{get;set;} 
   
   List<Opportunity> lstopp=  new List<Opportunity>();

   public Opportunity OppObject{get;set;}
   
   public ProgressBarController()
   {
   		ID oppId=ApexPages.currentPage().getParameters().get('id');
   		
   		OppObject=[SELECT id, name, Amount, CloseDate ,StageName FROM Opportunity where id =:oppId LIMIT 1 ];
   		
   		System.debug('---id---'+OppObject);  
   		stageValue='';
   		
   		//lstopp = [SELECT Id,StageName FROM Opportunity];
   		Schema.DescribeFieldResult stageVal = Opportunity.StageName.getDescribe();

		List<Schema.PicklistEntry> stageValueList = stageVal.getPicklistValues();
		
		for(Schema.PicklistEntry f : stageValueList)
		{
			stageValue+= f.getLabel()+',';
		}
		
		stageValue= stageValue.substring(0,stageValue.length()-1);
		
   		System.debug('lstopp--->'+stageValue);			
   }
   
   public static String stageVar;
   
   @future
   public static void ProcessOpportunity(Id oppId)
   {
   		Opportunity oppObj=  [Select id,StageName from Opportunity where id=:oppId LIMIT 1];
   		
   		stageVar =oppObj.StageName;
   		
   		System.debug('---stageVar---'+stageVar);
   }
}