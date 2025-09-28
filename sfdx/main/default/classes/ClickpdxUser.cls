global class ClickpdxUser {

    String username;
    
    Contact who;
    
    final static String DEFAULT_PROFILE_NAME = 'Fonteva - Customer Community Login User';
    
    public String alias {get;private set;}
    
    public String nickname {get;private set;}

    
    public ClickpdxUser(Contact c){
        who = c;
		username = c.Email;
        String rand = this.who.LastName.substring(0,3)+random(); 
        this.alias = rand;
        this.nickname = rand;
    }
    
	public String random()
	{
		String hashString = '1000' + String.valueOf(Datetime.now().formatGMT('yyyy-MM-dd HH:mm:ss.SSS'));
		Blob hash = Crypto.generateDigest('MD5', Blob.valueOf(hashString));
		return EncodingUtil.convertToHex(hash).substring(0,4);
	}
    
    public ClickpdxUser(String email){}
    
    private Profile getProfileObject(){
		Profile pf = [SELECT Id, Name FROM Profile WHERE Name = :DEFAULT_PROFILE_NAME LIMIT 1];
        return pf;
    } 
    
    public Boolean userExists(){
        List<User> users = [SELECT Id FROM User WHERE Username = :this.username AND ContactId = :this.who.Id AND IsActive = True];
        return (null != users && users.size() > 0);
    }
    
    public User save(){
        User u = this.getUserObject();
        // insert u;
        
		Database.DMLOptions dlo = new Database.DMLOptions();
		dlo.EmailHeader.triggerUserEmail = True;
		Database.saveresult sr = Database.insert(u, dlo);
		return u;
    }
    
    private User getUserObject(){
        User u;
        
        u	= New User(
            UserName = this.username,
            FirstName = this.who.FirstName,
            LastName = this.who.LastName,
            Alias = this.alias,
            email = this.who.Email,
			CommunityNickName = this.nickname,
            ProfileID = getProfileObject().Id,
            TimeZoneSidKey = 'America/Los_Angeles', 
            LocaleSidKey = 'en_US', 
            EmailEncodingKey = 'UTF-8', 
            LanguageLocaleKey = 'en_US',
            ContactID = this.who.Id,
			IsActive = True
        );
        
        return u;
    }
    
}