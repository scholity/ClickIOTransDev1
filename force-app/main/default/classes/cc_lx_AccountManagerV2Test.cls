@isTest
public class cc_lx_AccountManagerV2Test {

    public static User testUser1;
    public static User testUser2;
    public static Account testAccount;
    public static Contact testContact1;
    public static Contact testContact2;

    static void testSetup() {
        testAccount = createAccount('Test Account');
        testContact1 = createContact('User', 'One', cc_lx_AccountManagerV2Test.testAccount.Id);
        testContact2 = createContact('User', 'Two', cc_lx_AccountManagerV2Test.testAccount.Id);
        cc_lx_AccountManagerV2Test.testUser1 = createUser('test1@test.com', cc_lx_AccountManagerV2Test.testContact1, cc_lx_AccountManagerV2Test.testAccount, 'Customer Community User');
        cc_lx_AccountManagerV2Test.testUser2 = createUser('test2@test.com', cc_lx_AccountManagerV2Test.testContact2, cc_lx_AccountManagerV2Test.testAccount, 'Customer Community User');
    }

    public static Account createAccount(String name) {
        Account a = new Account(
            Name = name);
        insert a;
        return a;
    }

    public static Account getAccount(String name) {
        Account a = null;
        List<Account> accounts = [SELECT Id FROM Account WHERE Name = :name];
        if (!accounts.isEmpty()) {
            a = accounts[0];
        }
        return a;
    }

    public static Contact createContact(String firstName, String lastName, Id accountId) {
        Contact c = new Contact(FirstName = firstName, LastName = lastName, AccountId = accountId);
        insert c;
        return c;
    }

    public static Contract createContract(String name, Id accountId) {
        Contract c = new Contract(Name = name, StartDate = Date.today(), AccountId = accountId, Status = 'Draft');
        insert c;
        c.Status = 'Activated';
        update c;
        return c;
    }

    public static User createUser(String email, Contact c, Account a, String profileName) {
        Profile p = [Select p.Id from Profile p where p.Name = :profileName LIMIT 1];

        User u = new User(
            Alias = 'test',
            Email = email,
            LastName = c.LastName,
            FirstName = c.FirstName,
            ProfileId = p.Id,
            UserName = email,
            IsActive = true,
            Emailencodingkey = 'UTF-8',
            Languagelocalekey = 'en_US',
            Localesidkey = 'en_US',
            Timezonesidkey='America/Los_Angeles',
            ContactId = c.id);
        insert u;
        return u;
    }

    public static User getUser(String name) {
        User u = null;
        List<User> users = [SELECT Id, Name, ContactId, Contact.AccountId FROM User WHERE UserName = :name];
        if (!users.isEmpty()) {
            u = users[0];
        }
        return u;
    }

    static testmethod void getCurrentTest() {
      cc_lx_AccountManagerV2Test.testSetup();
      Id accountId = null;

      System.runAs(cc_lx_AccountManagerV2Test.testUser1) {
        Test.startTest();
        accountId = cc_lx_AccountManagerV2.getCurrentId();
        Test.stopTest();
      }

      System.assert(accountId != null);
      System.assertEquals(cc_lx_AccountManagerV2Test.testContact1.AccountId, accountId);
    }

    static testmethod void setContextTest() {
        cc_lx_AccountManagerV2Test.testSetup();

        String ctx = '{"portalUserId":"'+cc_lx_AccountManagerV2Test.testUser1.Id+'"}';

        Test.startTest();
        cc_lx_AccountManagerV2.setContext(ctx);
        Test.stopTest();

        System.assertEquals(cc_lx_AccountManagerV2Test.testUser1.Id, ccrz.cc_CallContext.currUserId);
    }

    static testmethod void getContractsForAccountTest() {
        cc_lx_AccountManagerV2Test.testSetup();
        Contract c1 = createContract('Test1', cc_lx_AccountManagerV2Test.testAccount.Id);
        Contract c2 = createContract('Test2', cc_lx_AccountManagerV2Test.testAccount.Id);
        Contract c3 = createContract('Test3', cc_lx_AccountManagerV2Test.testAccount.Id);

        List<Contract> contracts = null;

        Test.startTest();
        contracts = cc_lx_AccountManagerV2.getContractsForAccount(cc_lx_AccountManagerV2Test.testAccount.Id);
        Test.stopTest();

        System.assert(contracts != null);
        System.assertEquals(3, contracts.size());
    }

    static testmethod void getAccountAddressesTest() {
        cc_lx_AccountManagerV2Test.testSetup();
        Map<String, Object> addresses = null;

        Test.startTest();
        addresses = cc_lx_AccountManagerV2.getAccountAddresses(cc_lx_AccountManagerV2Test.testAccount.Id);
        Test.stopTest();

        System.assert(addresses != null);
    }

    static testmethod void getUserForIdTest() {
        cc_lx_AccountManagerV2Test.testSetup();
        List<User> users = null;

        Test.startTest();
        users = cc_lx_AccountManagerV2.getUserForId(cc_lx_AccountManagerV2Test.testUser1.Id);
        Test.stopTest();

        System.assert(users != null);
        System.assertEquals(1, users.size());
        System.assertEquals(cc_lx_AccountManagerV2Test.testUser1.Id, users[0].Id);
    }

    static testmethod void failGetCurrentId(){
        try{
            cc_lx_AccountManagerV2.API_VERSION = null;
            cc_lx_AccountManagerV2.getCurrentId();
            System.assert(false);
        }catch(Exception e){}
    }

}