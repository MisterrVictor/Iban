public class AccountIbanTriggerHandler {

    public void ibanValidate(List<Account> accountsToValidate){
        UpdateAccountIban updateJob = new UpdateAccountIban(accountsToValidate);

       System.enqueueJob(updateJob);

    }
}
