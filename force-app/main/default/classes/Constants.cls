public with sharing class Constants {
    /*This class stores constants used by the OpportunityManagement and OpportunityLineManagement classes*/
    public static final String APPROVAL_LEVEL_MOM = 'MOM';
    public static final String APPROVAL_LEVEL_EXECUTIVE_DIRECTOR = 'Executive Director';
    public static final String APPROVAL_LEVEL_SALES_DIRECTOR = 'Sales Director';
    public static final String APPROVAL_LEVEL_MANAGER = 'Manager';
    public static final String NO_APPROVAL_NEEDED = 'No Approval Needed';
    public static final String APPROVED = 'Approved';
    public static final String BGST_Profile = 'ARC BGST Sales User';

/** Appinium specific constants below - will migrate to separate class **/

    public static final Id USER_ID              = UserInfo.getUserId();

    public static final String ANSWER_STATUS_SUCCESS        = 'SUCCESS';
    public static final String ANSWER_STATUS_ACCESS_DENIED  = 'ACCESS DENIED';
    public static final String ANSWER_STATUS_ERROR          = 'ERROR';

    public static final String STATUS_UPCOMING     = System.Label.Upcoming;
    public static final String STATUS_IN_PROGRESS  = System.Label.In_Progress;
    public static final String STATUS_COMPLETED    = System.Label.Completed;
    public static final String STATUS_CANCELLED    = System.Label.Cancelled;
    public static final String STATUS_NOT_STARTED  = System.Label.Not_Started;

    public static final String APINAME_FIELD_ORGANIZATION = 'Skedulo_Account__r.Name';
    public static final String APINAME_FIELD_CLASSSETTINGS = 'Classroom_Setting__c';


    // For detecting UI context
    public static final Map<String, String> THEME_TYPES = new Map<String, String>{
        'Obsolete'          => 'Theme1',
        'Classic2005'       => 'Theme2',
        'Classic2010'       => 'Theme3',
        'Experience'        => 'Theme4d',
        'Salesforce1'       => 'Theme4t',
        'CustomerPortal'    => 'PortalDefault',
        'AppExchange'       => 'Webstore'
    };
    public static final Boolean IS_EXPERIENCE   = (UserInfo.getUITheme() == THEME_TYPES.get('Experience'));
}