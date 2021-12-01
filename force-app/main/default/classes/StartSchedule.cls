public with sharing class StartSchedule {
  public static void start() {
    // UpdateRatingSchedule deleteOldToDos = new UpdateRatingSchedule();
    UpdateRatingSchedule updateRating = new UpdateRatingSchedule();
    // Every day at 1 AM (01:00)
    String sch = '0 0 1 * * ?';
    String jobID = System.schedule('Update Contact Rating', sch, updateRating);

    CronTrigger ct = [
      SELECT TimesTriggered, NextFireTime, State, TimeZoneSidKey
      FROM CronTrigger
      WHERE Id = :jobID
    ];
  }
}
