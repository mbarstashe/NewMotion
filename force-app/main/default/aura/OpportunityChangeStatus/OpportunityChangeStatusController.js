({
	doInit : function(component, event, helper) {
        helper.getStageNameList(component);
    
	},
    
    handleSave : function(component, event, helper) {
        helper.changeStatus(component);
    }
})