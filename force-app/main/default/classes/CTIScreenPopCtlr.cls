public with sharing class CTIScreenPopCtlr {    
    public PHSSModel.ConstituentDetail constituentDetail {get; set;}
    public Contact confirmContactProxy {get; set;}
    public String phone { get; set; }
    public String formattedPhone {get; set;}
    public PHSSModel.ConstituentSearchCriteria constituentSearchForm {get; set;}
    public PHSSModel.ConstituentSearchResultWrapper constituentSearchResultsWrapper {get; set;}    
    public List<PHSSModel.ConstituentSearchResult> constituentSearchResults {get; set;}
    public PHSSIntegrationService phssIntegrationService {get; set;}
    public Contact qcContactProxy {get; set;}
    public String pageTitle {get; set;}
    public String selectedConstituentId {get; set;}
    public String selectedContactId {get; set;}
    public String selectedManagedLearningFlag {get; set;}
    public Boolean showPhoneIcon {get; set;}
     
    @testVisible static List<Ghost_Call_Settings__c> ghostCallSettings {
        get {
            if (ghostCallSettings==null) {
                ghostCallSettings = new List<Ghost_Call_Settings__c>();
                for (Ghost_Call_Settings__c c : Ghost_Call_Settings__c.getAll().values())
                    ghostCallSettings.add(c);
            }
            return ghostCallSettings;
        } 
        set;
    }

    public void initConfirmContactInformation() {
        
        confirmContactProxy = new Contact();
        
        try{
            constituentDetail = phssIntegrationService.doConstituentDetails( selectedConstituentId ); 
            confirmContactProxy.firstName = constituentDetail.FirstName;     
	        confirmContactProxy.lastName = constituentDetail.LastName;     
	        confirmContactProxy.mailingStreet = constituentDetail.ARCBestAddressLine1;     
	        confirmContactProxy.mailingCity = constituentDetail.ARCBestCity;     
	        confirmContactProxy.mailingState = constituentDetail.ARCBestState ;     
	        confirmContactProxy.mailingPostalCode = constituentDetail.ARCBestZip ;     
	        confirmContactProxy.email = constituentDetail.ARCBestEmailAddress;
	        confirmContactProxy.phone = constituentDetail.ARCBestPhone;    
	        
        }catch(Exception e){
            ExLog.log(e);  // catch Exception Vinayak
        }
               
               
    }
    
    public PageReference Confirm() {
    	
        Contact newContact = new Contact();
        
        newContact.Master_Constituent_ID__c = constituentDetail.ConstituentId;
        newContact.firstName = confirmContactProxy.FirstName;
        newContact.lastName = confirmContactProxy.LastName;
        newContact.email = confirmContactProxy.email;
        newContact.phone = confirmContactProxy.Phone;
        newContact.mailingStreet = confirmContactProxy.mailingStreet;
        newContact.mailingCity = confirmContactProxy.mailingCity;
        newContact.mailingState = confirmContactProxy.mailingState;
        newContact.mailingPostalCode = confirmContactProxy.mailingPostalCode;
        newContact.email = confirmContactProxy.email;
        newContact.title = constituentDetail.Title ;    
        newContact.Saba_Person_Id__c = constituentDetail.SabaPersonId.left(20) ;
        if (constituentDetail.InstructorFlag == 'Yes') {
            newContact.Contact_Type__c = 'Instructor';
        }   
        try {
            Insert newContact;
        } catch(Exception ex) {
                ApexPages.addMessages(ex);  
                ExLog.log(ex); //  catch Exception Vinayak
                return null;  
        }

        PageReference pageRef = new PageReference('/' + newContact.id);

        return pageRef;
    }
    
    public pageReference cancelConfirmContactInformation() {
        PageReference pageRef = Page.CTIScreenPop;      
        return pageRef; 
    }
    
    public PageReference searchForPhone() {  
        
        try{
             if (phone != '' && phone != null ) {      
                constituentSearchResultsWrapper = phssIntegrationService.doPhoneSearch( formattedPhone ); 
                if (constituentSearchResultsWrapper != null) {
                    constituentSearchResults = constituentSearchResultsWrapper.constituentSearchResults;            
                } else {
                    ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'No matching customers were found...');
                    ApexPages.addMessage(msg);
                }
            }
        }catch(Exception e){
            ExLog.log(e); //  catch Exception Vinayak
        }
        return null;
    }

    // Throws GhostCallSettingException
    @testVisible static void setGhostCaseField(Case c, Ghost_Call_Settings__c gcs) { 
        Schema.SObjectField field = GlobalUtil.caseFields.get(gcs.Name);
        if (field != null) {
            Schema.SoapType ty = field.getDescribe().getSOAPType();
            c.put(gcs.Name, GlobalUtil.castValue(ty, gcs.Default_Field_Value__c));
        } else {
            throw new GhostCallSettingException('Invalid field ' + gcs.Name);
        }
    }

    public Boolean logSuccess {get;set;}
    @testVisible static final String ID_ERROR = 'Failed: Please double-check ID field default values in the Ghost_Call_Settings__c custom settings are all valid';
    @testVisible static final String FIELD_ERROR = 'Failed: Please double-check field names in the Ghost_Call_Settings__c custom settings are all valid';
    public PageReference logGhostCall() {  
        logSuccess=false;
        Case ghostCase = new Case();
        ghostCase.Phone_Number_of_Ghost_Call__c = constituentSearchForm.Phone;
        for (Ghost_Call_Settings__c gcs : ghostCallSettings) {
            try {
                setGhostCaseField(ghostCase, gcs);
            } catch (GhostCallSettingException e) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, FIELD_ERROR));
                return null;
            }
        }

        try {
            insert ghostCase;
            logSuccess=true;
            ghostCase = [SELECT Id, CaseNumber, Phone_Number_of_Ghost_Call__c FROM Case WHERE Id = :ghostCase.Id LIMIT 1];
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 
                'A ghost call case #' +ghostCase.CaseNumber+ ' was successfully logged for call with #'+ghostCase.Phone_Number_of_Ghost_Call__c));
        } catch (DmlException e) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ID_ERROR));
        }
        constituentSearchForm.phone = '';

        return null;
    }

    public class GhostCallSettingException extends System.Exception { }
    
    public PageReference searchForConstituent() {       
        // clear out old results
        constituentSearchResults.clear();
        if (constituentSearchForm.Phone != '') {
            constituentSearchForm.Phone = formatPhone(constituentSearchForm.phone);
        }
        // trim leading and trailing spaces from all search fields
        constituentSearchForm.City = constituentSearchForm.City.trim();
        constituentSearchForm.EmailAddress = constituentSearchForm.EmailAddress.trim();
        constituentSearchForm.FirstName = constituentSearchForm.FirstName.trim();
        constituentSearchForm.LastName = constituentSearchForm.LastName.trim();
        constituentSearchForm.State = constituentSearchForm.State.trim();
        constituentSearchForm.Zip = constituentSearchForm.Zip.trim();

        //DEBUG
        System.debug('*** STATE: ' + constituentSearchForm.State);
        System.debug('*** ZIP: ' + constituentSearchForm.Zip);
        System.debug('*** First Name: ' + constituentSearchForm.FirstName);
        System.debug('*** Last Name: ' + constituentSearchForm.LastName);
        System.debug('*** City: ' + constituentSearchForm.City);
        System.debug('*** Email: ' + constituentSearchForm.EmailAddress);   

        try{
            constituentSearchResultsWrapper = phssIntegrationService.doGeneralSearch( constituentSearchForm );      
            
            if (constituentSearchResultsWrapper != null) {
                constituentSearchResults = constituentSearchResultsWrapper.constituentSearchResults;
            } else {
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 'No matching customers were found...');
                ApexPages.addMessage(msg);
            }
        }catch(Exception e){
            ExLog.log(e); //  catch Exception Vinayak   
        }   
        return null;
    }

    public PageReference selectConstituent() {       
        PageReference redirectTo;     
        //try to find a match is SFDC
        Contact existingContact;
        Boolean isFound = false;
        // find contact in SFDC by Master Constituent Id
        if (selectedConstituentId != null) {
            try {
                existingContact = [Select id, name FROM contact WHERE master_constituent_id__c = :selectedConstituentId LIMIT 1];           
                if (existingContact != null) {
                    isFound = true;
                }
            } catch (Exception ex) {/*ExLog.log(ex);*/}  //  catch Exception Vinayak
        }
        // find by managed learning flag and contact id
        if ( !isFound ) {
            if ( selectedManagedLearningFlag == 'Yes' && selectedContactId != null ) {
                try {
                    existingContact = [Select id, name FROM contact  WHERE id = :selectedContactId LIMIT 1];                
                    if (existingContact != null) {
                        isFound = true;
                    }
                } catch(Exception ex) {/*ExLog.log(ex);*/}  //  catch Exception Vinayak    
            } 
        }
        if (isFound) {
            redirectTo = new PageReference('/'+ existingContact.id);
        } else {
            redirectTo = Page.ConfirmContactInformation;    
        }
        return redirectTo;  
    }



    public PageReference QuickCreateConstituent() {
        Contact newContact = new Contact();
        newContact.firstName = qcContactProxy.firstName;
        newContact.lastName = qcContactProxy.lastName;
        newContact.email = qcContactProxy.email;
        newContact.phone = qcContactProxy.phone;
        newContact.mailingStreet = qcContactProxy.mailingStreet;
        newContact.mailingPostalCode = qcContactProxy.mailingPostalCode;
        newContact.mailingCity = qcContactProxy.mailingCity;
        newContact.mailingState = qcContactProxy.mailingState;
        
        try {
            insert newContact;
        } catch (Exception ex) {
            ApexPages.addMessages(ex);
            ExLog.log(ex); 
            return null;
        }      
        PageReference contactPageRef = new PageReference('/' + newContact.id);
        contactPageRef.setRedirect(true);
        return contactPageRef;  
    }
 
    public CTIScreenPopCtlr() {
        phone  = ApexPages.currentPage().getParameters().get('ANI');    
        phssIntegrationService = new PHSSIntegrationService();
        constituentSearchResults = new List<PHSSModel.ConstituentSearchResult>();       
        qcContactProxy = new Contact();
        constituentSearchForm = new PHSSModel.ConstituentSearchCriteria();
        if (phone != '' && phone != null ) {  
            formattedPhone = formatPhone(phone);
            pageTitle = 'Caller\'s Phone Number';      
            showPhoneIcon = true;        
        } else {
            pageTitle = 'Search For A Customer';
            showPhoneIcon = false;
        }  
    }

    private String formatPhone(String phone) {
        // phone is passed in as numbers only and is pre-pended with '1' 
        String formattedPhone;
        // remove all non numbers
        phone = phone.replaceAll('\\D','');
        phone = phone.right(10);
        formattedPhone = '(' + phone.left(3) + ') ' + phone.mid(3, 3) + '-' + phone.right(4);
        return formattedPhone;
    }        
}