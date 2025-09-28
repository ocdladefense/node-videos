public class GoogleRecaptcha {

	public enum ResponseScore {BOT, HUMAN}
    
    public static final Decimal LOW_SCORE = 0.1;
    
    public static final Decimal HIGH_SCORE = 1.0; 
    
    public static final Decimal PASS_SCORE = 0.5;
}