({
    getStageNameList : function(component) {
        var action = component.get("c.getStageNameList");  
        
        action.setCallback(this, function(response) {  
            var state = response.getState();
           
            if ( state == "SUCCESS" ) {                
                
                component.set("v.stages", response.getReturnValue());
            }
            
        });  
        $A.enqueueAction( action );         
        
    },
    changeStatus : function(component) {
        var action = component.get("c.changeStatus");  
        action.setParams({  
            opportunityId: component.get( "v.recordId" ),
            stage: component.get("v.selectedStage")
        });  
        action.setCallback(this, function(response) {  
            var state = response.getState();
            var responseMessage = response.getReturnValue();
            $A.get("e.force:closeQuickAction").fire();  
            $A.get('e.force:refreshView').fire();   
            if ( responseMessage != "SUCCESS" ) {                
                var showToast = $A.get( "e.force:showToast" );
                showToast.setParams({
                    title : 'Warning',
                    message : responseMessage ,
                    type : 'warning',
                    mode : 'sticky'
                });
                showToast.fire();
                
            }
            
        });  
        $A.enqueueAction( action );         
        
    }
})