trigger contactCountTrigger on Account (after update) {

    set<id> accountIds = new set<id>();
    for(Account acc : Trigger.new){
        accountIds.add(acc.id);
    }
    
    List<contact> contList = new List<contact>([Select id from contact where AccountId IN : accountIds]);
    
    for(Account acc: Trigger.new){
    
    }
}