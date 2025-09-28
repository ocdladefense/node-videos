global interface IClickpdxHttpSendable {

    String getProtocol();
    
    String getDomain();

    String getEndpoint();

    Map<String,String> getParams();
    
    Map<String,String> setParams(Map<String,String> params);
    
    String formatResponse(HttpResponse resp);
}