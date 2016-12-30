public with sharing class XMLParser {
	
	public List<List<Map<String,String>>> parseData{get;set;}
	
	public XMLParser(){
		parseData= new List<List<Map<String,String>>>();
		parseData = parse();		
	}
	
    public static List<List<Map<String,String>>> parse() {
        String xml = '<Company><Department><Employee><Name>A1</Name><EmpId>001</EmpId><city>Hyd</city></Employee><Employee><Name>A2</Name><EmpId>002</EmpId><city>Banglore</city></Employee><Employee><Name>A3</Name><EmpId>003</EmpId><city>Chennai</city></Employee></Department></Company>';
        Dom.Document doc = new Dom.Document();
        doc.load(xml);
        List<List<Map<String,String>>> departments = new List<List<Map<String,String>>>();
        for(Dom.XmlNode dept:doc.getRootElement().getChildElements()) {
            List<Map<String,String>> employees = new List<Map<String,String>>();
            for(Dom.XmlNode emp:dept.getChildElements()) {
                Map<String,String> employee = new Map<String,String>();
                for(Dom.XmlNode empProp:emp.getChildElements()) {
                    employee.put(empProp.getName(),empProp.getText());
                }
                employees.add(employee);
            }
            departments.add(employees);
        }
        return departments;
    }
}