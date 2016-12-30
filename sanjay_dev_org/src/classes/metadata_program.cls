public class metadata_program {
  /* // public class CreateFieldUsingMetadataAPIController {
 
 public BLOB contentFile{get; set;}
 public String nameFile{get; set;} 
 
 // method for read the csv file and create the custom fields 
 public void createNewField(){
    
  nameFile = contentFile.toString();
  String[] fileLines = nameFile.split('\n');
  
  String objectName,fieldName,fieldType;
     
  for(integer i=1; i<fileLines.size(); i++){
   
   String[] inputValues = fileLines[i].split(',');
    
   objectName = inputValues[0].trim();
   fieldName = inputValues[1].trim();
   fieldType = inputValues[2].trim();
   
   try{    
    MetadataService.MetadataPort service =  createService();
    
    MetadataService.CustomField field = new MetadataService.CustomField();
    
    field.fullName = objectName+'__c.'+fieldName.replace(' ','_')+'__c';
    field.label = fieldName;
    field.type_x = fieldType;       
    
    FieldPermissions permissions = new FieldPermissions();
    permissions.PermissionsEdit = true;
    permissions.PermissionsRead = true;
    permissions.Field = field.fullName;
  
    if(fieldType.equals('Currency') || fieldType.equals('Number') || fieldType.equals('Percent')){
     field.precision = 18;
     field.scale = 2;
    }
    else if(fieldType.equals('Text')){
     field.length = 50;
    }
    else if(fieldType.equals('Checkbox')){
     field.defaultValue = 'false';
    }
    else if(fieldType.equals('AutoNumber')){
     field.displayFormat = 'AN-{0000}';
     field.startingNumber = 1;     
    }
    else if(fieldType.equals('RichTextArea')){
     field.type_x = 'Html';
     field.length = 32768;
     field.visibleLines = 10;     
    }
    else if(fieldType.equals('LongTextArea')){
     field.length = 32768;
     field.visibleLines = 10;
    }
    else if(fieldType.equals('Geolocation')){
     field.type_x = 'Location';
     field.scale = 2;   
     field.required = false;  
    } 
    else if(fieldType.equals('EncryptedText')){
     field.length = 50;
     field.maskChar = 'asterisk';
     field.maskType = 'all';
    }
    else if(fieldType.equals('Formula')){
     field.type_x = 'Date';
     field.formula = 'Today()';
    }
    else if(fieldType.equals('Picklist') || fieldType.equals('MultiselectPicklist')){
     
     MetadataService.Picklist picklist = new MetadataService.Picklist();
     picklist.sorted = false;
     picklist.picklistValues = new List<MetadataService.PicklistValue>();
     
     // set the picklist values
     for(integer j=4;j<inputValues.size(); j++){
      
      MetadataService.PicklistValue pv = new MetadataService.PicklistValue();
      pv.fullName = inputValues[j].trim();
      pv.default_x = false;
      
      picklist.picklistValues.add(pv);      
     }
     field.picklist = picklist;  
     
     // add visible lines if type is multiselectpicklist
     if(fieldType.equals('MultiselectPicklist')){
      field.visibleLines = 4;
     }   
    }
    else if(fieldType.equals('MasterDetail')){
     String master = inputValues[3].trim();

        field.externalId = false;
        field.referenceTo = master+'__c';
        field.relationshipLabel = master;
        field.relationshipName = master;
        field.relationshipOrder = 0;
        field.type_x = 'MasterDetail';
        field.writeRequiresMasterRead = false;    
    }
    else if(fieldType.equals('Lookup')){
     String master = inputValues[3].trim();
 
     field.type_x = fieldType;
     field.referenceTo = master+'__c';
     field.relationshipLabel = master;
     field.relationshipName = master;     
    }
    else if(fieldType.equals('RollupSummary')){
     field.summarizedField = 'TestMetaDataAPI__c.'+fieldName.replace(' ','_')+'__c';
    }
       
    List<MetadataService.SaveResult> results = service.createMetadata(new MetadataService.Metadata[] {field} 

);
    
    for(MetadataService.SaveResult r : results){
     if(r.success){
      Apexpages.Message msg = new ApexPages.Message(Apexpages.Severity.Confirm,r.fullName+' has been created successfully');
      Apexpages.addMessage(msg);
     }
    }
 
   }
   catch(Exception e){
    System.debug('Exception****'+e);
   }
   
  }
 }
 
 public static MetadataService.MetadataPort createService() {   
  
  MetadataService.MetadataPort service = new MetadataService.MetadataPort();
  service.SessionHeader = new MetadataService.SessionHeader_element();
  service.SessionHeader.sessionId = UserInfo.getSessionId();
  return service;
 }*/
}