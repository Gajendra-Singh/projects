public class accountList
{
    public Account count{set;get;}
    public String selectedAccountId{get;set;}
    public List<Account> accountList1{get;set;}
    public String alphabet{get;set;}
    public Integer counter = 0;      
    public List<SelectOption> options1{get;set;}
    public String accept{get;set;}
    public Integer nofromPage{set;get;}
    public integer totalRecs {get;set;}
    private integer LimitSize = 10;
    public integer numberonpage = 0;
    public Integer temporary{get;set;}                    						// Hold the quentity of particular alphabet
    public integer pageNumberFormBoxInteger{get;set;}
    public List<wrapperClassForCheckBox> wrapperClassForCheckBoxList{get;set;}  // list of Wrapper Class Type
  	public Set<String> idForCheckBox{get;set;}   								// super set for containing Id's of selected check boxes
  	public Integer numberOfSelectedXCheckBoxes{get;set;}
  	public List<Account> contain{get;set;}
  	
  	//Constructor                                        
    public accountList()    
    { 
    	contain = new List<Account>();
    	numberOfSelectedXCheckBoxes = 0;
    	idForCheckBox =new Set<String>();
    	wrapperClassForCheckBoxList = new List<wrapperClassForCheckBox>();
        pageNumberFormBoxInteger = 1;         
        nofromPage = 10; 
        accountList1 = new List<Account>();
        listDetail1();
        getcountRecords(); 
        check();
             
    }    
    
    // calculates the Details of An Account 
    public void listDetail1()     
    {
        String qust='select id,name,BillingState ,fax,type,phone,site,OwnerId from account ';
        if(alphabet != 'All' && alphabet != null && alphabet != '')
        {
            String temp = alphabet + '%';
            qust += ' where name like :temp ';
            getcountRecords();
        }        
        qust +=' ORDER BY Name ASC limit :nofromPage OFFSET :counter'; 
        accountList1 = database.query(qust);           
    }
    
    public void check()
	{      
	    	wrapperClassForCheckBoxList  = new List<wrapperClassForCheckBox>();
	    		    	
	    	for(Account a : accountList1) 
	    	{
				wrapperClassForCheckBoxList.add(new wrapperClassForCheckBox(a));
	    	}
	    	for(wrapperClassForCheckBox  Obj : wrapperClassForCheckBoxList)
	    	{
	    		if(idForCheckBox.contains(obj.varForCheckBox.id))
	    		{
	    			obj.selectedCheckBox = true;	
	    		}
	    		else
	    			obj.selectedCheckBox = false;	
	    	}
	}
	
	// This method will help to maintain state of check boxes
 /*	public void stateChBox()
	{	
		for(wrapperClassForCheckBox  Obj : wrapperClassForCheckBoxList)
		{		
	    	
	    		  
	    	if(idForCheckBox.contains(obj.varForCheckBox.id))
	   		{
	    		obj.selectedCheckBox = true;
	    		//System.debug('------elements of set-------'+idForCheckBox);	    			
	    	}
	    	else
	    	{
	    		obj.selectedCheckBox = false;	
	    		//System.debug('-----FALSE--------'+obj);    
	    		//System.debug(' ----set-----'+idForCheckBox);				
	    	}	
	    }
	    System.debug('------idForCheckBox-------'+idForCheckBox);
	    System.debug('in statechbox method'+idForCheckBox.size());
	} */
	// Accepts the Alphabet string from Page and calculates Its Integer equivalent 
    public void noFromList11()        
    {   
    	nofromPage = integer.ValueOf(Accept);
    	counter = 0;
        pageNumber();        
        listDetail1();
        processSelected();
        check(); 
        getcountRecords();  
                         
    }
    
    // updates the number on visualforce page with in Input Box
    public void pageNumber()            
    {
    	pageNumberFormBoxInteger = counter / nofromPage +1;
    } 
    
    // counts the total number of records on click of any alphabet and count overall records
    public integer getCountRecords()    
    {
        String s='select Count () from account';
        if(alphabet != 'All' && alphabet != null && alphabet != '')
        {
            String temp = alphabet+'%';
            s += ' where name like : temp';          
        }
              
        temporary = database.countQuery(s);        
        totalRecs = temporary;
        return totalRecs;
    }
    
    // calculates which account to be deleted   
    public void delAccount()     
    { 
        try
        {
            for(integer i = 0 ; i < accountList1.size() ; i++)
            {
                if(accountList1[i].id == SelectedAccountId)
                {
                    count = accountList1[i];
                }
                /*if(idForCheckBox.contains(accountList1[i].id))
				{
					idForCheckBox.remove(accountList1[i].id);
					
					processSelected();
					//idForCheckBox =new Set<String>();
					//check();
					//numberOfSelectedXCheckBoxes = 0;
					//system.debug('in delete --numberOfSelectedXCheckBoxes'+numberOfSelectedXCheckBoxes+'------set size------------'+idForCheckBox); 				
				}*/
				//processSelected();
				//check();              
            }
            system.debug('in delete --numberOfSelectedXCheckBoxes'+numberOfSelectedXCheckBoxes+'------set size------------'+idForCheckBox); 
            //numberOfSelectedXCheckBoxes = 0;
			DELETE count;	
			//numberOfSelectedXCheckBoxes = idForCheckBox.size(); 		
			processSelected();
			 
			check();
			//idForCheckBox =new Set<String>();
			//numberOfSelectedXCheckBoxes = 0;
					
                     
            getcountRecords();
            
            pageNumber();
            
            listDetail1();
                      
        }
        catch(DMLException e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,e.getMessage()));
        }  
        finally
        {	
        	processSelected();
            pageNumber(); 
            listDetail1();
            check();  
        }                            
     }
    
    // Returns the recods Alphabetically 
    public void getFilter()     
    {  
        if(alphabet.equals ('All'))
        { 
        	processSelected();
        	//stateChBox();
            counter = 0;
            listDetail1();
            check();                        
            getcountRecords(); 
            pageNumber();
        }
        else
        {
        	processSelected();
        	//stateChBox();
            counter = 0;
            listDetail1();
            check();
            pageNumber(); 
            system.debug('alphabet'+alphabet);   
        }                        
    }
    
    // Dispalys select list on visualforcePage
    public List<SelectOption> getItems()    
    {
        List<SelectOption> options1 = new List<SelectOption>();
        options1.add(new SelectOption('10','Display 10 records per page'));
        options1.add(new SelectOption('25','Display 25 records per page'));
        options1.add(new SelectOption('50','Display 50 records per page'));
        options1.add(new SelectOption('100','Display 100 records per page'));
        options1.add(new SelectOption('200','Display 200 records per page'));
        
        return options1;
     }
    
    public String getAccept()
    {
        return accept;
    }

    public void setAccept(String Accept)
    {
        this.Accept = Accept;
    }
    
    // Calculates the next records according to select list
    public void nextPage()     
    {
    	processSelected();
    	//stateChBox();
        counter += nofromPage;    
        listDetail1();
        pageNumber(); 
        check();
    }  
    
     // Calculates the previousrecords according to select list     
    public void previousPage()   
    {    	
    	processSelected();    	    	
        counter -= nofromPage;
        listDetail1(); 
        pageNumber(); 
        check();
        //stateChBox();
                                    
    }
    
    // calculates  records according to select list on First page
    public void firstRecords()    
    {
    	processSelected();
    	//stateChBox();
        counter = 0;
        listDetail1();  
        pageNumber();
        check();
    }
    
    // calculates records on last Page according to select list on  Last Page 
    public void lastRecords()     
    {
    	processSelected();
    	//stateChBox();
        counter = totalRecs - math.mod(totalRecs ,nofromPage); 
        integer var123 = (counter >= totalRecs) ? totalRecs - math.mod(totalRecs ,nofromPage)-nofromPage :  totalRecs - math.mod(totalRecs ,nofromPage);
        counter = var123;
        listDetail1();
        pageNumber();
        check();        
    }
    
    // calculates is there more records or not on previous page
    public boolean getprev()     
    {
        if(counter== 0)
            return true;
        else
            return false;
    }
    
    // calculates is there more records or not on next page
    public boolean getnxt()      
    {
        if((counter+nofromPage) >= totalRecs )  
            return true;
        else
            return false;
    }
     
    // Total number of pages based on Select list   
    public integer getTotalPages()       
    {
        if (math.mod(totalRecs , nofromPage ) > 0) 
        {
            return totalRecs / nofromPage + 1 ;
        }
        else
        {
            return (totalRecs / nofromPage);
        }
    }  
 	
 	// calculates number of records  out of records per page 
    public integer getStartNumberOnPage()    
    {
        return (nofrompage * (counter / nofrompage +1)) - nofrompage +1;
    } 
    
    // To dispaly first records to last record number on every page
    public integer getEndNumberOnPage()     
    {
        if(((nofrompage * (counter / nofrompage +1))) > totalRecs) 
        {
            return totalRecs;
        }
        else
        {
            return (nofrompage * (counter / nofrompage +1)); 
        }    
        
    }  
	
	// calculates the number of records to display in Input box
    public PageReference getpgNUmberFormBox12()                   
    {
        if(pageNumberFormBoxInteger == 0|| pageNumberFormBoxInteger < 0)
        {
        	processSelected();
            counter = 0;
            pageNumberFormBoxInteger = 1;  
            listDetail1();
            check(); 
        }
         else if(pageNumberFormBoxInteger > (totalRecs / nofromPage))
            {
            	integer var123 = math.mod ( totalRecs , nofromPage);
            	if(var123 == 0)
            	{
            		processSelected();
            		pageNumberFormBoxInteger = totalRecs / nofromPage;
               		counter=(pageNumberFormBoxInteger * nofromPage -nofromPage  +1); 
                	listDetail1();
                	check();	
            	}
            	else if( var123 != 0)
            	{
            		processSelected();
            		pageNumberFormBoxInteger = totalRecs / nofromPage+1;
               		counter=(pageNumberFormBoxInteger * nofromPage -nofromPage  +1); 
                	listDetail1();
                	check();
            	}            	           	         		
            }
            processSelected();
       		counter=pageNumberFormBoxInteger * nofromPage - nofromPage;       		
            listDetail1();
            check();
            return null;
    }
    
    	//we'll process here selected check boxes
        public void processSelected()
    	{
    		//idForCheckBox =new Set<String>();
			//numberOfSelectedXCheckBoxes = 0;
			for(wrapperClassForCheckBox  Obj : wrapperClassForCheckBoxList)	
			{					
				if(obj.selectedCheckBox != false)
				{
					idForCheckBox.add(obj.varForCheckBox.id);
					numberOfSelectedXCheckBoxes = idForCheckBox.size() ;				
				}
				if(idForCheckBox.contains(SelectedAccountId))
				{
					idForCheckBox.remove(SelectedAccountId);
					numberOfSelectedXCheckBoxes = idForCheckBox.size() ;
				}
				else if(obj.selectedCheckBox == false)
				{
					idForCheckBox.remove(obj.varForCheckBox.id);
					numberOfSelectedXCheckBoxes = idForCheckBox.size();
				}
			}
			
			//check();
			System.debug('numberOfSelectedXCheckBoxes'+numberOfSelectedXCheckBoxes);
			System.debug('hello  jjii');			
    	}
    	
    	// Method to generate CSV File
    	public PageReference getCsvMethod()
    	{
    		String 	st  = 'select id,name,BillingState ,fax,type,phone,site,OwnerId from account where Id IN : idForCheckBox' ;
    		contain = database.query(st);	
    		PageReference pr =  Page.downloadAbleCSV;
	    	pr.setRedirect(false);    		
	    	return pr;
    		
    	}
    
    // Here is our wrapper class 
	public class wrapperClassForCheckBox
    {
		public Account varForCheckBox {get;set;}
    	public boolean selectedCheckBox{get;set;}
    		
    	// Constructor of wrapper class
    	public  wrapperClassForCheckBox(Account a )
    	{
    		varForCheckBox = a ;
    		selectedCheckBox = false ;
    	}
    		
     }  
           
   
 }