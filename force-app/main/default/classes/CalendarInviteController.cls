public class CalendarInviteController {

    public String getLocation() {
        return location;
    }


    public String getSummary() {
        return summary;
    }


    public String getEndDate() {
        return endDate;
    }
    public String getStartDate() {
        return startDate;
    }

    private final String startDate;
    private final String endDate;
    private final String summary;
    private final String location;

    public CalendarInviteController(){
       // ApexPages.currentPage().getHeaders().put('content-disposition','inline; filename=calendarEvent.ics');

        startDate = ApexPages.currentPage().getParameters().get('startDate');
        endDate = ApexPages.currentPage().getParameters().get('endDate');
        summary = ApexPages.currentPage().getParameters().get('summary');
        location = ApexPages.currentPage().getParameters().get('location');
    }
}