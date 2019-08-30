(function(w){
    "use strict"; 
	
    var utilMethods = {
        "printDiv":printDiv
    };

    function printDiv() {


document.getElementById('printing-frame').contentDocument.getElementsByTagName("BODY")[0].innerHTML = "";
document.getElementById('printing-frame').contentDocument.getElementsByTagName("BODY")[0].innerHTML = "TEST";

/*
var divElements = document.getElementById("testprint").innerHTML;
console.log(divElements);

//Get the HTML of whole page
var oldPage = document.body.innerHTML;
console.log(oldPage);

//Reset the pages HTML with divs HTML only

     document.body.innerHTML = 

     "<html><head><title></title></head><body>" + 
     divElements + "</body>";



//Print Page
window.print();

//Restore orignal HTML
document.body.innerHTML = oldPage;
*/

	}




    w.printUtil = utilMethods;

})(window);

