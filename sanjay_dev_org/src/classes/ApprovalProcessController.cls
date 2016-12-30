global with sharing class ApprovalProcessController 
{
		 //Constructor Attributes
		
		  //Global Describe to access all objects		
			Map <String, Schema.sObjectType> gd= schema.getGlobalDescribe();		
		    public List<selectoption> AllObjects {get; set;}   // List of all objects to add in pick List 
		    		    
		 //Choose Approval Step Attributes
		    public String selectedObject{get;set;}        // It stores selected Object API Name.
		    public String stepValue{get;set;}             // It has Two possible values 1.FIRST response  2. UNANIMOUS response
		    public Boolean FirstUnanimousFlag{get;set;}  // Boolean Flag Use for rendered in Visualforce Page
		    public boolean DynamicTableFlag{get;set;}  // Boolean Flag Use to Display the Dynamic Steps with Users on page
		    		    
		 //getUserLstMethod Method Attributes   
		    public List<sobject> UserSobjectList{set; get;}  //List of sObjects to store all Users name and mail Ids.		        
		    public Map<String, String> UserValuesMap{get; set;} //Map to store all Users name and mail Ids 	
		    public String approvalMsg{get; set;}		  // String Variable to Store Approval Message.
		    		    
		 //Dynamic Approver List
		 	public String mapDataTXT{get;set;}   // variable used to get JavaScript Map data on page as Text
		  	public List<MetadataService.Approver> DynamicApproversList{get;set;} // List to add Approvers
		    public Map<String, List<MetadataService.Approver>> ApproverListMap{get;set;} // Map to add StepName as Key and List of Approvers as Value		    
		    		    
		    
		 //Constructor
			public ApprovalProcessController()
			{
					System.debug('------ApprovalProcessController');
				//Initialization of Attributes				
					AllObjects= new List<selectoption>();
					selectedObject='';
					stepValue='';
					
					FirstUnanimousFlag=false;
					DynamicTableFlag=false;
					
					UserSobjectList= new List<sobject>();
					UserValuesMap= new Map<String, String>();
					approvalMsg='';
					
					mapDataTXT='';
					DynamicApproversList = new List<MetadataService.Approver>(); 
					ApproverListMap= new Map<String, List<MetadataService.Approver>>();		
						
					
					 //Get only reference to objects
			        for(Schema.SObjectType item : ProcessInstance.TargetObjectId.getDescribe().getReferenceTo())
			        {
			            //Excluding custom setting objects
			            if(!item.getDescribe().CustomSetting)
			            {
			                //Adding to list				                      // Object API 			     // Object Label
			                AllObjects.add(new SelectOption(item.getDescribe().getLocalName().toLowerCase() , item.getDescribe().getLabel()));
			            }
			        }	 
					
					// To Sort the Visible Object List
					AllObjects.sort();			
			}
			
			
		//Method used to Mangae Flags on Rendered the Rest Page.
			public void FirstUnanimousMethod()
			{
				System.debug('------FirstUnanimousMethod');
					if(selectedObject.equals('None'))
					{
						FirstUnanimousFlag=false;
						DynamicTableFlag=false;
					}
					else
					{
						FirstUnanimousFlag=true;			
					}			
			}
			
			
		 //Method Called on FIRST & UNANIMOUS response selection from Radio buttons 
		    public void getUserLstMethod()
		    {
		    	System.debug('------getUserLstMethod');
			    	if(selectedObject.equals('None'))
					{
						DynamicTableFlag=false;
					}
					else
					{
						DynamicTableFlag=true;
					}
					
			    	UserSobjectList = [SELECT NAME,Username from USER];   //sObject List
			    	
			    	for(Integer i=0;i<UserSobjectList.size();i++)
			        {	
			        	// Map to Store Store Name and User Mail Id
			         	UserValuesMap.put((String)(UserSobjectList[i].get(USER.name)),(String)(UserSobjectList[i].get(USER.Username)));		           
			        }
			        //System.debug('----getUserLstMethod---'+UserValuesMap.size());
		        
		    }
			
			
		  //Method Used to convert JavaScript Map to Apex Map & Use ApproverListMap(Map) to Store Approval Step Name & List of Approvers
			public void MapConvertMethod()
			{
				
					Map <String,List<String>> TableMapApex = new Map <String,List<String>>();
												
					System.debug('---actInfoTXT---'+mapDataTXT);							
					
					// Split mapDataTXT(variable) value.
					String[] mapDataTXTArray= mapDataTXT.split(';');
					
					for(Integer i=0;i<mapDataTXTArray.size();i++)
					{
							// Store key and Value of the JavaScript(TableMap) Map					    
						    String[] keyValue=mapDataTXTArray[i].split('#');
						   
						    for(Integer j=0;j<keyValue.size();j++)
						    {
						      
							       if(j==1)
							       {
							       	   // List to Store Email Ids Only
							       	   List<String> EmailIdValue= new List<String>();
							       	   
							           String[] Value=keyValue[j].split(',');
							           
							           for(Integer k=0;k<Value.size();k++)
							           {
							           	    // It get Email Ids From UserValuesMap(Map) 
						               		 if (UserValuesMap.containsKey(Value[k]))
				        					 {
						                		EmailIdValue.add(UserValuesMap.get(Value[k]));							                		
				        					 }
							           }
							           
							           // Map to Store step name and user mail Ids
							           TableMapApex.put(keyValue[0],EmailIdValue);			
							       }      
		    				}   
					}
					
					// Loop to Iterate Map
					for(String key: TableMapApex.keySet())
					{
																		
							List<MetadataService.Approver> ApproverListTemp= new List<MetadataService.Approver>();
													
							List<String> TempList= new List<String>();	
							
							TempList.addAll(TableMapApex.get(key));
							
							 for(Integer i=0;i<TempList.size();i++)
							 {
								 	MetadataService.Approver approver = new MetadataService.Approver();
						    	    approver.name=TempList[i];
						    		approver.type_x='user';
						    		ApproverListTemp.add(approver);						 	
							 }			
							// Map to Store Step name and List of Approvers
							ApproverListMap.put(key,ApproverListTemp);						
					}	
					
			}
		   
		   
		  //Static Method to create Metadata Service.
		    public static MetadataService.MetadataPort createService() 
		    {   				
		    	System.debug('------createService');
				MetadataService.MetadataPort service = new MetadataService.MetadataPort();
				service.SessionHeader = new MetadataService.SessionHeader_element();
				service.SessionHeader.sessionId = UserInfo.getSessionId();
				return service;
			}    	
	  		
	  		
		  //This Method creates Approval Process using Metadata with the steps. (MetadataService 35.0 version)
			public void createApprovalProcess() 
		    {    
		    	//Method Called    
		    	MapConvertMethod();
		    	
		    	System.debug('------createApprovalProcess');
		    	   //code for the create metadata service.
			        MetadataService.MetadataPort service = createService();  
			              
			              
			        /* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ approval Process @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
			        
			        MetadataService.ApprovalProcess approvalProcess = new MetadataService.ApprovalProcess();
			      			
			      			        
			       // Step 1 (Name and Description)
			       	approvalProcess.fullName = selectedObject+'.'+approvalMsg;
			       	String fullNameTemp=approvalProcess.fullName.replace(' ','_');
			       	System.debug('---fullNameTemp---->'+fullNameTemp);
			       	approvalProcess.fullName=fullNameTemp; 
			       	approvalProcess.label = approvalMsg;   
			       	       	
			       	
			        approvalProcess.active = true;  			// To Activate Approval Process Set "True"
			        approvalProcess.allowRecall = false; 
			        approvalProcess.showApprovalHistory = true;
			        approvalProcess.recordEditability = 'AdminOnly';
			        approvalProcess.finalApprovalRecordLock = false; 
			        approvalProcess.finalRejectionRecordLock = false;
			        approvalProcess.showApprovalHistory = false;
			        
			     
			       // Step 2 (Entry Criteria)
			       // code for Entry Criteria       
			       /*
			         	MetadataService.ApprovalEntryCriteria approvalEntryCriteria = new MetadataService.ApprovalEntryCriteria();     
			        
				        //code for FilterItem.
				        MetadataService.FilterItem filterItem= new  MetadataService.FilterItem();
				        filterItem.field='Merchandise__c.name';
				        filterItem.operation = 'notEqual';
				        filterItem.value=null;
			         
				        // assignment of filterItem into approvalEntryCriteria
				        approvalEntryCriteria.criteriaItems = new List< MetadataService.FilterItem> {filterItem};  
			          
				        // assignment of approvalEntryCriteria into approvalProcess.        
				        approvalProcess.entryCriteria = approvalEntryCriteria;
			       */
			       
			       // Step 3 (Approver Field and Record Editability)
			       approvalProcess.recordEditability = 'AdminOnly';			       
			       
			       // Step 4 (Notification Templates)
			       //approvalProcess.emailTemplate ='Marketing: Product Inquiry Response';
			       
			       // Step 5 (Approval Page Layout)
			       // MetadataService.ApprovalPageField PageField = new MetadataService.ApprovalPageField();
			       // PageField.field = new List<String>{'Merchandise__c.name','Merchandise__c.Price__c'};
			       
			       // approvalProcess.approvalPageFields =PageField;
			       
			       // Step 6 (Initial Submitters)       
			       	MetadataService.ApprovalSubmitter submitter = new MetadataService.ApprovalSubmitter();
			        submitter.type_x = 'user';
			        submitter.submitter = UserInfo.getUserName();
			        approvalProcess.allowedSubmitters = new List<MetadataService.ApprovalSubmitter> { submitter };
			       
			        
			        
			        /*#############################--Code for Dynamic Approval STEPS--##################################*/
			        
			        			        
			        List<MetadataService.ApprovalStep> approvalStepList= new List<MetadataService.ApprovalStep>();
			       
			       // Iterate map of step Name and User Mail Ids
			        for(String key:ApproverListMap.keySet())
			        {
			        			        
				            MetadataService.ApprovalStep approvalStep= new MetadataService.ApprovalStep();
				            
				          // Step 1 (Enter Name and Description)
					    	approvalStep.name=key;
					    	approvalStep.label=key; 
				          
				          // Step 2 (Specify Step Criteria)
				    	   /* 
					    	    MetadataService.ApprovalEntryCriteria approvalEntryCriteria1 = new MetadataService.ApprovalEntryCriteria();
					            MetadataService.FilterItem filterItem1= new  MetadataService.FilterItem();
					        	filterItem1.field='Merchandise__c.price__c';
					       		filterItem1.operation = 'greaterThan';
					            filterItem1.value='2000';
					         
					            // assignment of filterItem into approvalEntryCriteria
					        	approvalEntryCriteria1.criteriaItems = new List< MetadataService.FilterItem> {filterItem1};  
					         
					            // assignment of approvalEntryCriteria into approvalProcess.        
					       		approvalStep.entryCriteria = approvalEntryCriteria1;
					        	//approvalStep.ifCriteriaNotMet ='GotoNextStep';
					       */
				          
				          // Step 3 (Select Assigned Approver)  	
				    		MetadataService.ApprovalStepApprover approvalStepApprover= new 	MetadataService.ApprovalStepApprover();
				    	
				    		approvalStepApprover.whenMultipleApprovers =stepValue; 
				    		
				        									 // List of Approvers
				        	approvalStepApprover.approver =  ApproverListMap.get(key);
				        
				        	 System.debug('--------------->approvalStepApprover.approver'+approvalStepApprover.approver);
				        
				            MetadataService.ApprovalStepRejectBehavior rejectBehavior_var = new MetadataService.ApprovalStepRejectBehavior();
			    	        rejectBehavior_var.type_x='RejectRequest';
				            approvalStep.rejectBehavior=rejectBehavior_var;
				        
				        	approvalStep.assignedApprover = approvalStepApprover;
				        	
				        	approvalStepList.add(approvalStep);
			        }
			        
			        // Assigning List of Approval Steps into approval Process.		        
			        approvalProcess.approvalStep = approvalStepList;		        
			        
			        
			        /* @@@@@@@@@@@@@@@@@@@@-- To View Metadata Errors ----@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */
			        List<MetadataService.SaveResult> results = new List<MetadataService.SaveResult>();        
			        results= service.createMetadata( new MetadataService.Metadata[] { approvalProcess });
			      		        
			      		 for (MetadataService.SaveResult r : results)     
				            {  
				                if (r.Success)         
				                {
				                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Approval Process Created on ' + r.FullName));
				                }  
				                else      
				                {
				                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Errors were encountered while creating ' + r.FullName));
				                    for (MetadataService.Error e : r.Errors) 
				                 	{
				                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Error message: ' + e.Message));
				                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'Status code: ' + e.StatusCode));
				                    }
				                }
				            }   
			    }      
}