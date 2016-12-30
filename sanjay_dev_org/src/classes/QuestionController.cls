public class QuestionController 
{
        public List<question__c> qsnLst {get; set;} 
        public List<question__c> qsnLst_size {get; set;}         
        
        public List<answer__c> OptionLst {get; set;}        
        public List<selectoption> OptionLst_select {get; set;}
        public Map<Id, String> all_Option_mp {get;set;}
                      
        // This map contains question id and question number
        public Map<Id, String> Mark_Lst {get; set;}
        public boolean Mark_Option {get; set;} 
        
        public Map<id, Integer> Marked_Page_Counter {get; set;}           
    
        // This map is used to store each option id with option name
        public Map<Id, String> check_mp; 
        public Map<Id, String> Radio_mp;
        
        public Map<Id, String> check_mp_temp; 
        public Map<Id, String> Radio_mp_temp;
        
        public List<String> Selected_Check_Options {get; set;}
        public String Selected_Radio_Option {get; set;}   
        
    	// This map is used to store the result with marks.
        public Map<Id, Decimal> ResultMp {get; set;}    
        public Double  ScoreMarks{get; set;}
        public Double ScorePer{get; set;}
        
        public integer counter = 0; 
        public integer recNum = 0; 
        public integer limits = 1;  
        
        public Decimal paperTime{get; set;}    
        
    	public String papername{get; set;}
    
    	public Decimal totaltime{get; set;}
     
    	//Constructor
        public QuestionController()
        {
        	qsnLst = new List<question__c> ();
            qsnLst_size = new List<question__c> ();
            
            OptionLst =new List<answer__c>();           
            OptionLst_select= new List<selectoption>(); 
            
            all_Option_mp= new Map<Id, String>();
           
            Selected_Check_Options= new List<String>();
                  
            check_mp= new Map<Id, String>();                         
            Radio_mp= new Map<Id, String>();
            
            check_mp_temp= new Map<Id, String>();
            Radio_mp_temp= new Map<Id, String>();
            
            Mark_Lst= new Map<Id, String>();
            Mark_Option=false;
            
            Marked_Page_Counter=new Map<id, Integer>();
            
            ResultMp = new Map<Id, Decimal>();
            
            ScoreMarks=0;
        	ScorePer=0;
            totaltime=600;          
            
            Result();
            searchresult();        
        }
        
     	// This Method is used to get all sObjects and size.
        public void Result()
        {
            qsnLst_size = [SELECT Name, Id FROM question__c ];
            recNum = qsnLst_size.size();
            PaperTime=Math.floor(System.currentTimeMillis()/1000)+totalTime;
        }        
    
        // This function is used to display question with all options 
        public void searchresult()
        { 
            OptionLst_select.clear();
            
            String qsn_Id;
            
            qsnLst= [SELECT Name, Id,Question__c, Multiple__c,Point__c,AnsNo__c, Correct_Answer__c FROM question__c LIMIT 1 OFFSET: counter];              
        
            qsn_Id=(String)(qsnLst[0].Id);                
            
            OptionLst =[SELECT Name,Questionno__c FROM Answer__c where Questionno__c =: qsn_Id  ];            
            
            for(integer i=0;i<OptionLst.size();i++)
            {
                OptionLst_select.add(new Selectoption((String)OptionLst[i].id,(String)OptionLst[i].get('Name')));
                all_Option_mp.put(OptionLst[i].id,(String)OptionLst[i].get('Name'));
            }  
            
        }     
        
    	// This function is used for the start page
         public PageReference StartExam()
	 	 {
	 		PageReference pageRef = page.questionPage;
	 		papername=system.currentpagereference().getparameters().get('prpname');
	        pageRef.setredirect(false); 
	        return pageRef;
	 		
	 	 }   
	 	 
    	 // This method is used to remove all the selected options 
         public void removeToMap() 
         {
            for(integer i=0; i<OptionLst.size(); i++)
            {
                String opn_id = OptionLst[i].id;
            
                if(check_mp.containsKey(opn_id))
                {
                    check_mp.remove(opn_id);
                    check_mp_temp.remove(opn_id);
                    
                }                   
                
                if(Radio_mp.containsKey(opn_id))
                {
                    Radio_mp.remove(opn_id);
                    Radio_mp_temp.remove(opn_id);
                   
                }
            }
            
            if(Mark_Lst.containsKey(qsnLst[0].Id))  
            {
            	Mark_Lst.remove(qsnLst[0].Id);
            } 
            
         }
         
         // This method is used to add Selected options to the map at Next ans Previous.
         public void addToMap()
         {
            for(String checktemp: Selected_Check_Options)
            {
                check_mp.put(checktemp,all_Option_mp.get(checktemp));
                check_mp_temp.put(checktemp,all_Option_mp.get(checktemp));
            }            
            
            if(Selected_Radio_Option!=null)
            {
                Radio_mp.put(Selected_Radio_Option,all_Option_mp.get(Selected_Radio_Option));
                Radio_mp_temp.put(Selected_Radio_Option,all_Option_mp.get(Selected_Radio_Option)); 
            }
            
            if(Mark_Option!=false)
            {
            	Mark_Lst.put(qsnLst[0].Id,qsnLst[0].Name);
            	Mark_Option=false;
            }
                       
         }
         
    	 // This method is used to store checked question with thier User answer into map(For Radio)
         public void ToGetRadioResult()
         {
         	 for(String id: Radio_mp_temp.keyset())
                {
                   String str1=Radio_mp_temp.get(id);
                   String str2=qsnLst[0].Correct_Answer__c;
                   
                   if(str1.equals(str2))
                   {
                   	 ResultMp.put(qsnLst[0].id,qsnLst[0].Point__c);
                   	
                   }
                   else
                   {
                   	 ResultMp.remove(qsnLst[0].id);
                   	 
                   }
                
                }                
               Radio_mp_temp.clear(); 
         }
         
         // This method is used to store checked question with thier User answer into map(For Check Box) 
         public void ToGetCheckBoxResult()
         {
         	boolean flag=false;         	
         	
         	// StrTokens stores all correct answer array List from Question Table
         	String  str1=qsnLst[0].Correct_Answer__c;
         	String[] StrTokens=str1.split(',');         	
         	
         	Integer sizemp=check_mp_temp.size();
         	Integer sizearr=StrTokens.size();
         	
         	if(sizemp==sizearr)
         	{
         		
         		  for(String id:check_mp_temp.keySet())
         		  {
         		  	 String str2=check_mp_temp.get(id);
         		  	
         		  		for(Integer i=0;i<sizearr;i++)
         		  		{
         		  			
         		  			if(str2.equalsignorecase(StrTokens[i]))
         		  			{
         		  				flag=true;
         		  				break;
         		  			}
         		  			else
         		  			{
         		  				flag=false;
         		  				
         		  			}
         		  		}
         		  		
         		  		if(flag==false)
         		  		{
         		  			break;
         		  			
         		  		}         		  	
         		  }
         		
         		  if(flag==true)
         		  {
         		  		ResultMp.put(qsnLst[0].id,qsnLst[0].Point__c);
                   	 
         		  }
         		  else
         		  { 	
         		  		ResultMp.remove(qsnLst[0].id);
                   	       		  	
         		  }
         	 }
         	 
         	 check_mp_temp.clear();
         	
           }
         
    	 // This Method is used to fatch the stored options from the map (For Radio and Check Box Both)
         public void fatchFromMap()
         {
         
            for(integer i=0; i<OptionLst.size(); i++ )
            {            
                String opt_id = OptionLst[i].id;
            
                for(String id : check_mp.keyset())
                {
                    if(id.equals(opt_id))
                    {
                        Selected_Check_Options.add(opt_id);
                    }
                }
                                
                for(String id: Radio_mp.keyset())
                {
                	
                    if(id.equals(opt_id))
                    {
                         Selected_Radio_Option=opt_id;
                    }
                }
            }
            
            for(String mrktemp: Mark_Lst.keySet())
      		{
      			if(mrktemp.equals(qsnLst[0].Id))
      			{
      				Mark_Option=true;
      			}
      		}       
         }
         
         // Functions call on submit button 
         public PageReference submitbtn()
         {
         	PageReference pageRef = page.SubmitConfirmation;
         	pageRef.setredirect(false);          	
         	removeToMap();
            addToMap(); 
            ToGetRadioResult();
		    ToGetCheckBoxResult();
            fatchFromMap();         
            for(Id ss: ResultMp.KeySet())
            {
            	ScoreMarks=ScoreMarks+ResultMp.get(ss);
            }
           	ScorePer=(ScoreMarks/30)*100;
    		return pageRef; 
         }          
        
    	// Functions call on Previous Button 
        public void prvbtn()
        {    	      	
            counter -= limits; 
            removeToMap();
            addToMap(); 
            ToGetRadioResult();
		    ToGetCheckBoxResult();
            Marked_Page_Counter.put(qsnLst[0].Id,counter);                    
            searchresult();
            fatchFromMap();
        }
        
    	// Functions call on Next Button
        public void nextbtn() 
        {  
        	if(Selected_Radio_Option== null)
        	{
        		ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.info,'Warning!  Please choose your Answer.'));
        	}       	
        	else
        	{   	counter += limits;  
		            removeToMap(); 
		            addToMap();
		            ToGetRadioResult();
		            ToGetCheckBoxResult();
		            Marked_Page_Counter.put(qsnLst[0].Id,counter);
		            searchresult();
		            fatchFromMap();        		
        	}
        }
        
        // Review Button code
        public PageReference reviewbtn()
        {        	
        		nextbtn();       	
	        	PageReference pageRef = page.Review_OnLine;        	
	        	if(Mark_Option==false)
	        	{
	        		Mark_Lst.remove(qsnLst[0].Id);
	        	}
	        	pageRef.setredirect(false);         	
	        	return pageRef;        	 	
        }        
        
        public PageReference getquestionId()
        {
        	String quesid_var= ApexPages.currentPage().getParameters().get('mrk_qsn');
        	
        	Integer temp_counter= integer.valueOf(quesid_var); 
        	
        	this.counter=temp_counter-1;
        	
        	searchresult(); 
        	fatchFromMap();
        	PageReference pageRef = page.QuestionPage;
        	pageRef.setredirect(false);        	
        	return pageRef;
        } 
        
        //Cancel Button Code
        public PageReference close_Submit_btn()
        {
        	PageReference pageRef = page.QuestionPage;
        	pageRef.setredirect(false);
        	return pageRef;
        	
        }
        
        public PageReference Submitbtn1()
        {
        	PageReference pageRef = page.SubmitConfirmation;
        	pageRef.setredirect(false);
        	return pageRef;
        	
        }
        
         // Final Submit button for calculate percentage and total marks.
         public PageReference Submitbtn2()
         {
         	PageReference pageRef = page.ResultPage;
         	pageRef.setredirect(false);
         	removeToMap(); 
            addToMap(); 
            ToGetRadioResult();
		    ToGetCheckBoxResult();
            fatchFromMap();
         	for(Id ss: ResultMp.KeySet())
            {
            	ScoreMarks=ScoreMarks+ResultMp.get(ss);
            }
       			ScorePer=(ScoreMarks/30)*100;
   				return pageRef;
         }          
        // Review Disable Code
        public boolean getrev()
        {
       	   if(Mark_Lst.isEmpty())
       	  		return true;
           else
         		return false;       	  		
        }
        // Previous Disable Code
        public boolean getprv()  
        { 
            if(counter == 0)
                return true;
            else
                return false; 
        }
        // Next Disable Code
        public boolean getnxt()
        {
            if((counter + limits+1) > recNum)
                return true;
            else
                return false;
        }
}