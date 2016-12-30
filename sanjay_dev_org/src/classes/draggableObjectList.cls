public with sharing class draggableObjectList 
{				
	
		//Global Describe to access all objects 
	    Map<String, Schema.SObjectType> gd= Schema.getGlobalDescribe(); 
	    //All Api Names   
	    Set<String> objectkeys= gd.keySet();  
	    
	    //draggableObjectList(constructor) Attributes.
	    //This Map is used to store All API(key) and Label(value) of Objects
	    public Map<String, String> allObjectsMap{get; Set;}	   
	    public String ObjApiName{get;set;}    
	    public String FieldApiName{get;set;}	    
	    
	    //Pagination Attributes
	    private integer counter=0;
	    private integer limit_var=10;  
	    //recNum is for total Records.
	    public integer recNum {get; set;}
	    public integer currRecNum{get; set;}
	    public integer PrvRecNum{get; set;}
	    private integer totalPage=0;    
    
	  	//Constructor.
	    public draggableObjectList()
	    {
	    		
		    	allObjectsMap= new Map<String, String>();
		    	APILabelMap= new Map<String, String>();
		    	currRecNum = 0;
		    	totalPage=0;
		    	RecordFlag= false;
		    	PrvRecNum=1;
		    	RecordLst= new List<sObject>();	
		    	recNumRecordLst= new List<sObject>();		
		    	    	
		    	M= new Map<String, Schema.SObjectField>();	    	
		    	idObjListMap= new Map<String,List<object>>();		    
		    	fieldLableAPI = new  Map<String, String>();
		    	objectFields= new List<String>();
		    	// Loop to add the API_Name and Label of the Objects.
		        //Get only reference to objects
		        for(Schema.SObjectType item : ProcessInstance.TargetObjectId.getDescribe().getReferenceTo())
		        {
		        	//Excluding custom setting objects
		            if(!item.getDescribe().CustomSetting)
		            {		                             
		                allObjectsMap.put(item.getDescribe().getLocalName().toLowerCase(),item.getDescribe().getLabel());		              
		            }
		        }
	    }
	    
	    
	    
	    //Field Select List
	    public Map<String, String> fieldLableAPI {get; set;}    
	    public boolean RecordFlag{get;set;}   
	    // Map to get the fields using Object API
   		private Map<String, Schema.SObjectField> M;   		
	    
	     //Get fields of selected object
	    public void ObjectFields()
	    {
		    	counter=0;
		    	limit_var=10;
		    	RecordFlag= false;
		    	M.clear();	    	
		    	idObjListMap.clear();
		    	fieldLableAPI.clear();   
	    	
	    	     
	        try
	        { 
	        	    //Creating sObject for dynamic selected object
		            Schema.SObjectType systemObjectType = gd.get(ObjApiName);
		            //Fetching field results
		            Schema.DescribeSObjectResult r = systemObjectType.getDescribe();
		                
		            M = r.fields.getMap();		            
		            Set<String> temp= M.keySet();
		            //Creating picklist of fields
		            for(String t: temp)
		            {
		            		Schema.DescribeFieldResult fieldresult=M.get(t).getDescribe();
			                if(fieldresult.isCreateable() && fieldresult.isFilterable())
			                {
			                    fieldLableAPI.put(fieldresult.getName(),fieldresult.getLabel());
			                }		            	    
		            }
		            
	        }
	        catch(Exception e)
	        {	        	
	        	ApexPages.Message msg1 = new ApexPages.Message(ApexPages.severity.INFO , 'Response= ');
	        	ApexPages.addMessage(msg1);
	        }        
	        
	        System.debug('-----'+fieldLableAPI);
	    }       
        
        public List<String> objectFields{get;set;}
	    public List<sObject> RecordLst{get;set;}
	    public Map<String,List<object>> idObjListMap {get; set;}  
	    public Map<String, String> APILabelMap{get; set;} 
	    
	    public List<sObject> recNumRecordLst{get;set;}  
	    //Get Records of the selected field
	    public void FieldRecords()		
	    {
	    	RecordLst.clear();
	    	RecordFlag= true;
	    	idObjListMap.clear();
	    	APILabelMap.clear();
	    	objectFields.clear();
	    	 //public List<String> RecordValueList = new List<String>();
	    	System.debug('--FieldApiName---'+FieldApiName);
	    	if(String.isNotBlank(FieldApiName))
	    	{
		    	 
		    	String soql='select '+ FieldApiName+' From '+ObjApiName+' LIMIT :limit_var OFFSET :counter';		
		    	System.debug('----'+soql);
		    	
		    	//To Get the total Record Size   	
		    	String RecordLstSoql='select '+ FieldApiName+' From '+ObjApiName;
		    	//List<sObject> recNumRecordLst= new List<sObject>();	    	
		    	try
		    	{  
		    		RecordLst= Database.query(soql);	  
		    		currRecNum=RecordLst.size()+counter;
		    		//To Get the total Record Size		
		    		recNumRecordLst= Database.query(RecordLstSoql); 				
		    		recNum=recNumRecordLst.size(); 
		    		PrvRecNum= currRecNum+1-RecordLst.size(); 
		    		//totalPage=recNum/10;
		    		System.debug('--recNum-+nextFlag--'+recNum);
		    	}
		    	catch(Exception e)
		    	{
		    		System.debug('Exception e'+e);
		    	}  
		    	
		    	String[] FieldApiNameArray= FieldApiName.split(',');	    	
		    	
		    	for(String APINameTemp :FieldApiNameArray)
		    	{
		    		objectFields.add(APINameTemp);	
		    		System.debug('--'+APINameTemp);
		    		List<object> lst = new List<object>();
		    		for(sObject sObj: RecordLst)
		    		{    			
		    			lst.add((object)sObj.get(APINameTemp));    
		    			
		    		}
		    		System.debug('--listSize'+lst.size());
		    		
		    		Schema.DescribeFieldResult fieldresult=M.get(APINameTemp).getDescribe();
		    		
		    		idObjListMap.put(fieldresult.getLabel(),lst);
		    		
		    		APILabelMap.put(fieldresult.getLabel(),APINameTemp);
		    	}
	    	}
	    	else
	    	{
	    		RecordFlag= false;
	    		System.debug('--FieldApiName--newwww-'+FieldApiName);
	    	}
	    	
	    }
	    
	    
	    
	    
	  
	     @RemoteAction //remote action annotation 
   		 public static List<sObject> getList(String sObjVal, String fieldVal)   
   		 {
   		 		
   		 	  		 	   		 		
   		 		//System.debug('mystring'+MyString);
	   			//System.debug('sObjVal1 --'+sObjVal1);
			   	// create the filter text
			   //	String filter = ' like \'%' + String.escapeSingleQuotes(MyString) + '%\'';	 
			   	// dynamic soql query  	
			   	String soql='SELECT '+fieldVal+' From '+sObjVal ;
			   	System.debug('soql--'+soql);
			   	// String soql='SELECT Name From Merchandise__c '+ 'Where name '+filter ;		   	   	 
			  	List<sObject> L = new List<sObject>();
		        try 
		        {
		            L = Database.query(soql);
		           		            
		        }
		        catch (QueryException e) 
		        {		
		            System.debug('e--'+e) ; 
		        }       
		        System.debug('--00--'+L.size()); 
		       
		         
	    	   return L;    
   		 
   		 }
    
   
	    public void nextbtn()  
	    {
	    	counter += limit_var;
	    	System.debug('------counter----'+counter);
	    	FieldRecords();
	    }
	    
	 	public void prvbtn()  											
		{               
		    counter -= limit_var; 
		    FieldRecords();
		}
		
		public void Firstbtn()
		{
			counter = 0;
			FieldRecords();
		}  
	     
	    public void Lastbtn()
	    {
	    	counter=recNum-math.mod(recNum,limit_var);
	    	FieldRecords();
	    }
	     // Previous Disable Code
	    public boolean getprv()  
	    { 
	        if(counter == 0)
	            return true;
	        else
	            return false; 
	    }
	    // Next Disable Code  
	   public boolean getnxt()
	    {
	        if((counter + limit_var+1) > recNum)
	            return true;
	        else
	            return false;
	    }
    
}