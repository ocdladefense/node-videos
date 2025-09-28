public class CsvRow {

    private String data;
    
    private List<String> fieldArray;
    
    private Map<String,String> fieldMap;
      
    
    public CsvRow(String data) {
        this(data, null);
    }
    
    public CsvRow(String data, List<String> headings) {
        
        this.data = data;
        this.fieldArray = new List<String>();
        this.fieldMap = new Map<String,String>();
        
		this.fieldArray = CsvParser.parseRow(data);
        
        if(null != headings) {
            for(Integer index=0; index<headings.size(); index++) {

                String key = headings[index].trim();
                // System.debug('Current heading setup is: '+key);
                String value = index >= this.fieldArray.size() ? null : this.fieldArray[index];
                this.fieldMap.put(key,value);
            }
        }
    }
    
    
    // Check for blank CSV lines (only commas).
    public Boolean isBlank() {
        return data.replaceAll(',', '').trim().length() == 0;
    }

    
    public String get(Integer index) {
        String tmp = this.fieldArray[index];
        if(String.IsEmpty(tmp)) return tmp;
        return tmp.startsWith('"') ? tmp.substring(1,tmp.length()-1) : tmp;
    }
    
    public String get(String heading) {
        if(!this.fieldMap.containsKey(heading)) {
            throw new CsvColumnNotFoundException('No column, '+heading+', found in this row.');
        }
        
        String tmp = this.fieldMap.get(heading);
        if(String.IsEmpty(tmp)) return tmp;
        return tmp.startsWith('"') ? tmp.substring(1,tmp.length()-1) : tmp;
    }
    
    public List<String> getFields() {
        return this.fieldArray;
    }
    
    public Map<String,String> getFieldMap() {
        return this.fieldMap;
    }
    
    public override String toString() {
        return String.join(this.fieldArray,',');
    }
}