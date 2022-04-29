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
