public with sharing class attachmentController 
{	
	
	public String currentRecordId {get;set;}
	public String parameterValue {get;set;}
	public Account acc{get;set;}
	
	
	public attachmentController(ApexPages.StandardController controller)
	{
		currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
		System.debug('currentRecordId--'+currentRecordId);
		acc = [select id ,name, AccountNumber, Type, Industry from Account where id =: currentRecordId ];
		parameterValue = ApexPages.CurrentPage().getparameters().get('nameParam');
		
	}
	
	public Blob fileBody{get;set;}
	public String fileName{get;set;}
	public void attachFile()
	{
		 Attachment myAttachment = new Attachment();
		 System.debug('fileBody---'+fileBody);
		 myAttachment.Body = fileBody;                         //line 1
         myAttachment.Name = fileName;  
         myAttachment.ParentId = currentRecordId;          
         insert myAttachment; 
		 
	}
	

}