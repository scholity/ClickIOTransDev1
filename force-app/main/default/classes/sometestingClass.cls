/**
 * Created by bjarmolinski on 2019-05-31.
 */

global without sharing class sometestingClass {

    @AuraEnabled
    public static String selfRegister(String firstname, String lastname, String email, String password, String confirmPassword, String accountId, String regConfirmUrl, String extraFields, String startUrl, Boolean includePassword ) {
        System.debug('test method running');

//        String firstname = 'Bartosz';
//        String lastname = 'Testw3';
//        String email = 'ba030118+08@gmail.com';
//        String password = 'Pjtt20!4';
//        String confirmPassword = 'Pjtt20!4';
//        String accountId = null;
//        String regConfirmUrl = './CheckPasswordResetEmail';
//        String extraFields = null;
//        String startUrl = '/learner/setup/secur/RemoteAccessAuthorizationPage.apexp?source=CAAAAWsNEL0WME8wNUIwMDAwMDA0QzkzAAAA2ipIX2kZshCVkJ2BAhQ_m5SaJwAvfX6QYfgTScZIiBUPEjCAxlLD-8Cj67wL_Sc9Ae9ml4JaCHmYab6E29gyaZ58123-6ZSB9k7bO9jgTzPHkbv0wat8xg3SD9IivmYaSpYWXry0yU5Dd8NZXR-CrI3vQj0m6o5dQC0N0kjVFXG5HDSM_MSQ_EHfDivQG3G961MAImuCMHqOku-WLxgD6UVpLrzZzSB2jpCet6xw2LNaoij4sd1NHV81Gr1Lp9lPvEYUB7pJd7kpKrCjYujaFqP_TXrw0i0RXKWe1JLEbBWd0Jkhw6xwt4tN6rQiprjL8fHUM1uQnCMwVFobktfftt9VCdQfFE0IH99IMQv5nXxG0r6VQ8SCMbTik0iyq-CD1NzZ4NHteX1qJ-Ps3Bj6rRn_daIFBlb-muYXaHXut6YkzYjjW4rb0G4Zbd5vBl0Q1dwG0pubZ-nb6iLZVRPzpMbED6NJz7C8DYLwsYK1xAqSx1nLdFOUQOQrSulg30jRABIabGV_e-h5MHraYHWGQ96zImqkKx8HejIJxjRS_bPAHGPsOQ1fcY4jtY1JoAwPH8uzHYXkYJbzZDScy2mKso1_SKUxcb-rY2x3hiHMSHF2EKs4B6rvdHglZmXKPPV5HrQVcTGZiiiFnauWnGKWFNlF-q-ec9unMzRY4udZWWazk0cTtNwCDiZpgJvtFun01RgDoPsgIOc1N4Itt_-EXeqogtruOyQHKs31hOUPubRB1C89qfPL4OnozkdzIu1uaU1DMhhZgAYtEYGBOYsATpsbe0TlQlo_GicZGZyvGZRW2MOB1jtdGMMVSWiwY9totxIQ1xVN_9SpgdhyCBFRaEQ%3D';
//        Boolean includePassword = true;

        // Create new account and contact record to associate with the user record
        Profile learnerProfile = [SELECT Id, Name FROM Profile WHERE Name = 'Learner Community Profile' LIMIT 1];

        String sysAdminId = [Select id from user where UserRoleId != null and profile.Name = 'System Administrator' and isActive=true limit 1].Id;
        Account acc = new Account();
        acc.Name = firstname +' '+ lastname;
        acc.OwnerId = sysAdminId;
        acc.DM_External_Id__c = firstname + lastname + email;
        acc.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Individual Account').getRecordTypeId();
        insert acc;

        Contact con = new Contact();
        con.LastName = lastname;
        con.FirstName = firstname;
        con.Email = email;
        con.AccountId = acc.Id;
        con.DM_External_Id__c = firstname + lastname + email;
        insert con;

        User u = new User();
        u.Username = firstname + lastname + email;
        u.put('Email',email);

        u.FirstName = firstname;
        u.LastName = lastname;

        // Associate contact with the user record
        u.ContactId = con.Id;

        String networkId = Network.getNetworkId();

        // If using site to host the community the user should not hit s1 after logging in from mobile.
        if(networkId != null && siteAsContainerEnabled(Network.getLoginUrl(networkId))) {
            u.put('UserPreferencesHideS1BrowserUI',true);
        }

        String nickname = ((firstname != null && firstname.length() > 0) ? firstname.substring(0,1) : '' ) + lastname.substring(0,1);
        nickname += String.valueOf(Crypto.getRandomInteger()).substring(1,7);
        u.put('CommunityNickname', nickname);

        if (extraFields != null) {
            List<Object> extraFieldsList = (List<Object>) JSON.deserializeUntyped(extraFields);
            for (Object thisFieldObject : extraFieldsList) {
                Map<String,Object> thisField = (Map<String,Object>) thisFieldObject;
                Schema.SObjectField sof = Schema.SObjectType.User.fields.getMap().get((String) thisField.get('fieldPath'));
                u.put(sof, thisField.get('value'));
            }
        }

        if (includePassword) {
            if (!isValidPassword(password, confirmPassword)) {
                return Label.site.passwords_dont_match;
            }
            validatePassword(u, password, confirmPassword);
        }
        else {
            password = null;
        }

        // lastName is a required field on user, but if it isn't specified, we'll default it to the username
        String userId = Site.createPortalUser(u, acc.Id, password);

        // Assign permission set
        List<Id> userList = new List<Id>();
        userList.add(userId);

        if(!Test.isRunningTest()) {
            ILTInstructorCommunity.assignUserPermission(userList);
        }

        // create a fake userId for test.
        if (Test.isRunningTest()) {
            userId = 'fakeUserId';
        }
        if (userId != null) {
            if (password != null && password.length() > 1) {
                Network myNetwork = [SELECT Id FROM Network WHERE Name ='Red Cross Learning Center'];
                String loginUrl = Network.getLoginUrl(myNetwork.Id);

                ApexPages.PageReference lgn = Site.login(u.Username, password, startUrl);
                if(!Test.isRunningTest()) {
                    aura.redirect(lgn);
                }
            }
            else {
                ApexPages.PageReference confirmRef = new PageReference(regConfirmUrl);
                if(!Test.isRunningTest()) {
                    aura.redirect(confirmRef);
                }

            }
        }

        return 'Successful response';
    }

    @TestVisible
    private static boolean isValidPassword(String password, String confirmPassword) {
        return password == confirmPassword;
    }

    @TestVisible
    private static boolean siteAsContainerEnabled(String communityUrl) {
        Auth.AuthConfiguration authConfig = new Auth.AuthConfiguration(communityUrl,'');
        return authConfig.isCommunityUsingSiteAsContainer();
    }

    @TestVisible
    private static void validatePassword(User u, String password, String confirmPassword) {
        if(!Test.isRunningTest()) {
            Site.validatePassword(u, password, confirmPassword);
        }
        return;
    }
}