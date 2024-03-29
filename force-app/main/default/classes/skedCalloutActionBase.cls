public abstract class skedCalloutActionBase {
    
    /*public skedCalloutResultBase execute(string endPoint, string httpMethod, Map<string, string> mapHeader, Map<string, string> mapParam) {
        List<string> params = new List<string>();
        for (string paramKey : mapParam.keySet()) {
            string paramValue = mapParam.get(paramKey);
            params.add(paramKey + '=' + EncodingUtil.urlEncode(paramValue, 'UTF-8'));
        }
        string body;
        if (!params.isEmpty()) {
            body = string.join(params, '&');
        }
        return execute(endPoint, httpMethod, mapHeader, body);
    }*/
    
    public skedCalloutResultBase execute(string endPoint, string httpMethod, Map<string, string> mapHeader, string body) {
        beforeExecute();
        skedCalloutResultBase result = doExecute(endPoint, httpMethod, mapHeader, body);
        afterExecute();
        
        return result;
    }
    
    protected virtual void beforeExecute() {
        
    }
    
    protected virtual void afterExecute() {
        
    }
    
    protected virtual skedCalloutResultBase initializeResult() {
        return new skedCalloutResultBase();
    }
	
    protected virtual skedCalloutResultBase doExecute(string endPoint, string httpMethod, Map<string, string> mapHeader, string body) {
        skedCalloutResultBase result = initializeResult();
        
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endPoint);
        if (!string.isBlank(body)) {
            req.setBody(body);
        }
        else {
            req.setHeader('Content-length', '0');
        }
        
        if (httpMethod == 'PATCH') {
            req.setHeader('X-HTTP-Method-Override', 'PATCH');
        }
        for (string headerKey : mapHeader.keySet()) {
            string headerValue = mapHeader.get(headerKey);
            req.setHeader(headerKey, headerValue);
        }
        
        httpMethod = httpMethod == 'PATCH' ? 'POST' : httpMethod;
        req.setMethod(httpMethod);
        req.setTimeout(60000);
        
        Http h = new Http();
        HttpResponse res = h.send(req);
        
        result.response = res.getBody();
        result.status = res.getStatus();
        result.statusCode = res.getStatusCode();
        
        if (result.statusCode >= 400) {
            throw new skedCalloutException(result.statusCode, result.status, result.response);
        }
        else {
            result = processResponse(result.response);
        }
        
        return result;
    }
    
    protected virtual skedCalloutResultBase processResponse(string response) {
        return null;
    }
    
}