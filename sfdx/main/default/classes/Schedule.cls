global without sharing virtual class Schedule implements Schedulable {

    // String representing the name of this schedule/job.
    private String jobName = null;

    // Number of minutes between job executions.
    private Integer intervalMinutes = 30;

    public static final Integer INTERVAL = 30;

    // Algorithm to be used to determine whether this job should run again.
	global String lastMd5 = null;

	// global Integer runCount = 0;

    // Name of this scheduled job.
	global String scheduleName = 'QBEmail';




    public Schedule() {}

    

    public void setInterval(Integer intervalMinutes) {
        this.intervalMinutes = intervalMinutes;
    }


    public void setJobName(String jobName) {
        this.jobName = jobName;
    }


	global virtual void execute(SchedulableContext sc) {
		DateTime dt = DateTime.now();
		// ReportAttachment job = new ReportAttachment('00OVJ000001KcJt', dt.toString());

		// Set the hash stored from the previous run.
		// This will be used in the next run to determine if the report has changed
		// (and therefore, if the report needs to be sent again to QB).
		// job.setLastMd5(this.lastMd5);

		// Make the job aware of its related job ID.
		// This is so it can cancel this one and schedule the next one
		// job.setRelatedJobId(sc.getTriggerId());
		
		// System.enqueueJob(job);
	}



    public Id requestNextSchedule(String sn) {
		CronSchedule now = CronSchedule.now();
		CronSchedule next = now.addMinutes(INTERVAL);

        return System.schedule(sn, next.toString(), this);
    }
}