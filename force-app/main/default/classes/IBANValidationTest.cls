@isTest
public class IBANValidationTest {
    @isTest
    static void test_method_one() {
        String result;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IBANValidationCalloutMock());
        result = IBANValidation.ibanValidate('de 8937 0400 4405 3201 3000');
        Test.stopTest();
        System.assertEquals('Valid', result);
    }
    @isTest
    static void test_method_two() {
        String result;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IBANValidationCalloutMock_setBodyfalse());
        result = IBANValidation.ibanValidate('de 8937 0400 4405 3201 300');
        Test.stopTest();
        System.assertEquals('Invalid', result);
    }
    @isTest
    static void test_method_three() {
        String result;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IBANValidationCalloutMock());
        result = IBANValidation.getIbanStatusCallout('DE89370400440532013000');
        Test.stopTest();
        System.assertEquals('{"valid": true}', result);
    }
}

/*
IBANValidationCalloutMock mock = new IBANValidationCalloutMock(200, 'OK', 'Valid', new Map<String,String>());
    Test.setMock(HttpCalloutMock.class, mock);
    String result;
    Test.startTest();
    result = IBANValidation.getIbanStatusCallout('DE 89370400440532013000');
    Test.stopTest();
    system.assertEquals('Valid', result);

*/