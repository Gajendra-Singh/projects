public class JobScoreController 
{  
	
  // public variable
  public List<wrapperClass> listWrapper{set;get;}
  public List<Job_Detail__c> jobDetailObj{set;get;}
  private List<String> QualificationTempList;
  private List<String> SpokenTempList;
  private List<String> TechnicalTempList;    
  private Integer ExperienceTempParent;  
  private Decimal ScoreParent;
  private Decimal ScoreValue;
					   
  // constructor
  public JobScoreController(ApexPages.StandardController stdController)
  {
  
  	listWrapper =  new List<wrapperClass>();
  	jobDetailObj = new List<Job_Detail__c>();
  	List<Job_Applicants__c> jobApplicentsList = new List<Job_Applicants__c>([SELECT id, name, Experience__c, Qualifications__c, Spoken_Language__c, Technical_Language__c FROM  Job_Applicants__c where  Job_Detail__c =: stdController.getRecord().id ]);
   	  	
  	for(Job_Detail__c detailObj: [SELECT id, name, Experience__c, Qualification__c, Spoken_Language__c, Technical_Language__c FROM Job_Detail__c where id =: stdController.getRecord().id Limit 1])
  	{ 		 
  		 detailObj.Qualification__c = detailObj.Qualification__c.replaceAll(';', ',');
  		 detailObj.Spoken_Language__c = detailObj.Spoken_Language__c.replaceAll(';', ',');
  		 detailObj.Technical_Language__c = detailObj.Technical_Language__c.replaceAll(';', ',');  		 
  			
  		 jobDetailObj.add(detailObj);
  		 
  		 QualificationTempList = detailObj.Qualification__c.split(',');			
  	     SpokenTempList = detailObj.Spoken_Language__c.split(',');
  	     TechnicalTempList = detailObj.Technical_Language__c.split(',');
  		 ExperienceTempParent = Integer.valueof(detailObj.Experience__c);	
  		 								 
  		 decimal divideCounter=0;
  		 decimal divideValue=0;
  		 
  		for(Job_Applicants__c AppObj: jobApplicentsList)
  		{	
  			List<wrapperColorClass> ApplicantQualificationWrapper = new  List<wrapperColorClass>();		
	  		List<wrapperColorClass> ApplicantSpokenWrapper = new  List<wrapperColorClass>();
	  		List<wrapperColorClass> ApplicantTechnicalWrapper = new  List<wrapperColorClass>();			
	  		List<wrapperColorClass> ApplicantExperienceWrapper = new List<wrapperColorClass>();    
  		 
  		    //Logic for Qualification
  		    for(String QualTemp: QualificationTempList)
  		    {
  		    	ApplicantQualificationWrapper.add(new wrapperColorClass(QualTemp,'red'));
  		    } 		    
  		    
	  	    if(AppObj.Qualifications__c!=null)
	  		{
	  			divideCounter=0;
	  			divideValue=0;
	  			
	  			for(String ApplicantQaul_var : AppObj.Qualifications__c.split(';'))  //BA BSC MBA
	  			{
	  				System.debug('----+++-----'+ApplicantQaul_var);
	  				Integer counter = 0;
	  				Boolean match=false;  
	  				for(String qualTemp: QualificationTempList)  //BBA MBA 
	  				{
	  					System.debug('----1-----');
	  					if(qualTemp == ApplicantQaul_var )  //BA==BBA(F) BA==MBA(F)  //BSC==BBA(F) BSC==MBA(F)
	  					{
	  						System.debug('----2-----');
	  						match= true;            				
	  						break;
	  					}
	  					counter ++;  //1 2
	  				}
	  				
	  				if(match)
	  				{	
	  					divideCounter++;	  					
	  					ApplicantQualificationWrapper.set(counter, new wrapperColorClass(ApplicantQaul_var,'green'));	  					
	  				}
	  				else
	  				{
	  					ApplicantQualificationWrapper.add(new wrapperColorClass(ApplicantQaul_var,'orange'));	 //0 -BA  //1 -BSC
	  				}
	  			}
	  		}
	  		
	  		divideValue= divideCounter / QualificationTempList.size();
	  		ScoreValue = divideValue;                          
	  		
	  		//Logic for spoken Language
	  		for(String SpokTemp: SpokenTempList)
  		    {
  		    	ApplicantSpokenWrapper.add(new wrapperColorClass(SpokTemp,'red'));
  		    } 	
  		    
	  		if(AppObj.Spoken_Language__c!=null)
	  		{
	  			divideCounter=0;
	  			divideValue=0;
	  			
	  			for(String SpokenLang_var : AppObj.Spoken_Language__c.split(';'))  //BA BSC MBA
	  			{
	  				System.debug('----+++-----'+SpokenLang_var);
	  				Integer counter = 0;
	  				Boolean match=false;  
	  				for(String SpokenTemp: SpokenTempList)  //BBA MBA 
	  				{
	  					System.debug('----1-----');
	  					if(SpokenTemp == SpokenLang_var )  //BA==BBA(F) BA==MBA(F)  //BSC==BBA(F) BSC==MBA(F)
	  					{
	  						System.debug('----2-----');
	  						match= true;            				
	  						break;
	  					}
	  					counter ++;  //1 2
	  				}
	  				
	  				if(match)
	  				{
	  					divideCounter++;	
	  					ApplicantSpokenWrapper.set(counter, new wrapperColorClass(SpokenLang_var,'green'));
	  				}
	  				else
	  				{
	  					ApplicantSpokenWrapper.add(new wrapperColorClass(SpokenLang_var,'orange'));	 //0 -BA  //1 -BSC
	  				}
	  			}
	  		}
	  		
	  		divideValue= divideCounter / SpokenTempList.size();
	  		ScoreValue+=divideValue;
	  		
	  		//Logic for Technical Language
	  		for(String TechTemp: TechnicalTempList)
  		    {
  		    	ApplicantTechnicalWrapper.add(new wrapperColorClass(TechTemp,'red'));
  		    } 
  		    
	  		if(AppObj.Technical_Language__c!=null)
	  		{
	  			divideCounter=0;
	  			divideValue=0;
	  			
	  			for(String TechnicalLang_var : AppObj.Technical_Language__c.split(';'))  //BA BSC MBA
	  			{
	  				System.debug('----+++-----'+TechnicalLang_var);
	  				Integer counter = 0;
	  				Boolean match=false;  
	  				for(String TechnicalTemp: TechnicalTempList)  //BBA MBA 
	  				{
	  					System.debug('----1-----');
	  					if(TechnicalTemp == TechnicalLang_var )  //BA==BBA(F) BA==MBA(F)  //BSC==BBA(F) BSC==MBA(F)
	  					{
	  						System.debug('----2-----');
	  						match= true;            				
	  						break;
	  					}
	  					counter ++;  //1 2
	  				}
	  				
	  				if(match)
	  				{
	  					divideCounter++;
	  					ApplicantTechnicalWrapper.set(counter, new wrapperColorClass(TechnicalLang_var,'green'));
	  				}
	  				else
	  				{
	  					ApplicantTechnicalWrapper.add(new wrapperColorClass(TechnicalLang_var,'orange'));	 //0 -BA  //1 -BSC
	  				}
	  			}
	  		}
	  		
	  		divideValue= divideCounter / TechnicalTempList.size();
	  		ScoreValue+=divideValue;
	  		
	  		  
	  		//Logic for Experience
	  		if(AppObj.Experience__c!=null)
	  		{
	  			divideCounter=0;
	  			divideValue=0;
	  			
	  			if(ExperienceTempParent >= Integer.valueof(AppObj.Experience__c))
	  			{
	  				ApplicantExperienceWrapper.add( new wrapperColorClass( ''+AppObj.Experience__c, 'green'));
	  				ApplicantExperienceWrapper.add( new wrapperColorClass( ''+(Integer.valueof(AppObj.Experience__c) - ExperienceTempParent), 'red'));
	  				divideValue = AppObj.Experience__c / ExperienceTempParent;
	  				System.debug('1----'+divideValue);
	  				
	  			}
	  			else if(ExperienceTempParent < Integer.valueof(AppObj.Experience__c))
	  			{
	  				ApplicantExperienceWrapper.add( new wrapperColorClass( ''+(AppObj.Experience__c-(AppObj.Experience__c - ExperienceTempParent)), 'green'));
	  				ApplicantExperienceWrapper.add( new wrapperColorClass( '+'+(Integer.valueof(AppObj.Experience__c)- ExperienceTempParent), 'orange'));
	  				divideValue = (AppObj.Experience__c-(AppObj.Experience__c - ExperienceTempParent))/ ExperienceTempParent;
	  				System.debug('2----'+divideValue);  
	  			}		  			
	  		}
	  		
	  		ScoreValue+=divideValue;
	  		
	  		ScoreValue = (ScoreValue/4)*100;
	  		
	  		ScoreValue = ScoreValue.setScale(2);
	  		
	  		 System.debug('-----'+AppObj.Qualifications__c);       		
	  		 WrapperClass Wrapperobj = new WrapperClass(AppObj.name, ApplicantQualificationWrapper, ApplicantSpokenWrapper, ApplicantTechnicalWrapper, ApplicantExperienceWrapper, ScoreValue);
	  		 listWrapper.add(Wrapperobj);
  		} 
  	    
  	    System.debug('-----'+listWrapper);
  	}   
  	    
  }
  
  public class wrapperColorClass
  {	
	    public String Text{get; set;}
	    public String color{get; set;}
	    public wrapperColorClass(String value,String color)
	    {
	        Text = value;
	        this.color = color;
	    }
     
  }
  
  public class wrapperClass
  {		
	   public String WAppName{get; set;}
	   public List<wrapperColorClass> WAppQualification{get; set;}
	   public List<wrapperColorClass> WAppSpokenLanguage{get; set;}
	   public List<wrapperColorClass> WAppTechnicalQual{get; set;}
	   public List<wrapperColorClass> WAppExperience{get; set;}
	   public Decimal WAppScore{get; set;}       
	  	 
  	   public WrapperClass(String ApplicantName, List<wrapperColorClass> ApplicantQualification, List<wrapperColorClass> ApplicantSpoken, List<wrapperColorClass> ApplicantTechnical, List<wrapperColorClass> ApplicantExperience, Decimal ApplicantScore)
  	   {
	  	 	 WAppName=ApplicantName;
	  	 	 WAppQualification= ApplicantQualification;
	  	 	 WAppSpokenLanguage= ApplicantSpoken;
	  	 	 WAppTechnicalQual= ApplicantTechnical;
	  	 	 WAppExperience = ApplicantExperience;  
	  	 	 WAppScore= ApplicantScore;
       }  	 
  }
         
}