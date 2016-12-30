trigger Merch on Merchandise__c (before insert) {
    
    for(Merchandise__c temp:[SELECT ID from Merchandise__c])
    {
        temp.Quantity__c=1200;
    }

}