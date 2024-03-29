@isTest
public class GeneratePDFHandlertest
{
    @isTest
    static void  GeneratePDFHandlertest()
    {
        GeneratePDFHandler classRef = new GeneratePDFHandler();
        
        //Cover Wrapper class
        GeneratePDFHandler.locationWrapper locWrapperRef = new GeneratePDFHandler.locationWrapper();
        locWrapperRef.city = null;
        locWrapperRef.address1 = null;
        locWrapperRef.country = null;
        locWrapperRef.province = null;
        locWrapperRef.postalCode = null;
        
        GeneratePDFHandler.ClassWrapper wrapperRef = new GeneratePDFHandler.ClassWrapper();
        wrapperRef.classId = null;
        wrapperRef.className = null;
        wrapperRef.classOfferingId = null;
        wrapperRef.lpName = null;
        wrapperRef.lplanId = null;
        wrapperRef.startDate = null;
        wrapperRef.endDate = null;
        wrapperRef.startTime = null;
        wrapperRef.endTime = null;
        wrapperRef.days = null;
        wrapperRef.instructorName = null;
        wrapperRef.company = null;
        wrapperRef.location = locWrapperRef;
        wrapperRef.classSettings = null;
        wrapperRef.status = null;
        wrapperRef.numberOfStudents = null;
        
        String xlsReturn = classRef.xlsHeader;
        
        //For XLS
        classRef.PDFData = '[{"accountName":"Jane Hunter","classId":"a315B000000xEWsQAM","className":"Lifeguarding","classOfferingId":"CLS-00002466","classOnlineFrom":"2019-09-24","classSettings":"Classroom","company":"Jane Hunter","createdByName":"Jane Hunter","createdDateandTime":"2019-09-25T06:20:13.000Z","days":1,"endDate":"2019-09-25","endTime":"09:30 AM","instructorName":"Jane Hunter","location":{"address1":"NY","city":"NY","postalCode":"56001","province":"NY"},"lplanId":"a3r5B000000AfWdQAK","lpName":"Lifeguarding","numberOfStudents":2,"orderNumber":"O-0000002130","requestType":"LTP/AP","startDate":"2019-09-25","startTime":"09:00 AM","status":"Reported"},{"accountName":"Jane Hunter","classId":"a315B000000xEWnQAM","className":"Lifeguarding","classOfferingId":"CLS-00002465","classOnlineFrom":"2019-09-24","classSettings":"Classroom","company":"Jane Hunter","createdByName":"Jane Hunter","createdDateandTime":"2019-09-25T06:01:21.000Z","days":1,"endDate":"2019-09-25","endTime":"07:00 AM","instructorName":"Jane Hunter","location":{"address1":"NY","city":"NY","postalCode":"56001","province":"NY"},"lplanId":"a3r5B000000AfWdQAK","lpName":"Lifeguarding","numberOfStudents":0,"orderNumber":"O-0000002129","requestType":"CPS","startDate":"2019-09-25","startTime":"06:15 AM","status":"Reported"},{"accountName":"Army West","classId":"a315B000000t3yPQAQ","className":"Lifeguarding","classOfferingId":"00001596","classOnlineFrom":"2019-03-05","classSettings":"Classroom","company":"Army West","createdByName":"Paul Munford","createdDateandTime":"2019-03-06T16:37:43.000Z","days":6,"endDate":"2019-11-08","endTime":"01:00 PM","instructorName":"Jane Hunter","location":{"address1":"","city":"","country":"","postalCode":"","province":""},"lplanId":"a3r5B000000AfWdQAK","lpName":"Lifeguarding","numberOfStudents":0,"requestType":"CPS","startDate":"2019-11-03","startTime":"12:00 PM","status":"Upcoming"},{"accountName":"Army West","classId":"a315B000000xE1LQAU","className":"Lifeguarding1","classOfferingId":"CLS-00002300","classOnlineFrom":"2019-03-05","classSettings":"Classroom","company":"Army West","createdByName":"Sudhir DakshinaMurthy","createdDateandTime":"2019-09-05T11:52:50.000Z","days":6,"endDate":"2019-11-08","endTime":"01:00 PM","instructorName":"Jane Hunter","location":{"address1":"","city":"","country":"","postalCode":"","province":""},"lplanId":"a3r5B00000068AsQAI","lpName":"Adult and Child CPR","numberOfStudents":0,"requestType":"LTP/AP","startDate":"2019-11-03","startTime":"12:00 PM","status":"Upcoming"}]]';
        classRef.downloadPDF();
        
        //For PDF Current
        classRef.Downloadtype = 'PDF';
        classRef.Classtype = 'Current';
        classRef.downloadPDF();
        
        //For PDF History
        classRef.Classtype = 'History';
        classRef.downloadPDF();
    }
}