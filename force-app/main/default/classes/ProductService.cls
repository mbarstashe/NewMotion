public class ProductService {
  private static OpportunityHelper helper = new OpportunityHelper();
  private static WarehouseService whService = new WarehouseService();

  //the service sends request to Warehouse and books the products
  public boolean bookProducts(List<OpportunityLineItem> opptyLines) {
    Map<String, Integer> mapProductCodeToQuantity = helper.buildCodeToQuantityMap(
      opptyLines
    );

    return whService.bookProducts(mapProductCodeToQuantity);
  }

  public void processPendingOpportunities() {
    List<Opportunity> opportunities = helper.getPendingOpportunities();
    Set<String> productCodes = helper.getProductCodes(opportunities);
    Map<String, Integer> productQuantityMap = whService.getProductQuantity(
      productCodes
    );

    helper.processPendingOpportunities(opportunities, productQuantityMap);
  }
}
