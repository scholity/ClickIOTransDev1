({
	printContent : function(component, event, helper) {
        
        //window.print();
        
        var restorepage = document.body.innerHTML;
        var printcontent = document.getElementById("print").innerHTML;
        console.log("printcontent***"+printcontent);
        
        document.body.innerHTML = printcontent;
        window.print();
        document.body.innerHTML = restorepage;
        
	}
})