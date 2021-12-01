public with sharing class BatchRatingTable implements Database.Batchable<sObject> {
  final Integer MIN_RATING = 1;
  final Integer MAX_RATING = 100;

  List<integer> ratingTable;

  public BatchRatingTable(List<integer> rating) {
    this.ratingTable = rating;
  }

  public Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(
      'select id, rating__c, place__c from contact'
    );
  }

  public void execute(Database.BatchableContext BC, List<Contact> scope) {
    // input rating values into table with
    for (Contact c : scope) {
      if (c.rating__c >= MIN_RATING && c.rating__c <= MAX_RATING) {
        Integer contactRatingPositionInArray = c.rating__c.intValue() - 1;

        ratingTable.set(
          contactRatingPositionInArray,
          ratingTable.get(contactRatingPositionInArray) + 1
        );
      }
    }

    // calculate and update place__c
    for (Contact con : scope) {
      Integer contactsWithBetterRating = 0;
      if (con.Rating__c >= MIN_RATING && con.Rating__c <= MAX_RATING) {
        Integer currentContactRating = con.Rating__c.intValue();
        if (currentContactRating == 1) {
          con.place__c = '1 - ' + ratingTable.get(0);
        } else {
          for (Integer i = 0; i < currentContactRating - 1; i++) {
            contactsWithBetterRating += ratingTable.get(i);
          }
          con.place__c =
            String.valueOf(contactsWithBetterRating + 1) +
            ' - ' +
            String.valueOf(
              contactsWithBetterRating +
              ratingTable.get(currentContactRating - 1)
            );
        }
      }
    }
    update scope;
  }

  public void finish(Database.BatchableContext BC) {
  }
}
