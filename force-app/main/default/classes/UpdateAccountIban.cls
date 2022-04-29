public class UpdateAccountIban implements Queueable, Database.AllowsCallouts {
	@testVisible
    private static Boolean throwError = false;
    @testVisible
    private static Boolean circuitBreakerThrown = false;
    @testVisible
    private List<Account> accounts;

    public UpdateAccountIban(List<Account> triggerNewRecords) {
        this.accounts = triggerNewRecords;
    }

    public class UpdateAccountIbanException extends Exception {
    }

    public void execute(QueueableContext context) {

        List<Account> accountsToValidation = [
            SELECT Id, Name, IBAN__c, IBAN_Status__c
            FROM Account
            WHERE Id IN :accounts
        ];

        if (!throwError) {
            for (Account account : accountsToValidation) {
                String ibanNumber = account.IBAN__c;
                account.IBAN_Status__c = IBANValidation.ibanValidate(ibanNumber);
            }
        }
        if (Test.isRunningTest() && throwError) {
            for (Account account : accountsToValidation) {
                account.Name = '';
            }
        }

        try {
	        update  accountsToValidation;
        } catch (DmlException dmle) {
            System.debug(
                LoggingLevel.INFO,
                'real life use cases should do something more than just logging the error: ' +
                dmle.getMessage()
            );
            if (Test.isRunningTest()) {
                UpdateAccountIban.circuitBreakerThrown = true;
            }
        }
    }
}