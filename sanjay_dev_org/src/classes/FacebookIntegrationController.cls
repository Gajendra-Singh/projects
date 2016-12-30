public class FacebookIntegrationController       
{
    //Fetched from URL
    private string client_id='122248638135012'; //APP ID 122248638135012
    private string client_secret='c2ece81bfe02c49faac62666dcb486c0'; //APP SECRET c2ece81bfe02c49faac62666dcb486c0
    private string redirect_uri='https://c.ap2.visual.force.com/apex/FacebookintegrationPage';
    // state can be any Random Number
    private string state='SOME555555';
    //scope is optional but very important while working with full access of facebook
    private string scope='user_about_me';    
        
    private string code;    
      
    public string accessToken{get; set;}               
       
     // map to store values that is accessed from the map
    public Map<string,string> detailmap{get; set;}  
    public List<string> PhotoList{get; set;}
    public string fb_uri{get; set;}  
       
    //constructor
    public FacebookIntegrationController()      
    {             
        PhotoList= new List<string>();
        detailmap= new Map<string,string>();
        fb_uri='';      
        code=ApexPages.currentPage().getParameters().get('code');       
    }
    
    
    public void AccessToken()  
    {  
        //Getting access token from facebook         
        HttpRequest req = new HttpRequest();  
        req.setMethod('POST');
        
        String key = EncodingUtil.urlEncode(client_id,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        String secret=EncodingUtil.urlEncode(client_secret,'UTF-8');
          
        String authuri='';
        authuri='https://graph.facebook.com/oauth/access_token?'+
        'client_id='+key+
        '&redirect_uri='+uri+
        '&client_secret='+secret+
        '&code='+code+
        '&scope='+scope+ 
        '&state='+state;
        req.setEndpoint(authuri);      
                
        Http h = new Http(); 
        //here response stores Access Token and expire time 
        String response;
          
        HttpResponse res = h.send(req);  
        response = res.getBody(); 
         
        // these lines remove expire time from the access token.
       // integer pos=response.indexOf('&expires');        
        //accessToken=response.substring(0, pos);
        
        // these lines remove expire time from the access token.
        string accessToken1 = response.split('&')[0];
        string token = accessToken1.split('=')[1];
        accessToken = token;
       
        // custom setting to store token
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
            update fbData;  
        }      
               
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM,'You have got Access Token Successfully.'));     
     }  
    
    
    public string facebookAuthUri()
    {       
        String key = EncodingUtil.urlEncode(client_id,'UTF-8');
        String uri = EncodingUtil.urlEncode(redirect_uri,'UTF-8');
        
        String authuri='';
        authuri='https://www.facebook.com/dialog/oauth?'+
        'client_id='+key+
        '&redirect_uri='+uri+
        '&scope='+scope+
        '&state='+state;
           
        return authuri; 
    }
    
    
    public PageReference facebookAutentication()  
    {  
        //Authenticating  
        PageReference pg = new PageReference(facebookAuthUri());  
        return pg ;  
    }  
    
    
    public void accessDetails()
    {
        HttpRequest req=new HttpRequest();
        req.setMethod('GET');
        String authuri='';
        authuri='https://graph.facebook.com/me?fields=picture,name,birthday,context,education,email,cover,friendlists,friends,gender&access_token='+accessToken;
        //Graph API= me/friendlists?fields=name
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM,'Hello'+authuri));
        req.setEndpoint(authuri);       
            
        HttpResponse res = null;
        http h= new Http();
        res= h.send(req); 
        
        //it returns the output LIKE haiiiiiiiiiiiiiiiii{"name":"Sanjay Verma","id":"119375578422824"}      
        JSONParser parser = JSON.createParser(res.getBody());
                
        while(parser.nextToken()!=null)
        {
            string key='';
            string value='';
            
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)&& (parser.getText() == 'name')) 
            {
                key=parser.getText();
                parser.nextToken();
                value=parser.getText();
            }
            
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)&& (parser.getText() == 'id')) 
            {
                key=parser.getText();
                parser.nextToken();
                value=parser.getText();
            }
            
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)&& (parser.getText() == 'birthday')) 
            {
                key=parser.getText();
                parser.nextToken();
                value=parser.getText();
            }
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME)&& (parser.getText() == 'email')) 
            {
                key=parser.getText();
                parser.nextToken();
                value=parser.getText();
            }
            if(key!=''&&value!='')  
            {
                detailmap.put(key,value);
            }
            
        }
    }
    
    
    public void accessPhotos()
    {
        HttpRequest req=new HttpRequest();
        req.setMethod('GET');
        String authuri='';
        authuri='https://graph.facebook.com/albumid/photos?fields=id,picture&access_token='+accessToken;  
        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM,'Hello'+authuri));
        req.setEndpoint(authuri);    
          
        HttpResponse res = null;
        http h= new Http();
        res= h.send(req); 
        
        //it returns the output LIKE haiiiiiiiiiiiiiiiii{"name":"Sanjay Verma","id":"119375578422824"}      
        JSONParser parser = JSON.createParser(res.getBody());
                
        while (parser.nextToken() != null) 
        {
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
     }     
    
     public string msg{get;set;}
     
     public void postStatus()  
     {   
        //map<string,string> params = new Map<String, String>{'message' => 'sssssalesmsg'};
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setMethod('POST');
        
        if(msg!=null&&msg!='')
        {
            req.setBody('message='+msg);
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM,'Post has been sent successfully.'));
        }
        else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'please Enter message to send the post'));
        }
   
        req.setEndpoint('https://graph.facebook.com/me/feed?access_token='+accessToken); 
        HttpResponse res;  
        res = new HttpResponse();               
        res = h.send(req);
        string response = res.getBody();
     }       
}