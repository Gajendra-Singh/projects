public class objectController
{ 
  
     // Global Describe to access all objects
    Map<String, Schema.SObjectType> gd= Schema.getGlobalDescribe();    
    Set<String> objectkeys= gd.keySet();   // Api Names
    
    
    // List to add all objects to pick list 
    public List<selectoption> allobjects {get; set;} 
        
    
	// Selected Object ** we can select one object at a time
    public sObject SelectedObject {get; set;}
    public String selectedobjstr {set;get;}
      
    
    // To Store all fields as a Map
    Map<String, Schema.SObjectField> fieldmap;   
    
	
	//Selected fields to be displayed in table	
    public List<String> SelectedFields {get; set;} // we can select multiple fields at a time.    
    public List<String> filledfields {get; set;}  
    
    		
    // To Store SObject returned by Database.query
    public List<Sobject> ObjectList {get; set;} 
    

    // To Store Object Type Value Written on Visual force Page by  User
    public List<object> objvalue {get; set;}
    
    
    
    // Constructor 
    public objectController()  
    {
        // Initialization
        allobjects= new List<selectoption>(); 
        selectedobjstr='';
         
        SelectedFields = new List<string>() ;
        
        ObjectList = new List<sObject>();
        
        filledfields= new List<String>();
        
        objvalue= new List<object>();
        
        // Loop to add the API_Name and Label of the Objects.
        for(String key: objectKeys )
        {
           allobjects.add(new selectoption(gd.get(key).getDescribe().getName(),gd.get(key).getDescribe().getLabel()));
        }
        
        allobjects.sort();
    } 
    
    
    
    // code for Retrive the fields of selected object.
    public void objectfields()   
    {
        SelectedFields.clear();
        filledfields.clear();
        objvalue.clear();
       objectList.clear();
        
        try
        {
       
        	SelectedObject= gd.get(selectedobjstr).newSObject();                
            
            fieldmap = gd.get(selectedobjstr).getDescribe().fields.getMap();
            
            Set<String> temp= fieldmap.keySet();  
            
            for(String t: temp)
            {                
                Schema.DescribeFieldResult fieldresult=fieldmap.get(t).getDescribe();
                if(fieldresult.isCreateable()&&fieldresult.isFilterable())
                {
                    SelectedFields.add(fieldresult.getName());
                }
            }
        }
        catch(NullPointerException e)
        {
            // Information will be Displayed as Message when we select '--None--' as List Item
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Please Select an tem in the List'));
        }
    
    }
    
    public void getFields()
    {  
        try
        {
        String temp2='';
        filledfields.clear();
        objvalue.clear();
        objectList.clear();
            
        for(String str: SelectedFields) // all API of fields 
        {
            object values= Selectedobject.get(str);
            System.debug('++++'+values);
            
            if(values!=null)
            {
                filledfields.add(fieldmap.get(str).getDescribe().getName());               
            
                
                // filter record according to the data type..
                Schema.DisplayType fieldDataType= fieldMap.get(str).getDescribe().getType();
                
                if(fieldDataType == schema.DisplayType.STRING)
                {
                	temp2 +=  str+ ' LIKE '+' \''+ values + '%\' ' + ' AND ';
                }
                else
                if(fieldDataType == schema.DisplayType.DOUBLE)
                {
                    temp2 +=  str+ ' = '+ values + ' AND ';
                }
                else
                if(fieldDataType == schema.DisplayType.CURRENCY)
                {
                    temp2 +=  str+ ' = '+ values + ' AND ';
                }
                else
                if(fieldDataType == schema.DisplayType.BOOLEAN)
                {
                    temp2 +=  str+ ' = '+ values + ' AND ';
                }
                else
                if(fieldDataType == schema.DisplayType.DATE)
                {
                    temp2 +=  str+ ' = '+ String.valueOf(values).removeEnd('00:00:00') + ' AND ';
                }
                else
                {
                    temp2 +=  str+ ' = '+' \''+ values + '\' ' + ' AND ';
                }
                
                
                	objvalue.add(values);
               
            }
           
        }
            for(object vv:objvalue)
            {
                System.debug('vv'+vv);
            }
        
        temp2= temp2.substring(0,temp2.length()-4);
        temp2=temp2+' ';
        
        string query;
        
        string temp='';
       
        for(string str: filledfields ) //filledfields  selectedfields
        {
            temp=temp+str+', ';
        }
        
        temp=temp.substring(0, temp.length() - 2);
        temp=temp+' ';              
       
        query='SELECT '+temp+' FROM '+selectedobjstr+ ' WHERE '+ temp2;        
        
        System.debug(query);       
     
        ObjectList= Database.query(query);
            
            if(ObjectList.isEmpty())
            {
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'No Record Found '));
            }
       
        for(sObject obj : objectList)
        {
            System.debug(obj);
        }
        }
        catch(StringException e1)
        {
         	
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.INFO,'Please fill at least one field'));
            
        }
        catch(QueryException e2)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'No Record Found'));
        }
        
    }
    
    public PageReference export()
        
    {
        PageReference pr= page.CSVFile;
        pr.setRedirect(false);       
        return pr;
    }          
    
}