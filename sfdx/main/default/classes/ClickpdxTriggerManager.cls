public class ClickpdxTriggerManager {

    public static Boolean isTriggerExecuting = False;
    
    public static Map<String,List<ClickpdxTrigger>> triggers;
    
    
    /**
     * 
     * Load a List<ClickpdxTrigger> configs
     * 
     */
    public ClickpdxTriggerManager(){}
    
    
    
    private static Map<String,List<ClickpdxTrigger>> loadCustomMetadata(){
		ClickpdxTrigger__mdt [] tConfigs = [SELECT SObjectName__c, Config__c  FROM ClickpdxTrigger__mdt];
        Map<String,List<ClickpdxTrigger>> tmpTriggers = new Map<String,List<ClickpdxTrigger>>();
        
        for(ClickpdxTrigger__mdt tConfig:tConfigs){
            ClickpdxTrigger t;
            if(null == tConfig.Config__c) continue;
            t = (ClickpdxTrigger)JSON.deserialize(tConfig.Config__c, ClickpdxTrigger.class);
            if(null == tmpTriggers.get(tConfig.SObjectName__c)){
                tmpTriggers.put(tConfig.SObjectName__c,new List<ClickpdxTrigger>{t});
            } else {
                tmpTriggers.get(tConfig.SObjectName__c).add(t);
            }
        }
        
        return tmpTriggers;
    }
    


    
    public static void loadTriggers(){
		isTriggerExecuting = True;
        if(null == triggers){
			triggers = loadCustomMetadata();//Test.isRunningTest() ? getTestTriggersHelper() : loadCustomMetadata();
        }
    }
    
    public static List<ClickpdxTrigger> getTriggers(String sObjectName){
        loadTriggers();
        List<ClickpdxTrigger> tList;
        
        tList = triggers.get(sObjectName);
        
        if(null == tList){
            throw new ClickpdxTriggerException('There are no triggers for sObject '+sObjectName);
        }
        
        return tList;
    }
    
    private static ClickpdxTrigger search(String oKey, String tKey){
        for(ClickpdxTrigger t : getTriggers(oKey)){
            if(tKey == t.name){
                return t;
            }
        }
        
        return null;
    }
    
    public static ClickpdxTrigger getTrigger(String key){
		List<ClickpdxTrigger> tList;
        ClickpdxTrigger t;
        String oKey;
        String tKey;
        
        List<String> tmp = key.split('\\.');
        oKey = tmp[0];
        tKey = tmp[1];
        
        t = search(oKey,tKey);
        
        if(null == t){
            throw new ClickpdxTriggerException('No entry for ClickpdxTrigger with key '+key);
        }
        
        return t;
    }
    
    
    public class ClickpdxTrigger {
        
        public String name {public get; private set;}
        
        public Boolean isActive {public get; private set;}
        
        public Map<String,Map<String,String>> data {public get; private set;}
        
    }
    
    
    public class ClickpdxTriggerException extends Exception {}
}