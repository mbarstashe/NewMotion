trigger OpportunityTrigger on Opportunity (before update, after update) {
    
    OpportunityTriggerHandler handler = new OpportunityTriggerHandler();
    if(Trigger.isBefore && Trigger.isUpdate){
        //handler.beforeUpdate(Trigger.new, Trigger.oldMap);
    }
    
    if(Trigger.isAfter && Trigger.isUpdate){
        handler.afterUpdate(Trigger.new, Trigger.oldMap);
    }

}