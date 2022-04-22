public class UpdateAccountIban implements Queueable, Database.AllowsCallouts {
    private List<Account> accounts;
    
    public UpdateAccountIban(List<Account> triggerNewRecords) {
        this.accounts = triggerNewRecords;
    }
    
    List<Account> accountsToUpdate = new List<Account>();
    
    public void execute(QueueableContext context) {
        utilityIban.recurssion = true;
        List<Account> accountsToValidation = [
            SELECT Id, Name, IBAN__c, IBAN_Status__c
            FROM Account
            WHERE Id IN :accounts];
        
        for (Account account : accountsToValidation) {
            String ibanNumber = account.IBAN__c;
            account.IBAN_Status__c = IBANValidation.ibanValidate(ibanNumber);
            accountsToUpdate.add(account);
        }
        System.debug('accountsToUdate ' + accountsToUpdate.size());
        update accountsToUpdate;
    }
}