global class SandboxInitializer implements SandboxPostCopy {
    
    global SandboxInitializer() {
        // Implementations of SandboxPostCopy must have a no-arg constructor.
        // This constructor is used during the sandbox copy process.
        // You can also implement constructors with arguments, but be aware that
        // they won’t be used by the sandbox copy process (unless as part of the
        // no-arg constructor).
        this('Hello World!');
    }
    
    global SandboxInitializer(String some_args) {
        // Logic for constructor.
    }
    
    global void runApexClass(SandboxContext context) {
        System.debug('Org ID: ' + context.organizationId());
        System.debug('Sandbox ID: ' + context.sandboxId());
        System.debug('Sandbox Name: ' + context.sandboxName());
        
	
        
        try {
			
			this.initialize(context.sandboxName());
            
        } catch(Exception e) {
			
            System.debug('Error: ' + e.getMessage());
        }
    }
    
    
    
    global void initialize() {
		String exampleSandboxName = 'MySandbox';
        
        this.initialize(exampleSandboxName);
    }
    
    
    global void initialize(String sandboxName) {
        
        Boolean DO_INSERT_RECORDS = True;
        Boolean DO_MIXED_DML = True;
        Boolean DO_METADATA_DEPLOYMENT = True;
        
        try {  

			// Required non-Setup records for expected Accounts and Contacts.
            if(DO_INSERT_RECORDS) {
                SandboxRecords m = new SandboxRecords();
				System.scheduleBatch(m,'Non-setup records',1);
                // customerContactId = c.Id;
            }
            if(DO_MIXED_DML) {
            	// Required Setup records.
                SandboxMixedDml m = new SandboxMixedDml(null, sandboxName);
				System.scheduleBatch(m,'Setup records',5);
            }
            
            if(DO_METADATA_DEPLOYMENT) {
				deployMetadata();
            }
            
        } catch(Exception e) {
            
            System.debug(e);
        } 
        
        
    }

    

    
    
	
    global static void deployMetadata() {
        
        try {

            SandboxMetadataDeployment d1 = new SandboxMetadataDeployment();
            
            
            SandboxMetadataRecord m1 = new SandboxMetadataRecord('Credentials__mdt', 'AuthorizeDotNet');
            m1.put('Url__c','https://apitest.authorize.net/xml/v1/request.api');
            m1.put('Data__c','{"name":"6gSVxaYj397","transactionKey":"6FR49pDH5Jjum58g"}');
            
            Credentials__mdt tcm1 = getMetaDataRecords('AuthorizeDotNet');
            m1.setMasterLabel(tcm1.MasterLabel);
            
            // throw new SandboxInitializationException();
            EntityConfiguration tpl = new EntityConfiguration('CheckoutCommunityConfig');
			tpl.put('communityDomain', SandboxEnvironment.getCommunityDomain());//,'ocdla--ocdpartial.sandbox.my.site.com');
			tpl.put('cdn','membertest.ocdla.org');
			tpl.put('externalSite','test.ocdla.org');
			tpl.put('logoutUrl','/secur/singlelogout.jsp');
            
            SandboxMetadataRecord m2 = new SandboxMetadataRecord('EntityConfiguration__mdt', 'CheckoutCommunityConfig');
            m2.put('Config__c', tpl.toJson());
            m2.setMasterLabel('Checkout Template');
            
                    
            // throw new SandboxInitializationException();
            EntityConfiguration tpl2 = new EntityConfiguration('CommunityConfig');
			tpl2.put('communityDomain', SandboxEnvironment.getCommunityDomain());//,'ocdla--ocdpartial.sandbox.my.site.com');
			tpl2.put('cdn','membertest.ocdla.org');
			tpl2.put('externalSite','test.ocdla.org');
			tpl2.put('logoutUrl','/secur/singlelogout.jsp');
            
            SandboxMetadataRecord m3 = new SandboxMetadataRecord('EntityConfiguration__mdt', 'CommunityConfig');
            m3.put('Config__c', tpl2.toJson());
            m3.setMasterLabel('Community Config');

        
            
            
            SandboxMetadataRecord m4 = new SandboxMetadataRecord('ClickpdxCore__CoreConfig__mdt', 'NavMenu');
			m4.put('ClickpdxCore__Value__c','<ul><li class="no-mobile"><a href="/">Home</a></li><li><a href="/Videos">Videos</a></li><li><a href="/Store">Catalog</a></li><li class="no-mobile"><a href="/Donate">Donate</a></li><li class="no-mobile"><a href="//lodtest.ocdla.org/Public:Subscriptions">Books Online</a></li><li class="no-mobile"><a href="/OcdlaEvents">Seminars &amp; Events</a></li><li class="no-mobile menu-item-last"><a href="//lodtest.ocdla.org">Library of Defense</a></li></ul>');
            m4.setMasterLabel('Nav Menu');
            
            SandboxMetadataRecord m5 = new SandboxMetadataRecord('ClickpdxCore__CoreConfig__mdt', 'ScriptDomain');
			m5.put('ClickpdxCore__Value__c','membertest.ocdla.org');
            m5.setMasterLabel('Script Domain');

			d1.add(m1);
			d1.add(m2);
			d1.add(m3);
			d1.add(m4);
			d1.add(m5);            
            d1.deploy();


            
        } catch(Exception e) {
            
            System.debug('Error: ' + e.getMessage());
            throw e;
        }
    } 
    
    
    public static Credentials__mdt getMetaDataRecords(String name)
    {
        List<Credentials__mdt> tcm = [SELECT Id, DeveloperName, MasterLabel, Label FROM Credentials__mdt WHERE DeveloperName = :name];
        
        if(tcm.size() > 1) {
            throw new SandboxInitializationException();
        }
        
        return tcm.size() == 1 ? tcm[0] : null;
    }
    
}