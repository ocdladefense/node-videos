global class EventListKey implements Comparable {
    public Integer section {get; private set;}
    
    public Integer year {get;private set;}
    
    public String sectionTitle {get; private set;}
    
    public EventListKey(ClickpdxEvent e){
        section = System.today() > e.startDate ? 9999 : e.startDate.year();
        year = e.startDate.year();
        sectionTitle = section == 9999 ? 'Past OCDLA Events' : 'Upcoming '+String.valueOf(year)+' Events';
    }
    
    public Boolean equals(Object obj){
        if (obj instanceof EventListKey) {
            EventListKey p = (EventListKey)obj;
            return section==p.section;
        }
        return false;
    }
    
    public Integer hashCode(){
        return section;
    }
    
    global Integer compareTo(Object compareTo) {
        EventListKey compareToKey = (EventListKey)compareTo;
        if (section == compareToKey.section) return 0;
        if (section > compareToKey.section) return 1;
        return -1;     
    }
    
}