/**
 * Created by jbarker on 2019-10-02.
 */

@RestResource(urlMapping='/ClassServices/processBatch')
global with sharing class PHSS_ClassBatchServices {

    @HttpPost
    global static String doPost() {
        return 'Hello, World!';
    }
}