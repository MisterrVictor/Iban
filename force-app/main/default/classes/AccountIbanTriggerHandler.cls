public class AccountIbanTriggerHandler {

    public void ibanValidate(List<Account> accountsToValidate){
        UpdateAccountIban updateJob = new UpdateAccountIban(accountsToValidate);

       System.enqueueJob(updateJob);

    }

}





/*
// enqueue the job for processing
ID jobID = System.enqueueJob(updateJob);
List<AsyncApexJob> async = [
            SELECT Id, Status, NumberOfErrors
            FROM AsyncApexJob
            WHERE Id = :jobId
        ];
        System.debug('async ' + async);
*/

// String ibanNum = 'DE 89370400440532013000';
// IBANValidation.ibanValidate('DE 89370400440532013000');

// Account acct1 = new Account(Name='Test Account1', IBAN__c = 'DE 89370400440532013000');
//Account acct2 = new Account(Name='Test Account2', IBAN__c = 'DE8937040044053201300');
//List <Account> a = new List <Account> {acct1, acct2};
//insert a;
/*
Set<Id> ibanIds = new Set<Id>();
List<Account> accountsToUpdate = new List<Account>();
List<String> accountIbanNumbers = new List <String>();

public void beforeIbanInsert(List<Account> triggerNew)
{
for(Account account : triggerNew){
//account.IBAN_Status__c = 'In progress';
}
}
*/