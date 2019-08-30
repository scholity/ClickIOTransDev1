/************************************************************************************************************************************
** Author: Salesforce Services
** Description: Tests for PHSS_PublishCertificates
************************************************************************************************************************************/

@IsTest
private class PHSS_PublishCertificatesTest {
    static testMethod void testPublishCertificates() {
        test.startTest();
        PHSS_PublishCertificates publisher = new PHSS_PublishCertificates();
        publisher.getAllCertificates();
        test.stopTest();

        System.assertEquals(true, publisher.exportAllCertificates);
    }
}