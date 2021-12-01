global with sharing class UpdateRatingSchedule implements Schedulable {
  global void execute(SchedulableContext ctx) {
    Database.executeBatch(
      new BatchRatingTable(ContactCreator.GetEmptyRatingList()),
      2000
    );
  }
}
