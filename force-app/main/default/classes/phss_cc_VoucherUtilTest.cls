@isTest
public class phss_cc_VoucherUtilTest {

    private static Account testAccount;
    private static Opportunity testOpportunity;
    private static ccrz__E_CartItem__c testCartItem;
    private static ccrz__E_Product__c testProduct;
    private static redwing__ILT_Class__c testTrainingClass;
    private static Voucher__c testVoucher;
    private static Map<String, String> testClassCartItemMap;
    private static Map<String, String> testClassCourseMap;
    private static Map<String, Integer> testClassQuantityMap;
    private static Map<String, List<Voucher__c>> testClassVoucherMap;

    /**
     * @description Creates the test data associated for the contained test functions
     */
    private static void setupTestData() {
        Map<String, Object> testData = phss_cc_TestDataFactory.setupAccountAndProducts(1);
        testAccount = (Account) testData.get(phss_cc_TestDataFactory.TEST_ACCOUNT);

        List<ccrz__E_Product__c> products = (List<ccrz__E_Product__c>) testData.get(phss_cc_TestDataFactory.TEST_PRODUCTS);
        testProduct = products[0];

        testOpportunity = phss_cc_TestDataFactory.createInsertTestOpportunity(testAccount);

        List<ccrz__E_Cart__c> carts = phss_cc_TestDataFactory.createInsertCartAndCartItems(1, testData, testOpportunity.Id);
        ccrz__E_Cart__c cart = carts[0];
        List<ccrz__E_CartItem__c> cartItems = [SELECT Id FROM ccrz__E_CartItem__c WHERE ccrz__Cart__c = :cart.Id];
        testCartItem = cartItems[0];

        testData = phss_cc_TestDataFactory.createInsertTestLearningObjects();
        testTrainingClass = (redwing__ILT_Class__c) testData.get(phss_cc_TestDataFactory.TEST_ILT_CLASS);
        testVoucher = (Voucher__c) testData.get(phss_cc_TestDataFactory.TEST_VOUCHER);

        // build maps
        testClassQuantityMap = new Map<String, Integer>{ testTrainingClass.Id => 1 };
        testClassVoucherMap = new Map<String, List<Voucher__c>>{ testTrainingClass.Id => new List<Voucher__c>{ testVoucher } };
        testClassCourseMap = new Map<String, String>{ testTrainingClass.Id => testProduct.Id };
        testClassCartItemMap = new Map<String, String>{ testTrainingClass.Id => testCartItem.Id };
    }

    @IsTest
    public static void testReserveVouchersForCartItems() {
        setupTestData();

        Test.startTest();
        List<Voucher__c> result = phss_cc_VoucherUtil.reserveVouchersForCartItems(testClassVoucherMap, testClassCourseMap, testClassCartItemMap, testOpportunity.Id);
        Test.stopTest();

        System.assert(result != null);
        if (result != null) {
            System.assert(result.size() > 0);
            if (result.size() > 0) {
                System.assertEquals(testVoucher.Id, result[0].Id);
            }
        }
    }

