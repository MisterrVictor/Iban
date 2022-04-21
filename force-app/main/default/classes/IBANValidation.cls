public with sharing class IBANValidation {
    
    @AuraEnabled(cacheable=true)
    public static String ibanValidate(String ibanNumber){
        String result;
        if(ibanNumber != Null){
            ibanNumber = ibanNumber.trim().toUpperCase().replaceAll('(\\s+)', '');
            result = getIbanStatusCallout(ibanNumber);
        }else {
            result = 'Check IBAN number';
        }
        return result;
    }

    private static String getIbanStatusCallout(String ibanNumber){
        ibanNumber = ibanNumber.trim().toUpperCase().replaceAll('(\\s+)', '');
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://openiban.com/validate/' + ibanNumber + '?getBIC=true&validateBankCode=true';
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request); //System.debug(response.getBody());
        JSONParser parser = JSON.createParser(response.getBody());
        String result = '';
        while (parser.nextToken() != null) {
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) &&
                (parser.getText() == 'valid')) {
                    parser.nextToken();
                    result = parser.getText();
                }
        }
        result = (result == 'true') ? 'Valid' : 'Invalid';
        
        return result;
    }
}


//IBANValidation.ibanValidate('DE 89370400440532013000');
//Account acct1 = new Account(Name='Test Account1', IBAN__c = 'DE 89370400440532013000');
//Account acct2 = new Account(Name='Test Account2', IBAN__c = 'DE8937040044053201300');
//List <Account> a = new List <Account> {acct1, acct2};
//insert a;
/*
 // @future (callout=true)
    Public static void setIbanStatus(Set<Id> ibanIds){
        List<Account> accountsToUpdate = new List<Account>();
        List<Account> accts = [
            SELECT IBAN__c, IBAN_Status__c
            FROM Account
            WHERE Id IN :ibanIds];
        
        for(Account accounts : accts){
            accounts.IBAN_Status__c = 'In progress';//getIbanStatusCallout(accounts.IBAN__c);
            accountsToUpdate.add(accounts); 
        }
        update accountsToUpdate; 
    }
    
 */