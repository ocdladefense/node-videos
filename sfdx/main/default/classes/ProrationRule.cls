public class ProrationRule {
	// 4qp - (NumElapsQ*qp) = p

	Decimal price;
	
    static Integer FLEX_DAYS_AHEAD = 5;
    
    Decimal proratedPrice;
    
	ProrationType t;
	
	public enum ProrationType {QUARTERLY,MONTHLY}
	
	public enum Quarter {Q1,Q2,Q3,Q4}
	 
	private enum RoundingType {NONE,UP,DOWN}
	// Oct., Nov., Dec.
	
	// Jan. Feb. Mar.
	
	// Apr. May Jun.
	
	// Jul. Aug. Sept.
	public ProrationRule(String tProrationName, Decimal p){
		t = getProrationType(tProrationName);
		price = p;
		proratedPrice = getProratedPrice(p);
	}
	
	
	private ProrationType getProrationType(String s){
        String comp = s.toUpperCase();
		for(ProrationType t :ProrationType.values()){
			if(t.name() == comp) return t;
		}
		
		return null;
	}
	
	private Decimal getInstallmentPrice(Decimal stdPrice){
		return stdPrice/4;
	}
    
    // For any given month calculate how 
    // many quarters have passed.
    private Integer getElapsedQuarters(Integer elapsedMonths){
        Decimal elapsedQuarters = elapsedMonths/4;
        
        // Round down to zero if still in the first quarter.
        Integer qElapsed = (Integer)elapsedQuarters.round(System.RoundingMode.DOWN); // if zero, then this is a full price product.
        
        return elapsedMonths <= 3 ? 0 : qElapsed + 1;
    }
    
    /**
     * @method, getEvaluatedDate
     * 
     * @description, catch purchases made on the cusp of the next proration date
     *   by adding FLEX_DAYS_AHEAD.
     * 
     * @params
     *   - theDate, System.Date, the date to be evaluated
     */
    private Date getEvaluatedDate(Date theDate){
		return theDate.addDays(FLEX_DAYS_AHEAD);
    }
    
    private Decimal getProratedPrice(Decimal stdPrice){
        Integer baseMonth = 6;
        Date evalDate = getEvaluatedDate(System.today());
        Integer evalMonth = evalDate.month() > baseMonth ? (evalDate.month() - baseMonth) : (evalDate.month() + baseMonth);
        Integer elapsedQuarters = this.getElapsedQuarters(evalMonth);
        Decimal unitPrice = getInstallmentPrice(stdPrice);
        
        // return stdPrice-(elapsedQuarters*unitPrice)).round(System.RoundingMode.UP);
		return stdPrice-(elapsedQuarters*unitPrice);
    }
    
    
	
	
}