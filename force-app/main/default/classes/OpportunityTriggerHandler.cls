public class OpportunityTriggerHandler {
  private static OpportunityTriggerHelper helper = new OpportunityTriggerHelper();
  private static ProductService prodService = new ProductService();

  /**public void beforeUpdate(
    List<Opportunity> newList,
    Map<Id, Opportunity> oldMap
  ) {
    Map<Id, Opportunity> closedWonMap = helper.getClosedWon(newList, oldMap);
    if (!closedWonMap.isEmpty()) {
      List<OpportunityLineItem> opptyLines = helper.getOpportunityLines(
        closedWonMap.keySet()
      );
      boolean result = prodService.bookProducts(opptyLines);

      if (!result) {
        helper.processFailure(closedWonMap.values());
      }
    }
  }*/

  public void afterUpdate(
    List<Opportunity> newList,
    Map<Id, Opportunity> oldMap
  ) {
    Map<Id, Opportunity> closedWonOpportunityMap = helper.getClosedWon(
      newList,
      oldMap
    );
    //TODO: generate Cases for Installers
  }
}
