global class BatchProcessor implements Database.batchable<SObject> {
  final Integer MAX_DML_LIMIT = 10000;
  Integer contactsAmount;

  global BatchProcessor(integer contactsAmount) {
    this.contactsAmount = contactsAmount;
  }

  global Iterable<SObject> start(Database.BatchableContext bc) {
    final Integer MAX_RANDOM_VALUE = 100;
    List<Contact> contacts = new List<Contact>();

    for (integer i = 0; i < contactsAmount; i++) {
      Integer randomNumber = Integer.valueof(
        (Math.random() * MAX_RANDOM_VALUE) + 1
      );
      String randomize = i + '_' + randomNumber; // to avoid DuplicateRecordIds

      Contact c = new Contact(
        LastName = 'Contact_' + randomize,
        Email = 'test' + randomize + '@salesforce.com',
        Rating__c = randomNumber
      );
      contacts.add(c);
    }
    BatchSObjectFeeder bf = new BatchSObjectFeeder(contacts);
    return bf;
  }

  global void execute(Database.BatchableContext bc, SObject[] scope) {
    insert scope;
  }

  global void finish(Database.BatchableContext bc) {
    contactsAmount -= MAX_DML_LIMIT;
    Integer MAX_BACTH_LIMIT = 2000;

    if (contactsAmount < MAX_BACTH_LIMIT && contactsAmount > 0) {
      MAX_BACTH_LIMIT = contactsAmount;
    }

    if (contactsAmount > 0) {
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
  }
}
