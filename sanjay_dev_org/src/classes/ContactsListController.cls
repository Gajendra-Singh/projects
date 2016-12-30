public class ContactsListController {
    
    private String sortOrder='LastName';
    
    public List<Contact> getContacts()
    {
        
        List<Contact> results= Database.query(
        'SELECT Id, FirstName,LastName, Title, Email '+
            'FROM Contact ' +
            'ORDER BY '+ sortOrder
          
           
        );
        return results;
    } 

}