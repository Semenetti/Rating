public class BatchDeleteContacts implements Database.Batchable<sObject> {
  public Database.QueryLocator start(Database.BatchableContext BC) {
    return Database.getQueryLocator(
      'select name from contact where name like \'contact%\''
    );
  }

  public void execute(Database.BatchableContext BC, List<sObject> scope) {
    delete scope;
  }

  public void finish(Database.BatchableContext BC) {
  }
}
