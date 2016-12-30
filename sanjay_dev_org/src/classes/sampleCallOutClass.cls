public class sampleCallOutClass{


    public static HttpResponse getInfoFromExternalService()
    {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('http://cookie.jsontest.com/');
        req.setMethod('GET');
        
        Http h = new Http();
        HttpResponse res = h.send(req);

        return res;
    
    }

}