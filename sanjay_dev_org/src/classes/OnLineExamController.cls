public class OnLineExamController 
{
    //List used to store all papers
    public List<sobject> paper_var{set; get;}
    
    //List to store all paper names to communicate with visual force page from paper_var List 
    public List<selectoption> paper_names{set; get;}
    
    //List used to store all users name and mail 
    public List<sobject> user_var{set; get;}
    
    public Map<String, String> user_var_mp{get; set;}
    
    //List to store all user names to communicate with visual force page from user_var List
    public Map<String, String> Left_Mp{get; set;}
    public Map<String, String> Right_Mp{ get; set;}
    public List<String> Left_Lst{set; get;}
    
    public List<String> Right_Lst{set; get;}
    
    
    // List of all selected mail addresses in toAddresses List via visaul force Page
    public List<String> toAddresses{set; get;}
    
    public String selectedPaper{get; set;}
 	
 	// constractor 
    public OnLineExamController()
    {
    	toAddresses= new List<String>();
    	Left_Lst= new List<String>();
    	Right_Lst=new List<String>();
    	
    	Left_Mp= new Map<String, String>();
    	Right_Mp= new Map<String, String>();
    	
    	user_var_mp=new  Map<String, String>();
    	
        paper_var= [SELECT NAME FROM paper__c];
        
        user_var = [SELECT NAME,EMAIL from USER];
        
        paper_names = new List<selectoption>();
        
        
       
        for(Integer i=0;i<paper_var.size();i++)
        {            
         paper_names.add(new selectoption((string)(paper_var[i].get(paper__c.name)),(string)(paper_var[i].get(paper__c.name))));
        } 
        
        for(Integer i=0;i<user_var.size();i++)
        {
          
            user_var_mp.put((String)(user_var[i].get(USER.name)),(String)(user_var[i].get(USER.email)));
            Left_Mp.put((String)(user_var[i].get(USER.name)),(String)(user_var[i].get(USER.name)));
        }
        
        
    }
    
    
    public void RightShift()
    {
    	for(String item:Left_Lst)
    	{
    		Right_Mp.put(item,item);
    		Left_Mp.remove(item);
    	}
    	
    }
    
    public void LeftShift()
    {
    	for(String item:Right_Lst)
    	{
    		Left_Mp.put(item,item);
    		Right_Mp.remove(item);
    	
    	}
    	
    }
   
    // Methos to send Email to selcted mails(username)
    public void emailSent()
 	{
 		
 		
        for(String key: user_var_mp.keySet())
        {
        	for(String RightKey: Right_Mp.keySet())
        	{
        		if(key.equalsIgnoreCase(RightKey))
        		{
        			toAddresses.add(user_var_mp.get(key));
        			
        		}
        	}
        }
        
        
        try
        {
  		Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();        
        String subject ='OnLine Exam Notification';
        email.setSubject(subject); 
        email.setToAddresses( toAddresses );
        if(selectedPaper.equals('None'))
        {
        	
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.info,'Please choose any Exam Paper.'));
        }
        else
        if(toAddresses.isEmpty()) 
        {
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.info,'Please choose at least one user to send the mail.'));
        }
        else
        {    	
        	email.setPlainTextBody('To Start OnLine Examination of ' +selectedPaper+' Click on this link'+' https://c.ap2.visual.force.com/apex/ExamStartPage?prpname='+selectedPaper);   
        	Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM,'Email Notification has been sent successfully'));
        }
      
        }
        catch(Exception e1)
        {
        	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.info,'Please choose at least one user to send the mail.'));
        }
 	}   
 }