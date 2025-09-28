public class JsonData {

    
    public List<Map<String,String>> data;
    
    private Integer i = 0;

    
    public JsonData(String data){
        try {
            if(null == data || ''==data.trim()) {
                this.data = new List<Map<String,String>>();        
            } else {
                this.data = (List<Map<String,String>>)JSON.deserialize(data,List<Map<String,String>>.class);
            }
        } catch(JSONException e){
                this.data = new List<Map<String,String>>();              
        }
        
    }
    
    public JsonData(){
        this(null);
    }
    
    private static Boolean isEmpty(String comp){
        return null == comp || '' == comp.trim();
    }
    
    @testVisible
    private Map<String,String> getDefault(){
        return new Map<String,String>{
            'firstName' => '',
			'lastName' => '',
			'meal' => ''
        };
    }
    
    public Map<String,String> getRegistrationData(Integer regNo){
        Map<String,String> theData;
        
        
		if(this.data.size() == 0 || null == this.data.get(regNo)) return this.getDefault();
        
        else {
            theData = this.data.get(regNo);
        }
        
        
        String first = isEmpty(theData.get('firstName')) ? '' : theData.get('firstName');
        String last = isEmpty(theData.get('lastName')) ? '' : theData.get('lastName');
        String meal = isEmpty(theData.get('meal')) ? '' : theData.get('meal');
        
        return new Map<String,String>{
            'firstName' => first,
            'lastName' => last,
            'meal' => meal
        };
    }
    
    

    
    public Map<String,String> get(Integer i){
        return getRegistrationData(i);
    }
    
}