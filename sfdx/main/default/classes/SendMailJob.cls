global without sharing class SendMailJob implements Queueable, Database.AllowsCallouts {
   
    
    /**
     *
    1.) To Address
    Enter to address as qbo@saasant.io
    
	2.) Subject Line
    Enter subject as SalesReceipt
    
	3.) Body
    Enter the token as960A5FF8-ADF3-49F3-BDBF-8798E6B82DADin the email body.
    */

    private static final String TARGET_EMAIL = 'automation@ocdla.org';

    private static final Boolean IGNORE_MD5 = False;
    
    private Id reportId;

    global String relatedJobId;

    private String name;

    global String lastMd5 = null;
    
    private static final String DEFAULT_EMAIL = 'qbo@saasant.io';

    private static final String CC = 'jbernal.web.dev@gmail.com';
    
    private static final String DEFAULT_SUBJECT = 'SalesReceipt';

    private static final String DEFAULT_BODY = '960A5FF8-ADF3-49F3-BDBF-8798E6B82DAD';
    
    private ReportAttachment report;




    public void setLastMd5(String md5) {
        this.lastMd5 = md5;
    }

    public void setRelatedJobId(Id jobId) {
        this.relatedJobId = jobId;
    }

    public void addReportAttachment(ReportAttachment report) {
        this.report = report;
    }




    public void execute(QueueableContext context) {
        
        // Running the Report will execute a callout.
        if(null != this.report) {
            this.report.run();
        }


        // If the report evaluates to HTML (and not CSV)
        // It likely means there was an error generating the report.
        if(!this.report.isValid()) {
            System.debug('QB Report is invalid.');
            // bail out?
        }
		// If the MD5 hash is different, process the records.
		// Otherwise there hasn't been a change to the report so no need to send another integration request.
		else if (IGNORE_MD5 || !this.report.equalsHash(this.lastMd5)) {
			this.send(DEFAULT_EMAIL, this.report.toEmailAttachment());
		}
        else {
            System.debug('QB Report has not changed.');
            // this.sendInfo('Last MD5: ' + this.lastMd5 + ' Current MD5: ' + md5);
        }

        // Kill this job.  Request the next Job be set at the appropriate schedule.
        System.abortJob(this.relatedJobId);
		ReportAttachmentScheduler scheduler = new ReportAttachmentScheduler(this.report.getMd5());
        scheduler.requestNextSchedule('QBEmail-' + (DateTime.now().format()));
    }

    
    public void send() {
        send(DEFAULT_EMAIL, DEFAULT_SUBJECT, DEFAULT_BODY, null);
    }

    public void send(String to) {
        send(to, DEFAULT_SUBJECT, DEFAULT_BODY, null);
    }
    
    public void send(String to, Messaging.EmailFileAttachment csv) {
        send(to, DEFAULT_SUBJECT, DEFAULT_BODY, csv);
    }
    
    

    // Note this method only supports sending a single file attachment.
    // TODO: should support sending multiple attachments.
    public void send(String to, String subject, String body, Messaging.EmailFileAttachment csv) {

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        List<Messaging.EmailFileAttachment> attachments = new List<Messaging.EmailFileAttachment>();
        
        // Add the single CSV attachment.
        if(null != csv) {
        attachments.add(csv);
        }
        mail.setFileAttachments(attachments);
        mail.setSubject(subject);
        mail.setPlainTextBody(body);
        mail.setToAddresses( new String[] { to } );
        mail.setCcAddresses( new String[] { CC } );

        OrgWideEmailAddress[] org = [SELECT Id FROM OrgWideEmailAddress WHERE Address =:TARGET_EMAIL];
        
        if ( org.size() > 0 ) {
            mail.setOrgWideEmailAddressId(org.get(0).Id);
        }


        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
    }


    
    public void sendInfo(String body) {

        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        mail.setSubject('QB equal hash.');
        mail.setPlainTextBody(body);
        mail.setToAddresses( new String[] { 'jbernal.web.dev@gmail.com' } );

        OrgWideEmailAddress[] org = [SELECT Id FROM OrgWideEmailAddress WHERE Address =:TARGET_EMAIL];
        
        if ( org.size() > 0 ) {
            mail.setOrgWideEmailAddressId(org.get(0).Id);
        }


        Messaging.sendEmail( new Messaging.SingleEmailMessage[] { mail } );
    }
  




}