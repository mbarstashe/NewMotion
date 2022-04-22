@isTest
public without sharing class ProductServiceTest {
  @testSetup
  private static void testSetup() {
    User u = TestUtil.createUser();
    Opportunity opp = TestUtil.buildOpportunity('OpptyTest1234', 'Prospecting');
    opp.OwnerId = u.Id;
    opp.Product_Check__c = OpportunityHelper.OUT_OF_STOCK;
    insert opp;

    Product2 product = TestUtil.createProduct('Product X', 'CS-S-365');
    Id pricebookId = Test.getStandardPricebookId();
    PricebookEntry pbEntry = TestUtil.createPricebookEntry(
      product,
      pricebookId
    );

    OpportunityLineItem oli = TestUtil.buildOpportunityLineItem(
      opp,
      pbEntry,
      5
    );

    insert oli;

    TestUtil.createQuote(opp, 'TestQ1234', pricebookId, 'Accepted');
  }

  @IsTest
  static void testProductService() {
    Test.startTest();
    ProductService productServ = new ProductService();
    productServ.processPendingOpportunities();
    Test.stopTest();

    List<Opportunity> opptyToCloseList = [
      SELECT id, StageName, Product_Check__c
      FROM Opportunity
      WHERE name = 'OpptyTest1234'
    ];

    System.assertEquals(
      OpportunityHelper.IN_STOCK,
      opptyToCloseList.get(0).Product_Check__c
    );
  }

  @IsTest
  static void testBackToWorkScheduler() {
    Test.startTest();
    OpportunityBackToWorkScheduler sheduler = new OpportunityBackToWorkScheduler();
    system.schedule('OpptyBackToWorkSchdl', '0 0 19 * * ?', sheduler);
    Test.stopTest();

    List<AsyncApexJob> jobs = [SELECT id FROM AsyncApexJob WHERE ApexClass.Name = 'OpportunityBackToWorkScheduler'];
    System.assertEquals(1, jobs.size());
    List<Opportunity> opptyToCloseList = [
      SELECT id, StageName, Product_Check__c
      FROM Opportunity
      WHERE name = 'OpptyTest1234'
    ];

    System.assertEquals(
      OpportunityHelper.IN_STOCK,
      opptyToCloseList.get(0).Product_Check__c
    );
  }
}
