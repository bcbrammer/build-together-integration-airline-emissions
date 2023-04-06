public interface TriggerHandler {
  void run(SObject newRecord, SObject oldRecord);
}