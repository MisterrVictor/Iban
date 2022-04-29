@isTest
public class AccountTriggerTest{

        static List<Account> getTestAccounts(){
        List<Account> accounts = new List<Account>();
        for (Integer i = 0; i < 100; i++) {
            accounts.add(new Account(
                name='Testing Account' + i,
                IBAN__c = 'DE89370400440532013000' + i
            ));
        }
        insert accounts;
        return accounts;
    }

    @testSetup
    static void setup() {
        List<Account> accounts = new List<Account>();
        for(Integer i=0; i < 200; i++) {
            Account acct = new Account(
                Name='Test Account' + i,
                IBAN__c = 'DE89370400440532013000'
            );
            accounts.add(acct);
        }
        insert accounts;
    }

    @isTest static void TestCreateRecords(){
        System.assertEquals(200, [SELECT Count()
                                  FROM Account
                                  WHERE Name Like 'Test Account%'
                                  AND IBAN__c = 'DE89370400440532013000'
                                 ]);
    }

    @isTest static void TestUpdateRecords(){
        List<Account> accounts = [SELECT IBAN__c
                                  FROM ACCOUNT
                                  WHERE Name like 'Test Account%'
                                 ];
        List<Account> accountsToUpdate = new List<Account>();
        for(Account a : accounts){
            a.IBAN__c = 'de 8937 0400 4405 3201 3000';
            accountsToUpdate.add(a);
        }
        update accountsToUpdate;
        System.assertEquals(200, [SELECT Count()
                                  FROM Account
                                  WHERE Name Like 'Test Account%'
                                  AND IBAN__c = 'de 8937 0400 4405 3201 3000'
                                 ]);
    }

    @isTest static void testQueueable(){
        List<Account> accountsToValidate = getTestAccounts();
        Test.setMock(HttpCalloutMock.class, new IBANValidationCalloutMock());
        Test.startTest();
        AccountIbanTriggerHandler AccountHandler = new AccountIbanTriggerHandler();
        AccountHandler.ibanValidate(accountsToValidate);
        Test.stopTest();

        List<Account> checkAccounts = [SELECT IBAN_Status__c FROM Account WHERE Name like 'Testing Account%'];
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
}