trigger test on Invoice__c (before insert) {
    
   Contact cont= new Contact();
   cont.LastName= 'soni';
    cont.FirstName='soni';
    
    insert cont;
    
   

}