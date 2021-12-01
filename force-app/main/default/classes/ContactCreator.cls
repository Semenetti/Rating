public with sharing class ContactCreator {
  public static Integer MAX_BACTH_LIMIT = 2000;
  public static Integer MAX_RATING = 100;

  public static void CreateContacts(Integer CONTACTS_TO_CREATE) {
    // on dev org max Data Storage limit is 5MB
    // One contact size is 2KB, so it's impractical to create more than 2000 contacts
    InsertContactsWithBatch(CONTACTS_TO_CREATE);
  }

  public static void InsertContactsWithBatch(Integer contactsAmount) {
    Integer MAX_BACTH_LIMIT = 2000;

    if (contactsAmount < MAX_BACTH_LIMIT && contactsAmount > 0) {
      MAX_BACTH_LIMIT = contactsAmount;
    }

    Id jobId = Database.executeBatch(
      new BatchProcessor(contactsAmount),
      MAX_BACTH_LIMIT
    );
    System.debug(
      [
        SELECT Id, Status, NumberOfErrors, TotalJobItems, JobItemsProcessed
        FROM AsyncApexJob
        WHERE id = :jobId
      ]
    );
  }

  public static void UpdateContactsRating() {
    List<Integer> ratingTable = new List<Integer>();
    Id jobId = Database.executeBatch(
      new BatchRatingTable(GetEmptyRatingList()),
      MAX_BACTH_LIMIT
    );
    System.debug(
      [
        SELECT Id, Status, NumberOfErrors, TotalJobItems, JobItemsProcessed
        FROM AsyncApexJob
        WHERE id = :jobId
      ]
    );
  }

  public static List<Integer> GetEmptyRatingList() {
    List<Integer> rating = new List<Integer>();
    for (Integer i = 0; i < MAX_RATING; i++) {
      rating.add(0);
    }
    return rating;
  }
}
