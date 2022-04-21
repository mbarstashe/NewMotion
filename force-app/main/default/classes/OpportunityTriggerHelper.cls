public class OpportunityTriggerHelper {
  public Map<Id, Opportunity> getClosedWon(
    List<Opportunity> newList,
    Map<Id, Opportunity> oldMap
  ) {
    Map<Id, Opportunity> closedWonMap = new Map<Id, Opportunity>();
    for (Opportunity newOppty : newList) {
      if (
        newOppty.StageName == OpportunityHelper.CLOSED_WON &&
        oldMap.get(newOppty.Id).StageName != newOppty.StageName
      ) {
        closedWonMap.put(newOppty.Id, newOppty);
      }
    }
    return closedWonMap;
  }

  public List<OpportunityLineItem> getOpportunityLines(
    Set<Id> opportunityIdSet
  ) {
    return [
      SELECT id, ProductCode, Quantity
      FROM OpportunityLineItem
      WHERE OpportunityId IN :opportunityIdSet
    ];
  }

  public void processFailure(List<Opportunity> oppties) {
    publishPublicEvents(oppties);
    addError(oppties);
  }

  public void addError(List<Opportunity> oppties) {
    for (Opportunity op : oppties) {
      op.addError('Unfortunately the product is out of stock');
    }
  }

  public static void publishPublicEvents(List<Opportunity> opportunities) {
    List<Opportunity_Product_Missing_Event__e> events = new List<Opportunity_Product_Missing_Event__e>();
    for (Opportunity op : opportunities) {
      events.add(
        new Opportunity_Product_Missing_Event__e(Opportunity_Id__c = '' + op.Id)
      );
    }
    Database.SaveResult[] srList = EventBus.publish(events);
    // Inspect publishing result
    for (Database.SaveResult sr : srList) {
      if (sr.isSuccess()) {
        System.debug('Successfully published event.');
      } else {
        for (Database.Error err : sr.getErrors()) {
          System.debug(
            'Error returned: ' +
            err.getStatusCode() +
            ' - ' +
            err.getMessage()
          );
        }
      }
    }
  }
}
