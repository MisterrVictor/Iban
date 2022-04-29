@isTest
public with sharing class UpdateAccountIbanTest {

    static List<Account> getTestAccounts(){
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 100; i++) {
            accounts.add(new Account(
                name='Test Account' + i,
                IBAN__c = 'DE8937040044053201300' + i
            ));
        }
        insert accounts;
        return accounts;
    }

    @isTest
    static void testUpdateAccountIbanPositive() {
      List<Account> accountsToValidate = getTestAccounts();
        Test.setMock(HttpCalloutMock.class, new IBANValidationCalloutMock());
        Test.startTest();
        UpdateAccountIban queueable = new UpdateAccountIban(accountsToValidate);
        System.enqueueJob(queueable);
        Test.stopTest();

        List<Account> checkAccounts = [SELECT IBAN_Status__c FROM Account WHERE Name like 'Test Account%'];
        System.debug('checkAccounts.size()' + checkAccounts.size());
        System.assert(
            checkAccounts.size() == 100,
            'Expected to find 100 accounts'
        );
        for (Account account : checkAccounts) {
           System.assert(
                account.IBAN_Status__c.containsIgnoreCase('Valid'),
                'Expected to find all accounts\'s to have been edited to include edited by queueable class'
            );
        }
    }

    @isTest
    static void testUpdateAccountIbanNegativeDMLError() {
		List<Account> accountsToValidate = getTestAccounts(); //[SELECT Name, IBAN__c FROM Account WHERE Name like 'Test Account%'];
		UpdateAccountIban.throwError = true;

        Id enqueuedJobId;
        UpdateAccountIban queueable = new UpdateAccountIban(accountsToValidate);
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IBANValidationCalloutMock());
        enqueuedJobId = System.enqueueJob(queueable);
        Test.stopTest();

        System.assert(UpdateAccountIban.circuitBreakerThrown,
            'Expected the test code to have tripped the circuit breaker'
        );
    }

}