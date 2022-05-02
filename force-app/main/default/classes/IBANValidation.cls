public with sharing class IBANValidation {

    @AuraEnabled(cacheable=true)
    public static String ibanValidate(String ibanNumber){
        String result;
        String responseBody;
        HttpResponse response;
        if(ibanNumber != Null){
            ibanNumber = ibanNumber.trim().toUpperCase().replaceAll('(\\s+)', '');
            responseBody = getIbanStatusCallout(ibanNumber);
            result = getJSONParserResult(responseBody);
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

    public static String getJSONParserResult(String responseBody){
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
