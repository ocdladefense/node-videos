global without sharing class ClickpdxMail {
    
    private final static String MAIL_DOMAIN = 'ocdla.force.com';
    
    private final static String DEFAULT_SENDER_DISPLAY_NAME = 'OCDLA';
    
    
    public interface ISendable {  
    
        
        List<String> getBccAddresses();
        
        // List<String> getCcAddresses();
        
        // List<String> getToAddresses();
        
        // List<String> getSubject();
        
        // List<String> getHtmlBody();
        
        
        
    }
    
    
    webservice static Boolean sendEmail(Id templateId, Id objectId, Id whatId, String email){
        String msg;
        Boolean sent = false;
        List<String> toAddress;
        
        try {
            
            /*Compiled*/ Messaging.SingleEmailMessage compiled = ClickpdxMail.getCompiledEmail(templateId,objectId,whatId);
            sent = ClickpdxMail.send(compiled,email);
        } catch(Exception ex){
            String foo = 'bar';
            Boolean sender = false;
            String foobar = 'baz';
            msg = ex.getTypeName() + ': ' + ex.getMessage() + '\n\n'+ex.getStackTraceString();
        }
        
        return sent;
    }
    
    webservice static String testEmail(Id emailTemplateId, Id whoId, Id whatId){
        Messaging.SingleEmailMessage compiledEmail;
        String msg;
        Boolean sent = false;
        
        if(null == whoId){
            throw new ClickpdxObjectException('Missing whoId');
        }
        if(null == whatId){
            // throw new ClickpdxObjectException('Missing whatId');
        }
        

        
       	try {
        	compiledEmail = getEmailPreview(emailTemplateId,whoId,whatId);
            sent = ClickpdxMail.send(compiledEmail,UserInfo.getUserEmail());
        } catch(Exception ex){
            msg = ex.getTypeName() + ': ' + ex.getMessage() + '\n\n'+ex.getStackTraceString();
        } finally {
            
            
        }

        msg = sent ? 'Test Email Sent!' : msg;
        return msg;
    }
    
    
    public static Messaging.SingleEmailMessage getEmailPreview(Id templateId, Id whoId, Id whatId){
            if(null == whoId){
                throw new ClickpdxObjectException('Missing whoId');
            }
            if(null == whatId){
                // throw new ClickpdxObjectException('Missing whatId');
            }
        Messaging.SingleEmailMessage msg = ClickpdxMail.getSingleEmailMessage(
            templateId,
            new List<String>{UserInfo.getUserEmail()},
            whoId,
            whatId);
        return ClickpdxMail.getCompiledEmail(msg);
    } 
    
    public static Messaging.SingleEmailMessage getEmailPreview(Messaging.SingleEmailMessage theEmailExample, Id whoId, Id whatId){
        Messaging.SingleEmailMessage theMessage;
            if(null == whoId){
                throw new ClickpdxObjectException('Missing whoId');
            }
        theMessage = ClickpdxMail.getSingleEmailMessageFromMail(
            theEmailExample,
            new List<String>{UserInfo.getUserEmail()},
            whoId,
            whatId);
        return ClickpdxMail.getCompiledEmail(theMessage);
    } 
    
    public static Id getEmailTemplateId(String templateName){
        List<EmailTemplate> emailTemplates = [SELECT Id, Name FROM EmailTemplate WHERE Name=:templateName];
        return emailTemplates.get(0).Id;
    }
    
    
    public static Map<Id,Messaging.SingleEmailMessage> getEmailMessages(Id templateId, List<sObject> targetObjects){
        return getEmailMessages(templateId,targetObjects,null,null);
    }
    
    public static Map<Id,Messaging.SingleEmailMessage> getEmailMessages(Id templateId, List<sObject> targetObjects,List<sObject> whatObjects, List<String> toAddress){
        Map<Id,Messaging.SingleEmailMessage> messages = new Map<Id,Messaging.SingleEmailMessage>();
        Integer counter = 0;
        
        for(sObject o: targetObjects) {
            Messaging.SingleEmailMessage message;
            List<String> emails;
            Id objectId;
            Id whatId;
            
            objectId = o.Id;
            whatId = whatObjects != null ? whatObjects[counter].Id : null;
            emails = null != toAddress ? toAddress : new List<String>{(String)o.get('Email')};
                message = getSingleEmailMessage(templateId,emails,objectId,whatId);
            messages.put(objectId,message);
            counter ++;
        }
        
        return messages;
        
    }
    
    
    public static Messaging.SingleEmailMessage getSingleEmailMessage(Id templateId, List<String> toAddress,Id objectId,Id whatId){
    	Messaging.SingleEmailMessage msg;
        
        msg = getSingleEmailMessageBase(toAddress,objectId,whatId);
		msg.setTemplateID(templateId);
        
        return msg;
    } 
    
    public static Messaging.SingleEmailMessage getSingleEmailMessageFromMail(Messaging.SingleEmailMessage example, List<String> toAddress,Id objectId,Id whatId){
    	Messaging.SingleEmailMessage msg;
        
        msg = getSingleEmailMessageBase(toAddress,objectId,whatId);
		msg.setTreatBodiesAsTemplate(true);
        msg.setPlainTextBody(example.getPlainTextBody());
        msg.setHTMLBody(example.getHTMLBody());
        msg.setSubject(example.getSubject());
        return msg;
    } 
    
    
    public static Messaging.SingleEmailMessage getSingleEmailMessageBase(List<String> toAddress,Id objectId,Id whatId){
        Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
        
        List<String> ccAddress = new List<String>();
        
        Clickpdx_Apps__c settings;
        settings = Clickpdx_Apps__c.getInstance();
        if(null != settings && settings.Clickpdx_Mail_Copy_Current_User__c==True){
            ccAddress.add(UserInfo.getUserEmail());
        }
        
        if(null != settings && settings.Clickpdx_Mail_From_Display_Name__c != null){
            msg.setSenderDisplayName(settings.Clickpdx_Mail_From_Display_Name__c);
        } else {
	        msg.setSenderDisplayName(DEFAULT_SENDER_DISPLAY_NAME);
        }
        
        if(null != settings && settings.Clickpdx_Mail_Reply_To_Address__c != null){
            msg.setReplyTo(settings.Clickpdx_Mail_Reply_To_Address__c);
        }
        
        msg.setToAddresses(toAddress);
        msg.setCcAddresses(ccAddress);
        msg.setTargetObjectId(objectId);
        msg.saveAsActivity = true;
        if(null != whatId) {
            msg.setWhatId(whatId);
        }
        //      $recipients = is_array($recipients)?implode(',',$recipients):$recipients;
        //      $rand = time() .'-' . md5(self::getSender() . $recipients) . '@'.self::$domain;
        //      $messageId = "Message-Id: <{$rand}>";
        //         msg.setReferences('X-Entity-Ref-ID: <'+Math.random()+'@ocdla.force.com>');
        String rand = '<'+Math.random()+'@'+ MAIL_DOMAIN+'>';
        msg.setReferences(rand);
        msg.setInReplyTo(rand);
        
        return msg;
    }
    
    // https://appirio.com/tech-blog/sending-emails-without-targetobject-id-apex
    // https://developer.salesforce.com/docs/atlas.en-us.202.0.apexcode.meta/apexcode/apex_classes_email_outbound_messaging.htm?search_text=RenderEmailTemplateBodyResult
    public static Messaging.SingleEmailMessage getCompiledEmail(Id emailTemplateId, Id objectId, Id whatId){
        
        Messaging.SingleEmailMessage msg = ClickpdxMail.getSingleEmailMessage(
            emailTemplateId,
            new List<String>{UserInfo.getUserEmail()},
            objectId,
            whatId);
        Messaging.SingleEmailMessage[] emailMessageList = new Messaging.SingleEmailMessage[]{};
            emailMessageList.add(msg);
        Savepoint sp = Database.setSavepoint();
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMessageList);
        Database.rollback(sp);
        return msg;
    }
    
    // https://appirio.com/tech-blog/sending-emails-without-targetobject-id-apex
    // https://developer.salesforce.com/docs/atlas.en-us.202.0.apexcode.meta/apexcode/apex_classes_email_outbound_messaging.htm?search_text=RenderEmailTemplateBodyResult
    public static Messaging.SingleEmailMessage getCompiledEmail(Messaging.SingleEmailMessage msg){
        Messaging.SingleEmailMessage[] emailMessageList = new Messaging.SingleEmailMessage[]{};
            emailMessageList.add(msg);
        Savepoint sp = Database.setSavepoint();
        Messaging.SendEmailResult[] results = Messaging.sendEmail(emailMessageList);
        Database.rollback(sp);
        return msg;
    }
    
    public static Boolean send(Messaging.SingleEmailMessage msg, String toAddress){
        return send(new List<Messaging.SingleEmailMessage>{msg}, toAddress);
    }

    
    public static Boolean send(List<Messaging.SingleEmailMessage> compiled, String toAddress){
        List<Messaging.SingleEmailMessage> msgListToBeSent = new List<Messaging.SingleEmailMessage>();
        
        OrgWideEmailAddress owa = [SELECT Id, Address, DisplayName FROM OrgWideEmailAddress WHERE DisplayName = 'OCDLA' LIMIT 1];
        

        for (Messaging.SingleEmailMessage msg : compiled) {
            String[] cc = new String[]{'admin@ocdla.org'};
                if(null != msg.getCcAddresses()){
                    cc.addAll(msg.getCcAddresses());
                }
            Messaging.SingleEmailMessage env = new Messaging.SingleEmailMessage();
            
            // Note we cannot set the target object id again otherwise Salesforce's
            // internal methods will also append this to the TO address.
        	// env.setTargetObjectId(msg.getTargetObjectId());
            env.setToAddresses(new List<String>{toAddress});
            env.setPlainTextBody(msg.getPlainTextBody());
            env.setHTMLBody(msg.getHTMLBody());
            env.setSubject(msg.getSubject());
            // env.setSenderDisplayName(msg.getSenderDisplayName());
            env.setCcAddresses(cc);
            
            // Really make sure it comes from OCDLA.
            env.setReplyTo('admin@ocdla.org');
            env.setSenderDisplayName(null);
            env.setOrgWideEmailAddressId(owa.Id);
        	env.saveAsActivity = true;
            
            msgListToBeSent.add(env);
        }
        
        return Messaging.sendEmail(msgListToBeSent)[0].isSuccess();
    }
 
    public static EmailTemplate createEmailTemplate(String templateName){
        EmailTemplate t;

        
        t = new EmailTemplate();
        t.isActive = true;
        t.Name = templateName;
        t.DeveloperName = templateName.replaceAll('[\\s]','_');
        t.TemplateType = 'text';
        t.BrandTemplateId = '016j0000000Kztb';
        t.TemplateStyle = 'freeForm';
        t.Encoding = 'utf-8';
        t.FolderId = UserInfo.getUserId();
        
        return t;
    }    

    
}