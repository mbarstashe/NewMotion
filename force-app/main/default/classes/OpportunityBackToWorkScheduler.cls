global without sharing class OpportunityBackToWorkScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        ProductService service = new ProductService();
        service.processPendingOpportunities();
    }
}