Public class SendCalendarInvite{

public PageReference sendInvite() {
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = new String[] {'oakram@altimetrik.com'};
        toAddresses.add('priti.patil3825@altimetrik.com');
        String classId = 'a315B0000005tow';
        mail.setToAddresses(toAddresses);
        mail.setSubject('Enrollment to Class confirmation');
       // mail.setPlainTextBody('');
        List<redwing__ILT_Class__c>  redwingClassList = [Select id,redwing__End_Date__c,redwing__End_Time__c,redwing__Start_Date__c,redwing__Start_Time__c,redwing__Timezone__c  from redwing__ILT_Class__c where id=:classId ];
        system.debug('class record -->>>'+redwingClassList[0]);
        String endDate = String.valueOf(redwingClassList[0].redwing__End_Date__c);
        endDate = endDate.mid(0,10);
        endDate = endDate.remove('-');
        String endTime = String.valueOf(redwingClassList[0].redwing__End_Time__c);
        endTime = endTime.remove(':');
        endTime = 'T'+endTime +'00Z';
        String startDate = String.valueOf(redwingClassList[0].redwing__Start_Date__c);
        startDate = startDate.mid(0,10);
        startDate = startDate.remove('-');
        String subject = 'Class enrollment confirmation!';
        String location = 'GoTo Meeting';
        String details ='Details to be shared on the day of commencement of class';
        String startTime = String.valueOf(redwingClassList[0].redwing__Start_Time__c);
        startTime = startTime.remove(':');
        startTime = 'T'+startTime +'00Z';
        system.debug('startdate --'+startDate+'--starttime--'+startTime+'--endDate--'+endDate+'---endtime --'+endTime);
        //String htmlBody = 'Enrollment to class has been confirmed!<br/> Please add the event to your calendar.<br/><form><input type="button" onclick="parent.open(' + '\'http://www.google.com/calendar/event?action=TEMPLATE&dates=20181106T063200Z%2F20181106T073200Z&text=ArcheryClass&location=Communitty%20stadium&details=To%20be%20shared\')"  value="Add event" /></form>';
        //String htmlBody = '<html><body>Enrollment to class has been confirmed!<br/> Please add the event to your calendar.<br/><form><input type="button" onclick="parent.open(' + '\'http://www.google.com/calendar/event?action=TEMPLATE&dates='+startDate+startTime+'%2F'+endDate+endTime+'&text='+subject+'&location='+location+'&details='+details+'\')"  value="Add event" /></form></body></html>';
        String htmlBody = '<html><body>Enrollment to class has been confirmed!.Please add the event to your calendar.<br/><a href="http://www.google.com/calendar/event?action=TEMPLATE&dates='+startDate+startTime+'%2F'+endDate+endTime+'&text='+subject+'&location='+location+'&details='+details+'" target="_blank">Add event to calendar</a></body></html>';
        mail.setHtmlBody(htmlBody);
        /*Messaging.EmailFileAttachment attach = new Messaging.EmailFileAttachment();
        attach.filename = 'calendarEvent.ics';
        attach.ContentType = 'text/calendar;';
        attach.inline = true;
        PageReference invite = Page.CalendarInvite;
        
        invite.getParameters().put('location', 'Pune');
        invite.getParameters().put('summary', 'Test summary');
        invite.getParameters().put('endDate', System.Today().format());
        invite.getParameters().put('startDate', System.Today().format());
        
        attach.body = invite.getContent();
        mail.setFileAttachments(new Messaging.EmailFileAttachment[] {attach});*/
        
        Messaging.SendEmailResult[] er = Messaging.sendEmail(new Messaging.Email[] {mail});
        return null;
    }

}