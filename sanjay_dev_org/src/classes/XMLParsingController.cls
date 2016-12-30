public with sharing class XMLParsingController {
	
	String xmlfile {get; set;}
	public List<String> tst{get; set;}
	public Map<String,List<String>> parseDataMap{get; set;}
		
	public XMLParsingController(){	
		tst = new List<String>();	
		String xmlfile = '<AptiLeads><lead><FirstName>Arunkumar</FirstName><LastName>R</LastName><Email>arun@gmail..com</Email><Phone>7777777777</Phone><ReasonforContact>Associate of Arts in Business</ReasonforContact></lead><lead><FirstName>Balaji</FirstName><LastName>Ram</LastName><Email>ram@gmail.com</Email><Phone>999999991</Phone><ReasonforContact>Associate of Arts in Busines1s</ReasonforContact></lead></AptiLeads>';
		//system.assert(false, xmlString);    
		//tst = testXMLParsing(xmlfile); 
		parseDataMap = new Map<String,List<String>>();
		parseXML(xmlfile);        
	}
	
	
	Public void parseXML(String xmlfile){
	 	
	 	   List<String> FirstNameList = new List<String>();
	 	   List<String> EmailList = new List<String>();
	 	   List<String> PhoneList = new List<String>();
	 	   List<String> ReasonforContactStringList = new List<String>();
	 	   
	 	   
	       DOM.Document xmlDOC = new DOM.Document();
	       xmlDOC.load(xmlfile);
	       DOM.XMLNode rootElement = xmlDOC.getRootElement();
	       System.Debug('$$$$ Root Element'+rootelement);
	       
	       for(DOM.XMLNode xmlNodeObj:xmlDOC.getRootElement().getChildElements()){
	       
	           System.Debug('$$$ Child Elements'+xmlNodeObj);  //system.assert(false, xmlNodeObj);
		       for(DOM.XMLNode xmlNodeObjChild:xmlNodeObj.getChildren()){
		         System.Debug('$$$ Childrens'+xmlNodeObjChild.getChildren());  //system.assert(false, xmlNodeObjChild.getChildren());
	       
	             if(xmlNodeObjChild.getName()=='FirstName'){
	             System.Debug(xmlNodeObjChild.getText()); // system.assert(false, xmlNodeObjChild.getText());
	             FirstNameList.add((string)xmlNodeObjChild.getText());		
	             }		    
	             if(xmlNodeObjChild.getName()=='Email'){
	             System.Debug(xmlNodeObjChild.getText());	
	             EmailList.add(xmlNodeObjChild.getText());
	             }
	             if(xmlNodeObjChild.getName()=='Phone'){
	             System.Debug(xmlNodeObjChild.getText());
	             PhoneList.add(xmlNodeObjChild.getText());
	             }
	             if(xmlNodeObjChild.getName()=='ReasonforContactString'){
	             System.Debug(xmlNodeObjChild.getText());
	             ReasonforContactStringList.add(xmlNodeObjChild.getText());
	             }
	          }
	             
          }
          
          //system.assert(false,FirstNameList);	
          parseDataMap.put('FirstName',FirstNameList);
          parseDataMap.put('Email', EmailList);
          parseDataMap.put('Phone', PhoneList);
          parseDataMap.put('ReasonforContactString', ReasonforContactStringList);	
 	}
	
	
	
	
}