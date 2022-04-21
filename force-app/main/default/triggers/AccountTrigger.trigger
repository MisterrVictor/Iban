trigger AccountTrigger on Account (before insert, before update, after insert, after update) {
    
    AccountIbanTriggerHandler AccountHandler = new AccountIbanTriggerHandler();
    
    if (Trigger.isAfter && Trigger.isInsert) {
        List<Account> accountsToValidate = new List<Account> ();
        for(Account account : Trigger.new){
            if(account.IBAN__c != null){
                accountsToValidate.add(account);
            }  
        }
        //A single Apex transaction can make a maximum of 100 callouts to an HTTP request or an API call.
        if(0 < accountsToValidate.size() && accountsToValidate.size() <= 100){
            AccountHandler.ibanValidate(accountsToValidate);
        }
    }
    
    if (Trigger.isAfter && Trigger.isUpdate) {  
        List<Account> accountsToValidate = new List<Account> ();
        for(Id accountId : Trigger.newMap.keySet()){
            if(Trigger.oldMap.get(accountId).IBAN__c != Trigger.newMap.get(accountId).IBAN__c){
                accountsToValidate.add(Trigger.newMap.get(accountId));
            }
        }
        //A single Apex transaction can make a maximum of 100 callouts to an HTTP request or an API call.
        if(0 < accountsToValidate.size() && accountsToValidate.size() <= 100){
            AccountHandler.ibanValidate(accountsToValidate);
        }
    }
    
}
/*
IBANValidation.ibanValidate('DE 89370400440532013000');

Account acct1 = new Account(Name='Account1', IBAN__c = 'DE 89370400440532013000');
Account acct2 = new Account(Name='Account2', IBAN__c = 'DE8937040044053201300');
Account acct3 = new Account(Name='Account3');
List <Account> a = new List <Account> { acct1, acct2, acct3};
insert a;

update [SELECT Id, Name FROM Account WHERE IBAN__c != NULL LIMIT 3];

delete [SELECT Id, Name FROM Account WHERE Name Like 'Account%'];
List<Account> accts = new List<Account>();
for(Integer i=0; i < 100; i++) {
Account acct = new Account(Name='Account' + i, IBAN__c = 'DE 89370400440532013000');
accts.add(acct);
}
insert accts;
*/
//A single Apex transaction can make a maximum of 100 callouts to an HTTP request or an API call.