    static testMethod void myUnitTest(){
        // Create community user record
        List<Profile> profList = [SELECT Id FROM Profile WHERE Name = 'SB PHSS-Partner-Community Plus Login' LIMIT 1];
        String profileId;

        profileId = profList[0].Id;

        String fileData = 'Name'+','+'LastName'+','+'Email'+','+'Phonenumber'+''+'test1'+','+'t'+','+'test1t@cfr.com'+','+'8888888888';
        String fileDateBase64 = EncodingUtil.base64Encode(Blob.valueOf(fileData));
        String mimetype = 'text/csv;base64,';
        String fileName = 'SampleTest.csv';
        String finalFileData = mimetype+fileDateBase64;


        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Bucket Account').getRecordTypeId();

        //Bucket Custom settings
        Bucket_Account_Settings__c bas = Bucket_Account_Settings__c.getOrgDefaults();
        bas.Bucket_Account_Owner_ID__c = UserInfo.getUserID();
        bas.Bucket_Account_RecordTypeID__c = recordTypeId;
        bas.Default_Bucket_Name__c = 'Bucket Account';
        bas.Maximum_Size_of_Bucket__c = 5000;
        insert bas;

        Profile profileIdnew = [SELECT Id FROM Profile WHERE Name = 'Customer Community User' LIMIT 1];


        Account a = new Account();
        a.Name='SalesforcetestOrg';
        a.BillingStreet='24 Willie Mays Plaza';
        a.BillingCity='San Francisco';
        a.BillingState='California';
        a.BillingPostalCode='94017';
        a.BillingCountry='USA';
        a.Phone='9934200234';
        //a.email='Salesforceredcross@cross.com';
        insert a;

        Contact c = new Contact();
        c.FirstName = 'New';
        c.LastName = 'Tetst';
        c.Email = 'Priyap@gmail.com';
        c.Account =a;
        insert c;

        Account acc = new Account();
        acc.Name = 'TestAccount';
        acc.BillingStreet = '24 Willie Mays Plaza kryan';
        acc.BillingCity = 'San Fran';
        acc.BillingState = 'Cali';
        acc.BillingPostalCode = '94018';
        acc.BillingCountry = 'US';
        acc.Phone = '9876543219';
        insert acc;

        Contact con = new Contact();
        con.FirstName = 'Contact';
        con.LastName = 'Test';
        con.Email = 'testCon@gmail.com';
        con.Account = acc;
        insert con;

        User usr = new User(LastName = 'LIVESTON',
                FirstName='JASON',
                Alias = 'jliv',
                Email = 'jason.liveston@asdf.com',
                Username = 'jason.liveston@asdf.com',
                ProfileId = profileIdnew.id,
                ContactId = c.id,
                TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LocaleSidKey = 'en_US'
        );
        insert usr;

        User partnerUser = new User(LastName = 'Test',
                FirstName = 'User',
                Alias = 'testU',
                Email = 'testCon@gmail.com',
                Username = 'testUser@redCross.com',
                ProfileId = profileId,
                ContactId = con.id,
                TimeZoneSidKey = 'GMT',
                LanguageLocaleKey = 'en_US',
                EmailEncodingKey = 'UTF-8',
                LocaleSidKey = 'en_US'
        );
        insert partnerUser;
        //Opportunity Creation
        List<BGST_Profiles__c> ProfilesLists = new List<BGST_Profiles__c>();
        BGST_Profiles__c indivl = new BGST_Profiles__c();
        indivl.name = 'Owner Profile';
        indivl.Sales_User__c = 'ARC BGST Sales User';
        ProfilesLists.add(indivl);
        insert ProfilesLists;

        //create an opportunity To fire the trigger on insert
        Opportunity opp1 = TestUtil.createOpportunity(a.Id, 'Interview', false);
        opp1.OwnerId = partnerUser.Id;
        opp1.Pricing_Approval_Level__c = Constants.APPROVAL_LEVEL_MOM;
        insert opp1;

        sked__Resource__c objResource = new sked__Resource__c();
        objResource.Name = 'Test';
        objResource.sked__Is_Active__c = true;
        objResource.sked__Resource_Type__c = 'Person';
        objResource.sked__Category__c = 'Instructor';
        objResource.sked__User__c = UserInfo.getUserId();
        insert objResource;

        redwing__Instructor__c objResource2 = new redwing__Instructor__c();
        objResource2.Skedulo_Is_Active__c = true;
        objResource2.Skedulo_Instructor__c  = objResource.id ;
        objResource2.redwing__User__c = usr.id;
        insert objResource2;

        redwing__Learning__c learning = new redwing__Learning__c();
        learning.Name = 'Test learning';
        learning.redwing__Published__c = true;
        learning.RecordTypeId = Schema.SObjectType.redwing__Learning__c.getRecordTypeInfosByName().get('ILT Event').getRecordTypeId();
        insert learning;

        redwing__Learning__c learning2 = new redwing__Learning__c();
        learning.Name = 'Test learning 2';
        learning.redwing__Published__c = true;
        learning.RecordTypeId = Schema.SObjectType.redwing__Learning__c.getRecordTypeInfosByName().get('ILT Event').getRecordTypeId();
        insert learning2;

        redwing__ILT_Event__c ilEvent = new redwing__ILT_Event__c();
        ilEvent.redwing__Learning__c = learning.Id;
        insert ilEvent;

        sked__Location__c objLocation = new sked__Location__c();

        objLocation.Name = 'Test';
        objLocation.sked__Type__c = 'Community';
        objLocation.sked__Address__c = '401 S Monroe St, Little Rock, AR, 72206';
        insert objLocation;

        redwing__Training_Plan__c lPlan = new redwing__Training_Plan__c();
        lPlan.Name = 'Test Plan';
        insert lPlan;

        redwing__Training_Plan_Section__c lPlanSection = new redwing__Training_Plan_Section__c();
        lPlanSection.Name = 'Test Plan Section';
        lPlanSection.redwing__Training_Plan__c = lPlan.Id;
        insert lPlanSection;

        redwing__Training_Plan_Section_Item__c lPlanSectionItem = new redwing__Training_Plan_Section_Item__c();
        lPlanSectionItem.redwing__Learning__c = learning.Id;
        lPlanSectionItem.redwing__Training_Plan_Section__c = lPlanSection.Id;
        insert lPlanSectionItem;

        sked__Region__c region = new sked__Region__c();
        region.Name = 'Test Region';
        region.sked__Timezone__c = 'Indian/Coscos';
        insert region;

        //Create ILT Class Record
        Redwing__ILT_Class__c clsRecord = new Redwing__ILT_Class__c();
        clsRecord.Skedulo_Account__c = a.id;
        clsRecord.redwing__End_Date__c = Date.Parse('12/19/2018');
        clsRecord.redwing__End_Time__c= '13:00';
        clsRecord.redwing__Start_Date__c = Date.Parse('12/19/2018');// Assuming Start date = End date
        clsRecord.redwing__Start_Time__c = '12:00';
        clsRecord.Name = 'Test';
        clsRecord.redwing__Learning__c = learning.Id;
        insert clsRecord;

        Voucher__c  v = new Voucher__c();
        v.ILT_Class__c = clsRecord.id;
        v.Learning_Plan__c = lPlan.Id;
        v.Status__c = 'Claimed';
        insert v;


        Map<String, List<Voucher__c>> mapClassIdQty = new Map<String, List<Voucher__c>>();
        Map<String, Integer> classIdQty = new Map<String, Integer>();
        classIdQty.put((String)clsRecord.Id, 5);
        mapClassIdQty = phss_cc_VoucherUtil.requestVouchersForClasses(classIdQty);

    }
}