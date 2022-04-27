public with sharing class IBANValidation {

    @AuraEnabled(cacheable=true)
    public static String ibanValidate(String ibanNumber){
        String result;
        String responseBody;
        if(ibanNumber != Null){
            ibanNumber = ibanNumber.trim().toUpperCase().replaceAll('(\\s+)', '');
            responseBody = getIbanStatusCallout(ibanNumber);
            result = getJSONParserResult(responseBody);
        }else {
            result = 'Check IBAN number';
        }
        return result;
    }

    @TestVisible
    private static String getIbanStatusCallout(String ibanNumber){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://openiban.com/validate/' + ibanNumber + '?getBIC=true&validateBankCode=true';
        request.setEndPoint(endpoint);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        return response.getBody();
    }

    @TestVisible
    private static String getJSONParserResult(String responseBody){
        JSONParser parser = JSON.createParser(responseBody);
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