public with sharing class TwilioIntegrationPOC 
{

    //Mobile Number
    public String mobileNumber { get; set; }          
          
    //Text message
    public String textMessage { get; set; }
    
    // Validation Code  
    public String validationMobile {get; set;}
    public String validationCode {get; set;}
    
    //Required parameters
    private static final String VERSION = '3.2.0';
    private String endpoint = 'https://api.twilio.com';
    public static final String DEFAULT_VERSION = '2010-04-01';
    private String accountSid;
    private String authToken;
    public String phoneNumber;     
   
    // constructor			
    public TwilioIntegrationPOC() 
    {    
        //Initiallizing
        mobileNumber = '';
        textMessage = '';
        validationMobile='';
               
        //Referencing custom setting data       
        Twilio_Configuration__c config = Twilio_Configuration__c.getInstance();
        accountSid = config.accountSID__c;
        authToken = config.authToken__c;
        phoneNumber = config.fromPhoneNumber__c;    
    }
    
    //Method to send Message on Mobile Number
    public void sendTextMessage() 
    {        
        //variable ot hold the response
        String responseBody = '';
        
        //Endpoint URL
        String path = endpoint + '/' + DEFAULT_VERSION + '/Accounts/' + this.accountSid + '/SMS/Messages.json';
        System.debug('path--'+path);
        URL uri = new URL(path);
        System.debug('Uri---'+uri);
        String entity = '';
        
        //Check for mobile number and text message
        if(mobileNumber != Null && textMessage != '') 
        {
            entity += (entity=='' ? '' : '&')+ 'To' + '=' + EncodingUtil.urlEncode(string.valueOf(mobileNumber), 'UTF-8');
            entity += (entity=='' ? '' : '&')+ 'Body' + '=' + EncodingUtil.urlEncode(textMessage, 'UTF-8');
            entity += (entity=='' ? '' : '&')+ 'From' + '=' + EncodingUtil.urlEncode(phoneNumber, 'UTF-8');
        } 
        else 
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Mobile Number and Text Message are required.');       
            ApexPages.addMessage(myMsg); 
            return;
        }
        System.debug('entity---'+entity);		
        //Initiallize http request
        Http h = new Http();
        HttpRequest request = new HttpRequest();
        
        //Append parameters to the request
        request.setHeader('X-Twilio-Client', 'salesforce-' + VERSION);
        request.setHeader('User-Agent', 'twilio-salesforce/' + VERSION);
        request.setHeader('Accept', 'application/json');
        request.setHeader('Accept-Charset', 'utf-8');
        request.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(this.accountSid + ':' + this.authToken)));
        request.setEndpoint(uri.toExternalForm());
        request.setMethod('POST');
        request.setBody(entity);
        
        
    	System.debug(request+'+++');
        //Check for text is running 
        if(!Test.isRunningTest()) 
        {              
            //Send request
            HttpResponse res = h.send(request);
            responseBody = res.getBody();
            System.debug('responseBody:::::::::::' +responseBody);     
        }
        else 
        { 
            responseBody =  '{"sid":"SMba4ab2fafa3d709004359818f50a67eb","date_created":"Thu, 12 Dec 2013 15:13:06 +0000","date_updated":"Thu, 12 Dec 2013 15:13:06 +0000","date_sent":null,"account_sid":"ACfdd0fcec687020b86d09fa8451c4b614","to":"+919820242561","from":"+13047132065","body":"Hello there!","status":"queued","direction":"outbound-api","api_version":"2010-04-01","price":-0.01,"price_unit":"USD","uri":"/2010-04-01/Accounts/ACfdd0fcec687020b86d09fa8451c4b614/SMS/Messages/SMba4ab2fafa3d709004359818f50a67eb.json","num_segments":"1"}';
            
        }
        
        if(responseBody.contains('queued'))   
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Message successfully sent..!!');       
            ApexPages.addMessage(myMsg);  
        } 
        else if(responseBody.contains('400'))
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Phone number is not valid OR Registered');       
            ApexPages.addMessage(myMsg); 
        }     
    }    
    
    //Method to make call on Mobile Number
    public void sendVoiceMessage() 
    {        
        //variable ot hold the response
        String responseBody = '';
        
        //Endpoint URL
        String path = endpoint + '/' + DEFAULT_VERSION + '/Accounts/' + this.accountSid + '/Calls';
        System.debug('path--'+path);
        URL uri = new URL(path);
        System.debug('Uri---'+uri);
        String entity = '';
        
        //Check for mobile number 
        if(mobileNumber !='') 		
        {
        	System.debug('Enter in If---'+mobileNumber);		
            entity += (entity=='' ? '' : '&')+ 'To' + '=' + EncodingUtil.urlEncode(string.valueOf(mobileNumber), 'UTF-8');
            entity += (entity=='' ? '' : '&')+ 'From' + '=' + EncodingUtil.urlEncode('+919799512340', 'UTF-8');
            entity += (entity=='' ? '' : '&')+ 'Url' + '=' + EncodingUtil.urlEncode('http://foo.com/call.xml', 'UTF-8');
            
            System.debug('entity---'+entity);		
	        //Initiallize http request
	        Http h = new Http();
	        HttpRequest request = new HttpRequest();
	        
	        //Append parameters to the request
	        request.setHeader('X-Twilio-Client', 'salesforce-' + VERSION);
	        request.setHeader('User-Agent', 'twilio-salesforce/' + VERSION);
	        request.setHeader('Accept', 'application/json');
	        request.setHeader('Accept-Charset', 'utf-8');
	        request.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(this.accountSid + ':' + this.authToken)));
	        request.setEndpoint(uri.toExternalForm());
	        request.setMethod('POST');
	        request.setBody(entity);
	            
            HttpResponse res = h.send(request);
            responseBody = res.getBody();
            System.debug('responseBody:::::::::::' +responseBody);  
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Calling..!!');       
            ApexPages.addMessage(myMsg);               
	      
	    
	    } 
        else                                         
        {
        	System.debug('Else----');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Mobile Number are required to call anyone.');       
            ApexPages.addMessage(myMsg); 
            return;
        }
        
    }
    
    // Method to make validate Mobile Number			
    public void validateMobile()
    {
    	//variable ot hold the response
        String responseBody = '';
        
        //Endpoint URL
        String path = endpoint + '/' + DEFAULT_VERSION + '/Accounts/' + this.accountSid + '/OutgoingCallerIds.json';
        System.debug('path--'+path);
        URL uri = new URL(path);
        System.debug('Uri---'+uri);
        String entity = '';
        
        //Error Message
        String ErrorMsg='';
        String validation_code='';
        
        //Check for mobile number 
        if(validationMobile !='') 		
        {
        	System.debug('Enter in validationMobile---'+validationMobile);
        	entity += (entity=='' ? '' : '&')+ 'PhoneNumber' + '=' + EncodingUtil.urlEncode(string.valueOf(validationMobile), 'UTF-8');
            System.debug('entity-validateMobile--'+entity);	
            	
            //Initiallize http request
	        Http h = new Http();
	        HttpRequest request = new HttpRequest();
	        
            //Append parameters to the request
	        request.setHeader('X-Twilio-Client', 'salesforce-' + VERSION);
	        request.setHeader('User-Agent', 'twilio-salesforce/' + VERSION);
	        request.setHeader('Accept', 'application/json');
	        request.setHeader('Accept-Charset', 'utf-8');
	        request.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(this.accountSid + ':' + this.authToken)));
	        request.setEndpoint(uri.toExternalForm());
	        request.setMethod('POST');
	        request.setBody(entity);
	            
            HttpResponse res = h.send(request);
            responseBody = res.getBody();
            System.debug('responseBody:::::::::::' +responseBody); 
            
            // Parse JSON response to get all the fields values.
            JSONParser parser = JSON.createParser(responseBody); 
            while(parser.nextToken()!=null)
            {
            	if(parser.getCurrentToken() == JSONToken.FIELD_NAME) 
            	{     
            		if(parser.getText()== 'message')   
            		{    		
	            		System.debug('+++----'+parser.nextToken());
	            		ErrorMsg=parser.getText();
	            		System.debug('parser--'+ErrorMsg);
	            		ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,ErrorMsg);
	            		ApexPages.addMessage(myMsg);  
	            		break;
            		}
            		if(parser.getText()== 'validation_code')
            		{
            			parser.nextToken();
            			validation_code=Parser.getText();
            			ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.CONFIRM,'Enter Validation code '+validation_code +' in Your Mobile');
            			ApexPages.addMessage(myMsg);  
            			System.debug('validation_code--'+validation_code);
            		}
            	}        	  
            } 
        	
        }			
        else 
        {
        	System.debug('Else----');
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Enter Mobile for the validation');       
            ApexPages.addMessage(myMsg); 
            return;
        }
    	
    }  
    
    
}