({
	inputCheck : function(component, helper) {
        console.log('running inputCheck in helper');
        var fields = new Array("First Name", "Last Name", "Email");
        var self = this;
        
        fields.forEach(function(item) {
            console.log(item);
            console.log(component);
            self.checkValidity(component, item);
        });
        this.checkPassword(component);
        console.log('validity check ran');
        
	},
    
    checkValidity : function(component, input1) {
        
        var input2 = input1;
        input1 = input1.replace(/\s/g, '').toLowerCase();
        
        console.log('validity check 1');
        console.log(component.find("firstname"));
        var fieldName = component.find(input1);
        var fieldNameValue = fieldName.get("v.value");
        console.log('fieldNameValue '+fieldNameValue);
        console.log('validity check 2');
        if(!fieldName || fieldNameValue.trim().length < 2) {
            fieldName.setCustomValidity('Please enter valid ' + input2);
            fieldName.reportValidity();
            component.set("v.valid", false);
        }
    },
    
    checkPassword: function(component) {
    	var passwd = component.find("passwd");
        var passwdvalue = passwd.get("v.value");
        var passwdconf = component.find("passwdconf");
        var passwdconfvalue = passwdconf.get("v.value");
        
        if (passwdvalue !== passwdconfvalue ) {
            passwdconf.setCustomValidity("Passwords don't match. Please try again.");
            passwdconf.reportValidity();
            component.set("v.valid", false);
        } else if (passwdvalue.length < 2) {
            passwd.setCustomValidity("Password does not meet criteria. Please try again.");
            passwd.reportValidity();
            component.set("v.valid", false);
        }
	},

	someTestMethod: function(component) {

	    var firstname = 'Bartosz';
        var lastname = 'Testw3';
        var email = 'ba030118+08@gmail.com';
        var password = 'Pjtt20!4';
        var confirmPassword = 'Pjtt20!4';
        var accountId = undefined;
        var regConfirmUrl = '/CheckPasswordResetEmail';
        var extraFields = undefined;
        var startUrl = '/learner/setup/secur/RemoteAccessAuthorizationPage.apexp?source=CAAAAWsNEL0WME8wNUIwMDAwMDA0QzkzAAAA2ipIX2kZshCVkJ2BAhQ_m5SaJwAvfX6QYfgTScZIiBUPEjCAxlLD-8Cj67wL_Sc9Ae9ml4JaCHmYab6E29gyaZ58123-6ZSB9k7bO9jgTzPHkbv0wat8xg3SD9IivmYaSpYWXry0yU5Dd8NZXR-CrI3vQj0m6o5dQC0N0kjVFXG5HDSM_MSQ_EHfDivQG3G961MAImuCMHqOku-WLxgD6UVpLrzZzSB2jpCet6xw2LNaoij4sd1NHV81Gr1Lp9lPvEYUB7pJd7kpKrCjYujaFqP_TXrw0i0RXKWe1JLEbBWd0Jkhw6xwt4tN6rQiprjL8fHUM1uQnCMwVFobktfftt9VCdQfFE0IH99IMQv5nXxG0r6VQ8SCMbTik0iyq-CD1NzZ4NHteX1qJ-Ps3Bj6rRn_daIFBlb-muYXaHXut6YkzYjjW4rb0G4Zbd5vBl0Q1dwG0pubZ-nb6iLZVRPzpMbED6NJz7C8DYLwsYK1xAqSx1nLdFOUQOQrSulg30jRABIabGV_e-h5MHraYHWGQ96zImqkKx8HejIJxjRS_bPAHGPsOQ1fcY4jtY1JoAwPH8uzHYXkYJbzZDScy2mKso1_SKUxcb-rY2x3hiHMSHF2EKs4B6rvdHglZmXKPPV5HrQVcTGZiiiFnauWnGKWFNlF-q-ec9unMzRY4udZWWazk0cTtNwCDiZpgJvtFun01RgDoPsgIOc1N4Itt_-EXeqogtruOyQHKs31hOUPubRB1C89qfPL4OnozkdzIu1uaU1DMhhZgAYtEYGBOYsATpsbe0TlQlo_GicZGZyvGZRW2MOB1jtdGMMVSWiwY9totxIQ1xVN_9SpgdhyCBFRaEQ%3D';
        var includePassword = true;

	    console.log('firstname '+firstname);
        console.log('lastname ' +lastname);
        console.log('email '+email);
        console.log('passwd '+password);
        console.log('conf passwd '+confirmPassword);
        console.log('accountId '+accountId);
        console.log('regConfirmUrl '+regConfirmUrl);
        console.log('startUrl' +startUrl);


	    var action = component.get("c.selfRegister");

	    action.setParams({firstname: firstname,
                                  lastname: lastname,
                                  email: email,
                                  password: password,
                                  confirmPassword: confirmPassword,
                                  accountId: accountId,
                                  regConfirmUrl: regConfirmUrl,
                                  extraFields: undefined,
                                  startUrl: startUrl,
                                  includePassword: includePassword});

	    action.setCallback(this, function(a) {
	        console.log('response status: '+a.getState());
	        console.log('error: ' + a.getError()[0].message);
            var rtnValue = a.getReturnValue();
            console.log('rtnValue '+rtnValue);
     });
     $A.enqueueAction(action);
    },
    
    selfRegister: function(component) {

        console.log('self register running');
//        var firstname = component.find("firstname").get("v.value");
//        var lastname = component.find("lastname").get("v.value");
//        var email = component.find("email").get("v.value");
//        var password = component.find("passwd").get("v.value");
//        var confirmPassword = component.find("passwdconf").get("v.value");
//        var accountId = null;
//        var regConfirmUrl = component.get("v.startUrl");
//        var extraFields = component.get("v.extraFields");
//        var startUrl = component.get("v.startUrl");
//        var includePassword = true;

        var firstname = 'Bartosz';
        var lastname = 'Testw3';
        var email = 'ba030118+08@gmail.com';
        var password = 'Pjtt20!4';
        var confirmPassword = 'Pjtt20!4';
        var accountId = undefined;
        var regConfirmUrl = './CheckPasswordResetEmail';
        var extraFields = [];
        var startUrl = '/learner/setup/secur/RemoteAccessAuthorizationPage.apexp?source=CAAAAWsNEL0WME8wNUIwMDAwMDA0QzkzAAAA2ipIX2kZshCVkJ2BAhQ_m5SaJwAvfX6QYfgTScZIiBUPEjCAxlLD-8Cj67wL_Sc9Ae9ml4JaCHmYab6E29gyaZ58123-6ZSB9k7bO9jgTzPHkbv0wat8xg3SD9IivmYaSpYWXry0yU5Dd8NZXR-CrI3vQj0m6o5dQC0N0kjVFXG5HDSM_MSQ_EHfDivQG3G961MAImuCMHqOku-WLxgD6UVpLrzZzSB2jpCet6xw2LNaoij4sd1NHV81Gr1Lp9lPvEYUB7pJd7kpKrCjYujaFqP_TXrw0i0RXKWe1JLEbBWd0Jkhw6xwt4tN6rQiprjL8fHUM1uQnCMwVFobktfftt9VCdQfFE0IH99IMQv5nXxG0r6VQ8SCMbTik0iyq-CD1NzZ4NHteX1qJ-Ps3Bj6rRn_daIFBlb-muYXaHXut6YkzYjjW4rb0G4Zbd5vBl0Q1dwG0pubZ-nb6iLZVRPzpMbED6NJz7C8DYLwsYK1xAqSx1nLdFOUQOQrSulg30jRABIabGV_e-h5MHraYHWGQ96zImqkKx8HejIJxjRS_bPAHGPsOQ1fcY4jtY1JoAwPH8uzHYXkYJbzZDScy2mKso1_SKUxcb-rY2x3hiHMSHF2EKs4B6rvdHglZmXKPPV5HrQVcTGZiiiFnauWnGKWFNlF-q-ec9unMzRY4udZWWazk0cTtNwCDiZpgJvtFun01RgDoPsgIOc1N4Itt_-EXeqogtruOyQHKs31hOUPubRB1C89qfPL4OnozkdzIu1uaU1DMhhZgAYtEYGBOYsATpsbe0TlQlo_GicZGZyvGZRW2MOB1jtdGMMVSWiwY9totxIQ1xVN_9SpgdhyCBFRaEQ%3D';
        var includePassword = true;

        console.log('firstname '+firstname);
        console.log('lastname ' +lastname);
        console.log('email '+email);
        console.log('passwd '+password);
        console.log('conf passwd '+confirmPassword);
        console.log('accountId '+accountId);
        console.log('regConfirmUrl '+regConfirmUrl);
        console.log('startUrl' +startUrl);


        startUrl = decodeURIComponent(startUrl);
        
        var action = component.get("c.selfRegister");
        action.setParams({firstname: firstname,
                          lastname: lastname,
                          email: email,
                          password: password,
                          confirmPassword: confirmPassword,
                          accountId: accountId,
                          regConfirmUrl: regConfirmUrl,
                          extraFields: extraFields,
                          startUrl: startUrl,
                          includePassword: includePassword});
        
        action.setCallback(this, function(a){
            console.log('action callback');
            var rtnValue = a.getReturnValue();
            console.log('return value '+ rtnValue);

            if (rtnValue !== null) {
                component.set("v.errorMessage",rtnValue);
                component.set("v.showError",true);
                console.log('rtnValue: '+rtnValue);
            }
        });
    	$A.enqueueAction(action);

    }
})