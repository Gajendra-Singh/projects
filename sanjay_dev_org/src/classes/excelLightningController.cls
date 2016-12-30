public class excelLightningController{      
               
    @AuraEnabled
    public static List<RecordRowWrapper> getOpportunities(String objName, String subQuery) {
        List<RecordRowWrapper> rows = new List<RecordRowWrapper>();        
        string query =  'SELECT '+ subQuery +' From '+ objName+' Limit 2 ';                 
        List<String> fieldApiArray =  subQuery.split(',');
        List<sObject> RecordList= Database.query(query);    
        for(SObject sobj : RecordList){                            
            RecordRowWrapper row = new RecordRowWrapper();            
            for(String fieldName : fieldApiArray){                        
                fieldName = fieldName.trim();
                system.debug('fieldName ---'+fieldName +'value--'+(string)sobj.get(fieldName));
                row.column.add(new RecordColumnWrapper(fieldName,(string)sobj.get(fieldName)));               
            }    
            rows.add(row);            
        } 
        system.debug('***---->'+rows);
        return rows;  
    } 
    
    @AuraEnabled
    public static String updateSObjectList(List<sObject> recordList){
        try{    
           if(recordList.size()>0){ 
               update recordList; 
           }       
           System.debug('update-->>'+recordList);
           return 'successfully Saved';
        }
        catch(DMLException ex){
          return ex.getMessage();  
        }              
    }
    
    @AuraEnabled
    public static List<excelWrapperClass> getFieldApiMap(String objName, String subQuery) {     
    
        List<excelWrapperClass> wcList = new List<excelWrapperClass>();        
            
        String[] fieldApiList =  subQuery.split(',');
        
        Schema.SObjectType t = Schema.getGlobalDescribe().get(objName); 
        Schema.DescribeSObjectResult r = t.getDescribe();
        
        for(string fieldName : fieldApiList ){
          
          Schema.DescribeFieldResult f = r.fields.getMap().get(fieldName).getDescribe();
            
            if( f.getType()== Schema.DisplayType.String){
              
              // add to wrapper
              
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'String';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
              
            }           
            
             if( f.getType()== Schema.DisplayType.TextArea){
              
              // add to wrapper
              
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'TextArea';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
              
            }         
            
            if( f.getType()== Schema.DisplayType.Picklist){
              
              // add to wrapper
              
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'Picklist';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
              
            }   
            
            if( f.getType()== Schema.DisplayType.Reference){
              
              // add to wrapper
              
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'Reference';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
              
            }   
            
            if( f.getType()== Schema.DisplayType.Phone){
              
              // add to wrapper
              
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'Phone';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
              
            }
            
            if( f.getType()== Schema.DisplayType.Email){
              
              // add to wrapper
              
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'Email';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
              
            }   
            
            if( f.getType()== Schema.DisplayType.URL){
              
              // add to wrapper
              
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'URL';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
              
            }  
            
            if( f.getType()== Schema.DisplayType.Double){
                
               // add to wrapper  
               
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'Double'; 
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
            }
            
            if( f.getType()== Schema.DisplayType.Currency){
                
               // add to wrapper  
               
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'Currency';   
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
            }
            
            if( f.getType()== Schema.DisplayType.Integer){
                
               // add to wrapper
                
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'Integer';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);  
            }
            
            if( f.getType()== Schema.DisplayType.Boolean){
                
               // add to wrapper
               
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'Boolean';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc); 
            }
            
            if( f.getType()== Schema.DisplayType.DateTime){
              
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'DateTime';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
            }            
            
            if( f.getType()== Schema.DisplayType.Date){
              
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'Date';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
            }           
            
            if( f.getType()== Schema.DisplayType.Time){
                
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'Time';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
            }
            
            if( f.getType()== Schema.DisplayType.Combobox){
                 
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'Combobox';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
            } 
            
            if( f.getType()== Schema.DisplayType.MultiPicklist){
               
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'MultiPicklist';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
            } 
            
            if( f.getType()== Schema.DisplayType.EncryptedString){
              
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'EncryptedString';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
            } 
            
            if( f.getType()== Schema.DisplayType.DataCategoryGroupReference){
               
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'DataCategoryGroupReference';
               wc.fieldLabel =f.getLabel(); 
               wcList.add(wc);
            } 
            
            if( f.getType()== Schema.DisplayType.base64 ){
               
               excelWrapperClass wc = new excelWrapperClass();
               wc.fieldApiName= fieldName;
               wc.fieldType= 'base64';  
               wc.fieldLabel =f.getLabel();  
               wcList.add(wc); 
            }   
        }// For Loop Close    
      
        return wcList;
    } 
      
   
}