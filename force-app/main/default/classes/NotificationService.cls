public class NotificationService {
  public void sendEmails(List<Id> userIds) {
    Messaging.MassEmailMessage message = new Messaging.MassEmailMessage();
    message.setTargetObjectIds(userIds);
    message.setSenderDisplayName('NewMotion Office');
    message.setReplyTo('no-reply@newmotion.com');
    message.setUseSignature(false);
    message.setBccSender(false);
    message.setSaveAsActivity(false);
    EmailTemplate emailTemplate = [
      SELECT Id
      FROM EmailTemplate
      WHERE name = 'OpportunitiesBackToWork'
    ];

    message.setTemplateID(emailTemplate.Id);

    Messaging.MassEmailMessage[] messages = new List<Messaging.MassEmailMessage>{
      message
    };

    Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
  }
}
