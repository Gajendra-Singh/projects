trigger AccountCheck on Account (after insert) {
    
    if(Trigger.isInsert){
        Set<Id> accId = new Set<Id>();
        for(Account acc : Trigger.New){
            accId.add(acc.id);
        }
        List<Contact> conList = new List<Contact>();
        if(accId.size() > 0){
            for(Id acId : accId){
                conList.add(new Contact(LastName='test',AccountId = acId));
            }
        }
        if(conList.size() > 0){
            insert conList;
        }
    }
}