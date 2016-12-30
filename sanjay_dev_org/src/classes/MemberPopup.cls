public class MemberPopup 
{
    public List<Merchandise__c> memberList {get;set;}
    public List<Merchandise__c> memberAddList {get;set;}
    public String memberName {get;set;}   
     
    public MemberPopup()
    {
        String sql = 'SELECT Name, Price__c,Quantity__c FROM Merchandise__c';
        memberList = Database.Query(sql);
        memberAddList = new List<Merchandise__c>();
        memberAddList.add(new Merchandise__c());
    }
    
    public void AddRow()
    {
        memberAddList.add(new Merchandise__c());
        System.debug('added'+memberAddList.size());
    } 
    
    
    public void deleteRow()
    {
    	System.debug('add'+memberAddList.size());
    	if(memberAddList.size()==1)
    	{
    	  ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,'You Can not delete this item'));
    	}
    	else
    	{
    	  memberAddList.remove(memberAddList.size()-1);
    	}
    	
    	System.debug('del'+memberAddList.size());
    } 
}