public class Typeahead_autocomplete 
{
	  
     // Global Describe to access all objects
    Map<String, Schema.SObjectType> gd= Schema.getGlobalDescribe();    
    Set<String> objectkeys= gd.keySet();   // Api Names 
    public List<String> lst {get; set;}  
    public String objValue{get;set;}
    
     public List<selectoption> allfields{get; set;}
   

	public Typeahead_autocomplete() 
	{
		allfields= new List<selectoption>();
		// Initialization
        lst=new List<String>();
        //lst.addAll(objectkeys);
        fieldmap= new Map<String, Schema.SObjectField> ();
        SelectedFields= new List<String>();
        
         //Get only reference to objects
        for(Schema.SObjectType item : ProcessInstance.TargetObjectId.getDescribe().getReferenceTo())
        {
            //Excluding custom setting objects
            if(!item.getDescribe().CustomSetting)
            {
                //Adding to list
                lst.add( item.getDescribe().getLabel() );
            }
        }	
    }  	
	
	public sObject SelectedObject {get; set;}
	
	
   
   
   //Selected fields to be displayed in table
     // To Store all fields as a Map
    Map<String, Schema.SObjectField> fieldmap;  	
    public List<String> SelectedFields {get; set;} // we can select multiple fields at a time.    
    public List<String> filledfields {get; set;}  
    
   
     
	
	public void selectedValueAF()
	{		
		System.debug('###############'+objValue);
		String selectedValue = ApexPages.currentPage().getParameters().get('selectedValue');
		selectedValue= selectedValue.trim();
		selectedValue= selectedValue.replace(' ','_');  
		System.debug('selectedValue'+selectedValue);
		
		
       
        	             
          try{           	
          			if(gd.containsKey(selectedValue))
          			{
          				fieldmap = gd.get(selectedValue).getDescribe().fields.getMap();
          				SelectedObject= gd.get(selectedValue).newSObject();
          			}
          			else
          			{
          				System.debug('Enterere');
          				string selectedValue1= selectedValue+'__c';
          				System.debug('Enterere'+selectedValue1);
            	   		fieldmap = gd.get(selectedValue1).getDescribe().fields.getMap();
            	   		system.debug('fk'+fieldmap);
            	   		SelectedObject= gd.get(selectedValue1).newSObject();
          			}
          	
                    
                    Set<String> temp= fieldmap.keySet();
         
            
            for(String t: temp)
            {	
                
                Schema.DescribeFieldResult fieldresult=fieldmap.get(t).getDescribe();
                if(fieldresult.isCreateable()&&fieldresult.isFilterable())
                {
                    SelectedFields.add(fieldresult.getName());
                    system.debug('t'+SelectedFields);
                }
            }
          }
          catch(Exception e)
          {
          	 ApexPages.addMessages(e); 
          	 System.debug('exp +' +e);
          	 
          } 
          
          for(string ss: SelectedFields)
          {
          	allfields.add(new selectoption(ss, ss));
          	system.debug('opopo'+ss);  			
          }
          
          system.debug('sss'+allfields.size());           	 
	}	
}