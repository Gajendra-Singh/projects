public with sharing class RecordInsertMessageController 
{    
	  
	  @future(callout=true)   
	   public static void ProcessLead(Id Ownerid,String LeadId)
	   {			   	
			   	 try
			   	 {
			   			System.debug('--Ownerid--'+Ownerid);
			   			String mobileNumber='';
					    String textMessage='https://ap2.salesforce.com/'+LeadId;
					    
					    final String VERSION = '3.2.0';
					    String endpoint = 'https://api.twilio.com';
					    final String DEFAULT_VERSION = '2010-04-01';
					    String accountSid;
					    String authToken;
					    String phoneNumber; 
			      
					    User UserObj=[SELECT MobilePhone FROM User where id =: Ownerid LIMIT 1];   
					    mobileNumber=UserObj.MobilePhone;
					    
					    mobileNumber=mobileNumber.replaceAll(' ', '');
					    System.debug('mobileNumber--'+mobileNumber);
				       
				        if(mobileNumber !='')
						{
								
								//Referencing custom setting data       
						        Twilio_Configuration__c config = Twilio_Configuration__c.getInstance();
						        accountSid = config.accountSID__c;
						        authToken = config.authToken__c;
						        phoneNumber = config.fromPhoneNumber__c; 
						        
						        //variable to hold the response
				        		String responseBody = '';
						        
						        //Endpoint URL
						        String path = endpoint + '/' + DEFAULT_VERSION + '/Accounts/' + accountSid + '/SMS/Messages.json';
						        System.debug('path--'+path);
						        URL uri = new URL(path);
						        System.debug('Uri---'+uri);
						        String entity = '';
						        
						        //Check for mobile number and text message
						        if(mobileNumber != Null && textMessage != '') 
						        {
						        	System.debug('tm--'+textMessage+'mo'+mobileNumber);
						            entity += (entity=='' ? '' : '&')+ 'To' + '=' + EncodingUtil.urlEncode(string.valueOf(mobileNumber), 'UTF-8');
						            entity += (entity=='' ? '' : '&')+ 'Body' + '=' + EncodingUtil.urlEncode(textMessage, 'UTF-8');
						            entity += (entity=='' ? '' : '&')+ 'From' + '=' + EncodingUtil.urlEncode(phoneNumber, 'UTF-8');
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
						        request.setHeader('Authorization', 'Basic '+EncodingUtil.base64Encode(Blob.valueOf(accountSid + ':' + authToken)));
						        request.setEndpoint(uri.toExternalForm());
						        request.setMethod('POST');
						        request.setBody(entity);
						        
						        System.debug(request+'+++');
						        if(!Test.isRunningTest()) 			
						        {           
						        	 System.debug(request+'+++--');   
						            //Send request
						            HttpResponse res = h.send(request);
						            responseBody = res.getBody();
						            System.debug('responseBody:::::::::::' +responseBody);     
						        } 
						        else 
						        { 
						        	 System.debug(request+'++responseBody+--');  
						            responseBody =  '{"sid":"SMba4ab2fafa3d709004359818f50a67eb","date_created":"Thu, 12 Dec 2013 15:13:06 +0000","date_updated":"Thu, 12 Dec 2013 15:13:06 +0000","date_sent":null,"account_sid":"ACfdd0fcec687020b86d09fa8451c4b614","to":"+919820242561","from":"+13047132065","body":"Hello there!","status":"queued","direction":"outbound-api","api_version":"2010-04-01","price":-0.01,"price_unit":"USD","uri":"/2010-04-01/Accounts/ACfdd0fcec687020b86d09fa8451c4b614/SMS/Messages/SMba4ab2fafa3d709004359818f50a67eb.json","num_segments":"1"}';
						            
						        } 
						        
						} 
			   	 }
			   	 catch(Exception e)
			   	 {
			   	 	System.debug('Excepitonnnnnn'+e);
			   	 }
	   	       	
        }   

}