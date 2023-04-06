public class AccountTriggerHandler implements TriggerHandler {
    public AccountTriggerHandler() {
        System.debug('Default Constructor');
    }
    public void run(SObject a, SObject aOld) {
		System.debug(a);
        a.addError('Account addError.');
    }
}