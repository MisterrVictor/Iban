@isTest
public class MockProvider implements System.StubProvider {
    private Map<String, Object> stubbedMethodMap;

    public MockProvider(Map<String, Object> stubbedMethodMap) {
        this.stubbedMethodMap = stubbedMethodMap;
    }

    public Object handleMethodCall(Object stubbedObject, String stubbedMethodName,
 Type returnType, List<Type> listOfParamTypes,
 List<String> listOfParamNames, List<Object> listOfArgs) {
        Object result;
        if (stubbedMethodMap.containsKey(stubbedMethodName)) {
            result = stubbedMethodMap.get(stubbedMethodName);
        }
        return result;
    }
}