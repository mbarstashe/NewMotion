public class OpportunityHelper {
  public static final String CLOSED_WON = 'Closed Won';
  public static final String OUT_OF_STOCK = 'OUT OF STOCK';
  public static final String IN_STOCK = 'IN STOCK';
  private static NotificationService notifyService = new NotificationService();

  public Map<String, Integer> buildCodeToQuantityMap(
    List<OpportunityLineItem> opptyLines
  ) {
    Map<String, Integer> mapProductCodeToQuantity = new Map<String, Integer>();
    for (OpportunityLineItem line : opptyLines) {
      Integer productQuantity = Integer.valueOf(line.Quantity);
      if (mapProductCodeToQuantity.containsKey(line.productCode)) {
        productQuantity += mapProductCodeToQuantity.get(line.productCode);
      }
      mapProductCodeToQuantity.put(line.productCode, productQuantity);
    }

    return mapProductCodeToQuantity;
  }

  public List<Opportunity> getPendingOpportunities() {
    return [
      SELECT
        Id,
        OwnerId,
        (SELECT Id, ProductCode, Quantity FROM OpportunityLineItems)
      FROM Opportunity
      WHERE
        StageName NOT IN ('Closed Won', 'Closed Lost')
        AND Product_Check__c = :OUT_OF_STOCK
        AND id IN (SELECT OpportunityId FROM Quote WHERE Status = 'Accepted')
    ];
  }

  public Set<String> getProductCodes(List<Opportunity> opportunityList) {
    Set<String> productCodes = new Set<String>();
    for (Opportunity oppty : opportunityList) {
      for (OpportunityLineItem line : oppty.OpportunityLineItems) {
        productCodes.add(line.ProductCode);
      }
    }
    return productCodes;
  }

  public void processPendingOpportunities(
    List<Opportunity> opportunityList,
    Map<String, Integer> productQuantityMap
  ) {
    List<Opportunity> backToWork = new List<Opportunity>();
    List<Id> ownerIds = new List<Id>();
    for (Opportunity oppty : opportunityList) {
      if (isOpportunityEligible(oppty, productQuantityMap)) {
        oppty.Product_Check__c = IN_STOCK;
        backToWork.add(oppty);
        ownerIds.add(oppty.OwnerId);
      }
    }
    update backToWork;
    notifyService.sendEmails(ownerIds);
  }

  private boolean isOpportunityEligible(
    Opportunity opportunity,
    Map<String, Integer> productQuantityMap
  ) {
    for (OpportunityLineItem line : opportunity.OpportunityLineItems) {
      if (
        productQuantityMap.containsKey(line.ProductCode) &&
        line.Quantity > productQuantityMap.get(line.ProductCode)
      ) {
        return false;
      }
    }
    return true;
  }
}
