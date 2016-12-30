public with sharing class ContactsControllerTest{

    @RemoteAction
    public static list<contact> getContacts()
    {
        return [SELECT Id, Name FROM contact limit 10];
    }
}