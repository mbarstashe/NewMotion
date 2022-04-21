public with sharing class OpportunityController {
  private static final String NO_PRODUCT_MESSAGE = 'Unfortunately opportunity cannot be closed, as the product is out of stock. You will get email notification once the product is available';
  private static final String SUCCESS = 'SUCCESS';
  private static ProductService prodService = new ProductService();
  private static OpportunityTriggerHelper helper = new OpportunityTriggerHelper();

  @AuraEnabled
  public static String changeStatus(String opportunityId, String stage) {
    String response;
    boolean isProductAvailable = true;

    if (stage == OpportunityHelper.CLOSED_WON) {
      List<OpportunityLineItem> opptyLines = helper.getOpportunityLines(
        new Set<ID>{ opportunityId }
      );
      isProductAvailable = prodService.bookProducts(opptyLines);
    }
    Opportunity opportunity = new Opportunity(Id = opportunityId);
    if (!isProductAvailable) {
      opportunity.Product_Check__c = OpportunityHelper.OUT_OF_STOCK;
      response = NO_PRODUCT_MESSAGE;
    } else {
      opportunity.StageName = stage;
      response = SUCCESS;
    }

    update opportunity;
    return response;
  }

  @AuraEnabled
  public static String[] getStageNameList() {
    List<String> pickListValuesList= new List<String>();
    Schema.DescribeFieldResult fieldResult = Opportunity.StageName.getDescribe();
    List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
    for( Schema.PicklistEntry pickListVal : ple){
        pickListValuesList.add(pickListVal.getLabel());
    }     

    return pickListValuesList;
      
  }
}
