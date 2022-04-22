@isTest
public without sharing class TestUtil {
  public static Opportunity buildOpportunity(String name, String stage) {
    Opportunity opp = new Opportunity(
      Name = name,
      StageName = stage,
      CloseDate = Date.today().addDays(20)
    );
    return opp;
  }

  public static OpportunityLineItem buildOpportunityLineItem(
    Opportunity opportunity,
    PricebookEntry pbEntry,
    Decimal quantity
  ) {
    OpportunityLineItem oli = new OpportunityLineItem(
      OpportunityId = opportunity.Id,
      Quantity = quantity,
      PricebookEntryId = pbEntry.Id,
      TotalPrice = quantity * pbEntry.UnitPrice
    );
    return oli;
  }

  public static Product2 createProduct(String name, String code) {
    Product2 product = new Product2(
      Name = name,
      ProductCode = code,
      isActive = true
    );
    insert product;
    return product;
  }

  public static PricebookEntry createPricebookEntry(
    Product2 product,
    Id pricebookId
  ) {
    PricebookEntry pbEntry = new PricebookEntry(
      Pricebook2Id = pricebookId,
      Product2Id = product.Id,
      UnitPrice = 100.00,
      IsActive = true
    );
    insert pbEntry;

    return pbEntry;
  }

  public static Quote createQuote(
    Opportunity opportunity,
    String name,
    Id pricebookId,
    String status
  ) {
    Quote q = new Quote(
      OpportunityId = opportunity.Id,
      Name = name,
      Pricebook2Id = pricebookId,
      Status = status
    );
    insert q;
    return q;
  }

  public static User createUser() {
    Profile p = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
    User u = new User(
      Alias = 'standt',
      Email = 'standarduser@testorg.com',
      EmailEncodingKey = 'UTF-8',
      LastName = 'Testing',
      LanguageLocaleKey = 'en_US',
      LocaleSidKey = 'en_US',
      ProfileId = p.Id,
      TimeZoneSidKey = 'America/Los_Angeles',
      UserName = 'standarduser@testorg.com'
    );
    insert u;
    return u;
  }
}
