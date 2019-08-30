/*
    Test CC_PHSS_hk_Payment class
*/
@isTest(SeeAllData=false)
public class CC_PHSS_hk_PaymentTest {
    @testSetup
    static void testSetup() {

        Map<String,Map<String,Object>> testData = new Map<String,Map<String,Object>>{
            ccrz.ccApiTestData.SERVICE_SETTINGS => new Map<String,Object>{
                'DefaultStore' => new Map<String,Object>{
                    'cc_hk_Payment.HK_ID' => 'c.CC_PHSS_hk_Payment'
                }
            }
        };
        ccrz.ccApiTestData.setupData(testData);

        //ccrz.cc_util_Reflection.createStorefrontSetting('DefaultStore');
    }
    
    static testmethod void createFetchTest() {
        Map<String, Object> inputData = new Map<String,Object> {
            ccrz.ccApi.API_VERSION => 5,
            ccrz.ccAPIStoredPayment.STOREDPAYMENTSLIST => new List<Map<String, Object>> {
                new Map<String,Object> {
                    'accountNumber' => 'po123',
                    'accountType' => 'po',
                    'enabled' => true
                }
            }
        };
        
        
    }
}