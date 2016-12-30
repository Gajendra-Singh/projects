trigger ContactTrigger on Contact (after Insert, after update, after delete, after undelete) {

   if( Trigger.isAfter ){
        if( Trigger.isInsert ){
            //Execute Business rules after a Contact record is Inserted
            ContactTriggerHandler.OnAfterInsert(Trigger.new,Trigger.newMap);
        }
        
        if( Trigger.isUpdate ){
            //Execute Business rules after a Contact record is Updated            
            ContactTriggerHandler.OnAfterUpdate(Trigger.new,Trigger.newMap,Trigger.old,Trigger.oldMap);
        }
        
        if( Trigger.isDelete ){
            //Execute Business rules after a Contact record is Deleted
            ContactTriggerHandler.OnAfterDelete(Trigger.old,Trigger.oldMap);
        }
        
        if( Trigger.isUndelete ){
            //Execute Business rules after a Contact record is Undeleted
            ContactTriggerHandler.OnAfterUndelete(Trigger.new,Trigger.newMap);
        }
    }
}