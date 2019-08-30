public with sharing class FileUploadController {
 
 
    @AuraEnabled
    public static void saveChunk(String base64Data, String contentType)
	{
		
		base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        
        blob testBlob = EncodingUtil.base64Decode(base64Data);
        
        string csvData = testBlob.toString();
        
        system.debug('***csvData***'+csvData);
        
        List<String> rowList = csvData.split('\n');
        
        system.debug('***rowList***' +rowList);
 
        //return csvData;
		
				
    }
    
}