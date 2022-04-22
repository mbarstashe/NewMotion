@isTest
public without sharing class OpportunityControllerTest {
  @testSetup
  private static void testSetup() {
    Opportunity opp = TestUtil.buildOpportunity('OpptyTest1234', 'Prospecting');
    Opportunity oppSmall = TestUtil.buildOpportunity('OpptyTestSmall','Prospecting');
    insert new List<Opportunity>{ opp, oppSmall };

    Product2 product = TestUtil.createProduct('Product X', 'CS-S-365');

    Id pricebookId = Test.getStandardPricebookId();
    PricebookEntry pbEntry = TestUtil.createPricebookEntry(product, pricebookId);

    OpportunityLineItem oli = TestUtil.buildOpportunityLineItem(
      opp,
      pbEntry,
      5
    );

    OpportunityLineItem oliSmall = TestUtil.buildOpportunityLineItem(
      oppSmall,
      pbEntry,
      1
    );

    insert new List<OpportunityLineItem>{ oli, oliSmall };
  }

  @IsTest
  static void testCloseSuccess() {
    List<Opportunity> opptyToCloseList = [
      SELECT id
      FROM Opportunity
      WHERE name = 'OpptyTestSmall'
    ];
    Test.startTest();
    System.assertEquals(1, opptyToCloseList.size());

    String response = OpportunityController.changeStatus(
      opptyToCloseList.get(0).Id,
      OpportunityHelper.CLOSED_WON
    );

    Test.stopTest();
    opptyToCloseList = [
      SELECT id, StageName, Product_Check__c
      FROM Opportunity
      WHERE name = 'OpptyTestSmall'
    ];
    System.assertEquals('SUCCESS', response);
    System.assertEquals(
      OpportunityHelper.CLOSED_WON,
      opptyToCloseList.get(0).StageName
    );
  }

  @IsTest
  static void testCloseFail() {
    List<Opportunity> opptyToCloseList = [
      SELECT id
      FROM Opportunity
      WHERE name = 'OpptyTest1234'
    ];
    Test.startTest();
    System.assertEquals(1, opptyToCloseList.size());

    String response = OpportunityController.changeStatus(
      opptyToCloseList.get(0).Id,
      OpportunityHelper.CLOSED_WON
    );

    Test.stopTest();
    opptyToCloseList = [
      SELECT id, StageName, Product_Check__c
      FROM Opportunity
      WHERE name = 'OpptyTest1234'
    ];
    System.assertEquals(
      'Unfortunately opportunity cannot be closed, as the product is out of stock. You will get email notification once the product is available',
      response
    );
    System.assertEquals(
      OpportunityHelper.OUT_OF_STOCK,
      opptyToCloseList.get(0).Product_Check__c
    );
  }

  @isTest
  private static void testGetStageNameList() {
    String[] stageNames = OpportunityController.getStageNameList();
    System.assert(
      stageNames.contains(OpportunityHelper.CLOSED_WON),
      'The set of stages doesn\'t contain Closed Won'
    );
  }
}
