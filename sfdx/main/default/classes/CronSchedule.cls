/**
 * CronSchedule class represents a CRON expression as an array of strings.
 * Each element in the array corresponds to a field in the CRON expression:
 * (seconds, minutes, hours, day of month, month, day of week, year)
 * 
 * This allows for more flexible scheduling options and can be unit tested
 * to assert that it can accurately create CRON_STRINGs for a given point in the future.
 */
public class CronSchedule {

    private Integer[] values = new Integer[7];

    private String[] cronFields = new String[7];

    // CRON field constants for clarity
    public static final Integer SECONDS = 0;
    public static final Integer MINUTES = 1;
    public static final Integer HOURS = 2;
    public static final Integer DAY_OF_MONTH = 3;
    public static final Integer MONTH = 4;
    public static final Integer DAY_OF_WEEK = 5;
    public static final Integer YEAR = 6;
    


    public static CronSchedule now() {
        DateTime now = DateTime.now();

        return new CronSchedule(now);
    }



    public static CronSchedule newInstance(Integer year, Integer month, Integer day, Integer hour, Integer minute, Integer second) {

        return new CronSchedule(DateTime.newInstance(year, month, day, hour, minute, second));
    }


    /**
     * Constructor that takes a DateTime and creates a CRON expression for that exact time
     */
    public CronSchedule(DateTime scheduleTime) {

        this.values[SECONDS] = scheduleTime.second();
        this.values[MINUTES] = scheduleTime.minute();
        this.values[HOURS] = scheduleTime.hour();
        this.values[DAY_OF_MONTH] = scheduleTime.day();
        this.values[MONTH] = scheduleTime.month();
        this.values[DAY_OF_WEEK] = null;
        this.values[YEAR] = scheduleTime.year();
    }



    public Integer[] getValues() {
        return this.values.clone();
    }



    public CronSchedule addMinutes(Integer mins) {
        Integer year = this.values[YEAR];
        Integer month = this.values[MONTH];
        Integer day = this.values[DAY_OF_MONTH];
        Integer hour = this.values[HOURS];
        Integer minute = this.values[MINUTES];
        Integer second = this.values[SECONDS];


        DateTime newTime = DateTime.newInstance(year, month, day, hour, minute, second);
        newTime = newTime.addMinutes(mins);

        return new CronSchedule(newTime);
    }

    public Integer getMinutes() {
        return this.values[MINUTES];
    }
    
    public Integer getHours() {
        return this.values[HOURS];
    }


    public override String toString() {

        // When day of month is specified DAY_OF_WEEK should be null.
        // If another value has been specified here then use it.
        String dayOfWeek = this.values[DAY_OF_WEEK] == null ? '?' : String.valueOf(this.values[DAY_OF_WEEK]);

        Object[] values = new Object[7];
        
        for(Integer x = 0; x< this.values.size(); x++) {
            values[x] = this.values[x];
        }   
        values[DAY_OF_WEEK] = dayOfWeek;

        return String.format('{0} {1} {2} {3} {4} {5} {6}', values);
    }
    
    
    /**
     * Validates that the CRON expression is properly formatted
     */
    public Boolean isValid() {
        // Basic validation - ensure all fields are present and not null
        if (values.size() != 7) {
            return false;
        }

        for (Integer i = 0; i < values.size(); i++) {
            if(i == DAY_OF_WEEK && values[i] == null) {
                continue; // Allow DAY_OF_WEEK to be null if DAY_OF_MONTH is specified
            }
            if (values[i] == null) {
                return false;
            }
        }

        
        return true;
    }
}