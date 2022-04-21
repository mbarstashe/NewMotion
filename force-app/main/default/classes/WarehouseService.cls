public class WarehouseService {
  private static final String productCode1 = 'CS-S-365';
  private static final String productCode2 = 'GS-U-123';

  public boolean bookProducts(Map<String, Integer> mapProductCodeToQuantity) {
    if (
      mapProductCodeToQuantity.containsKey(productCode1) &&
      mapProductCodeToQuantity.get(productCode1) > 1
    ) {
      return false;
    }
    if (
      mapProductCodeToQuantity.containsKey(productCode2) &&
      mapProductCodeToQuantity.get(productCode2) > 1
    ) {
      return false;
    }

    return true;
  }

  public Map<String, Integer> getProductQuantity(Set<String> productCodes) {
    Map<String, Integer> response = new Map<String, Integer>();
    response.put(productCode1, 100);
    response.put(productCode2, 100);
    return response;
  }
}
