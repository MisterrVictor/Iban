@isTest
public with sharing class UpdateAccountIbanTest {

    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();

        for (Integer i = 0; i < 2; i++) {
            accounts.add(new Account(
                name='Test Account'+i,
                IBAN__c = 'DE8937040044053201300'+i
            ));
        }
        insert accounts;
    }

        static testmethod void testQueueable() {
            List<Account> accountsToValidate = [SELECT Id, Name, IBAN__c FROM ACCOUNT WHERE Name like 'Test Account%'];

            UpdateAccountIban testedClass = new UpdateAccountIban(accountsToValidate);

            testedClass.ibanValidationData = (IBANValidation) MockService.createMock
                (IBANValidation.class, new Map<String, Object>{
                'ibanValidate' => accountsToValidate //getAccountsForGivenIds - ibanValidate
                });

            Test.startTest();
            System.enqueueJob(testedClass.ibanValidationData);
            Test.stopTest();

            //System.assertEquals(3, [SELECT count() FROM ACCOUNT WHERE IBAN__c like 'DE8937040044053201300%']);
        }
}
