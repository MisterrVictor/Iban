@isTest
public class IBANValidationTest {
    @isTest
    static void test_method_one() {
        String result;
        Test.startTest();
        Test.setMock(HttpCalloutMock.class, new IBANValidationCalloutMock());
        result = IBANValidation.getIbanStatusCallout('DE89370400440532013000');
        Test.stopTest();
        system.assertEquals('Valid', result);
    }
}