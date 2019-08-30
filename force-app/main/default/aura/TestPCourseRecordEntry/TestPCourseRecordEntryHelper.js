({
	validateFields : function (component,field) {
        
        var nameField	= field;
        var expname		= nameField.get("v.value");
        
        console.log('yes:'+nameField);

        
        if ($A.util.isEmpty(expname))
        {
           component.set("v.er",true);
           nameField.set("v.errors", [{message:"This field can't be blank."}]);
        }
        else
        {
            nameField.set("v.errors", null);
        }
    }
})