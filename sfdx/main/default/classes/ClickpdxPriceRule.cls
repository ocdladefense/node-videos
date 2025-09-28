public class ClickpdxPriceRule {//implements Discountable {

	public Boolean active;
    
	public String name;
	
    public String description;
	
    // @todo change to attribute name
	public String attribute;
	
    public String attributeName;
    
    public String attributeToken;
    
	public String attributeType;
	
	public String value;
	
	public String op;
	
	public Decimal price;
    
    public ClickpdxPriceRule(){}
    
    public static String getMonthText(Integer month){
        Map<Integer,String> months;
        
        months = new Map<Integer,String>();
        months.put(1,'January');
        months.put(2,'February');
        months.put(3,'March');
        months.put(4,'April');
        months.put(5,'May');
        months.put(6,'June');
        months.put(7,'July');
        months.put(8,'August');
        months.put(9,'September');
        months.put(10,'October');
        months.put(11,'November');
        months.put(12,'December');
        
        return months.get(month);
    }

}