public with sharing class FBIntegrationController 
{
    public string client_id{get;set;}
    public string client_secret = 'c2ece81bfe02c49faac62666dcb486c0';
    public string redirect_uri = 'https://c.ap2.visual.force.com/apex/FBIntegration';
    public string accessToken{get;set;}
    public String bodyEncoded{get;set;}
    public blob fileblob{get;set;}
    public blob photo1{get;set;}
    public Map<String, Object> m {get;set;}
    public List<String> PhotoList {get;set;}
    public FBIntegrationController()
    {
        m = new Map<String, Object>();
        PhotoList = new List<String>();
        client_id = '122248638135012';
        accessToken = '';
        bodyEncoded='';  
    }
    
    public Pagereference authenticateFB()  
    {   
        
        return new PageReference('https://graph.facebook.com/oauth/authorize?client_id='+client_id+'&scope=publish_actions,user_photos&redirect_uri='+redirect_uri);
    }
    
      
    public void accessTokenFB()
    {
        string code = Apexpages.currentPage().getParameters().get('code');
        string endPointUri = 'https://graph.facebook.com/oauth/access_token?client_id='+client_id+'&redirect_uri='+redirect_uri+
                        '&client_secret='+client_secret+'&scope=publish_actions&code='+code;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPointUri);
        req.setMethod('GET');
        req.setTimeout(60*1000);
        
        Http h = new Http();   
        HttpResponse res = h.send(req);
        
        string response = res.getBody();

       string accessToken1 = response.split('&')[0];
       string token = accessToken1.split('=')[1];
       accessToken = token;
         
           system.debug('888'+accessToken);       
        Facebook_Integration__c fbData = Facebook_Integration__c.getOrgDefaults();  
        if(fbData == null)
        {
            fbData.name = 'FBToken';
            fbData.FacebookToken__c = token;
            insert fbData;
        } 
        else
        {
            fbData.FacebookToken__c = token;
            insert fbData;
        }      
        
    }    
    
    public void postStatus()
    {
        map<string,string> params = new Map<String, String>{'message' => 'hiiiiiiiiiiiii'};
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        if (params != null) {
            req.setBody(postBodyStringFromMap(params));
        } 
   
        req.setEndpoint('https://graph.facebook.com/me/feed?access_token='+accessToken+'&scope=publish_actions');
        
        HttpResponse res;  
        res = new HttpResponse();
        res = h.send(req);
        string response = res.getBody();
        
    }
    
    public String postBodyStringFromMap(Map<String,String> params)
    {
        String returned = '';
        for (String key : params.keySet()) {
            if (returned != '') {
                returned += '&';
            }
            returned += key+'='+EncodingUtil.urlEncode(params.get(key), 'UTF-8');  
        }    
        return returned;     
    }
    
    public void retreivePhotos()    
    {
        m = new Map<String, Object>();
        PhotoList = new List<String>() ;
        string code = Apexpages.currentPage().getParameters().get('code');
        string endPointUri = 'https://graph.facebook.com/albumid/photos?fields=id,picture&access_token='+accessToken;
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPointUri); 
        req.setMethod('GET');
        req.setTimeout(60*1000);    
          
        Http h = new Http(); 
        HttpResponse res = h.send(req);
        //system.debug('***********'+res);
        string response = res.getBody();
        
        JSONParser parser = JSON.createParser(res.getBody());
        
       while (parser.nextToken() != null) {
		 if ((parser.getCurrentToken() == JSONToken.FIELD_NAME))
		 {
		  	String fieldName = parser.getText();
		   	if(parser.getText()== 'picture')
		   	{
		    	parser.nextToken();
		    	PhotoList.add(parser.getText());
		   }
		  }
		 }
		system.debug('@@@@@@@@@@@@PhotoList@@@@@@@@5'+PhotoList);
         
    }
}