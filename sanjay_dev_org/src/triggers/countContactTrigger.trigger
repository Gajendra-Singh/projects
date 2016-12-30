trigger countContactTrigger on Contact (after Insert, after update, after delete, after undelete) {

    List<Contact> contList = new List<Contact>();   
        if(trigger.IsUpdate || trigger.IsDelete){
            contList = trigger.old;
        }
        else{            
            contList = trigger.New;
        }
    
    Set<Id> accountIds = new Set<Id>(); 
    for(Contact cont: contList){
        if(Trigger.IsInsert || Trigger.IsUpdate || Trigger.IsDelete || Trigger.IsUndelete){ 
            if(cont.AccountId != null){                     
                accountIds.add(cont.AccountId);
            }
        }
    }
    
    if(accountIds.size()> 0){       
        //Trigger Handler to count child contacts & populate on Account Object
        contactHandlerController.contCountMethod(accountIds);       
    }
    
    
    
}