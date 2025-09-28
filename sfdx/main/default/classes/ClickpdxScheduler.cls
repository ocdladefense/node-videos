global class ClickpdxScheduler implements Schedulable {
    
    public Interface ISchedulable
    {
        void execute(SchedulableContext sc);
    }
    
    global void execute(SchedulableContext sc)
    {
        String[] classes = new String[]{};
        
        Clickpdx_Apps__c cs = Clickpdx_Apps__c.getOrgDefaults();
        
        classes = null != cs.Clickpdx_Scheduled_Classes__c ? cs.Clickpdx_Scheduled_Classes__c.split(',') : classes;
        classes = Test.isRunningTest() ? new String[]{'OcdlaBonNotification'} : classes;
        
        for(String className :classes){
            Type targettype = Type.forName(className);
            if(targettype != null)
            {
                ISchedulable obj = (ISchedulable)targettype.NewInstance();
                obj.execute(sc);
            }
        }
    }
}