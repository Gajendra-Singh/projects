public with sharing class SendEmailClass 
{

 
 public void emailSent()
 {
  
   Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
   String[] toAddresses = new list<string> {'sanjaysoni.mca@gmail.com'};
   String subject ='Account CSV';
   email.setSubject(subject); 
   email.setToAddresses( toAddresses );
   email.setPlainTextBody('Account CSV ');
   
   Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
 }
}