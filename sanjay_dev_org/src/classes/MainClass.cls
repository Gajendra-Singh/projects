public class MainClass {
   
    public Map<String, Schema.SObjectType> pick = Schema.getGlobalDescribe();
    public String val {set;get;}
    public Schema.DescribeSObjectResult dor;
    public List<String> lto {get;set;}// name of the field
    public sObject sobj  {set;get;}
    
    public  MainClass()
    {
      lto=new List<String>();  
    }
    
    public List<SelectOption> getitem()
    {
      
       List<SelectOption> option=new List<SelectOption>();
       
       for(Schema.SObjectType str:pick.values())
       {
           
           option.add(new SelectOption(str.getdescribe().getname(),str.getdescribe().getlabel()));
           option.sort();
       }
       
       return option; 
    } 
   
    public void  fieldmap()
    { 
     lto.clear();
         system.debug('++++++++++++++'+val);
         Integer c=0;
         Map <String, Schema.SObjectField> fieldMap = 
         pick.get(val).getDescribe().fields.getMap();
         sobj=pick.get(val).newSObject();
         for(Schema.SObjectField sfield : fieldMap.Values())
         {
           Schema.DescribeFieldResult dfr=
           sfield.getDescribe();
           if(dfr.isCreateable())
           { 
           lto.add(dfr.getname());  
           }
          
        
         } 
          system.debug('+++++++++++++++++++ '+ sobj); 
         
    }
    
 /*publc void searching()
 {
 
 }*/

}