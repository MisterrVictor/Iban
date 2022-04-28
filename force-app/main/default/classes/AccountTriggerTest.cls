@isTest
public class AccountTriggerTest{

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

    @isTest static void TestCreate200Records(){
        System.assertEquals(200, [SELECT Count()
                                  FROM Account
                                  WHERE Name Like 'Test Account%'
                                  AND IBAN__c = 'DE89370400440532013000'
                                 ]);
    }

    @isTest static void TestUpdate200Records(){
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
        List<Account> accountsToValidate = [SELECT Id, Name, IBAN__c FROM ACCOUNT WHERE Name like 'Test Account%'];
        AccountIbanTriggerHandler AccountHandler = new AccountIbanTriggerHandler();

        Test.startTest();
        //      AccountHandler.ibanValidate(accountsToValidate);
        Test.stopTest();
    }
}