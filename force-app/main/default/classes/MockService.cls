public class MockService {
    private MockService() {}

    public static MockProvider getInstance(Map<String, Object> stubbedMethodMap) {
        return new MockProvider (stubbedMethodMap);
    }

    public static Object createMock(Type typeToMock, Map<String, Object> stubbedMethodMap) {
        return Test.createStub(typeToMock, MockService.getInstance(stubbedMethodMap));
    }
}