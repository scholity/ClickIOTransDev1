/**
 * Created by dgajwani on 9/22/18.
 */

public with sharing class cc_lx_Exception extends Exception{

    public static String ERROR_KEY = 'Error';

    /**
     * @description Returns a Map<String,Object> to convey the error message to the lightning cmp.
     *
     * @param errorMessage
     *
     * @return
     */
    public static Map<String, Object> getErrorMessageMap(String errorMessage)
    {
        return new Map<String, Object> {ERROR_KEY => errorMessage};
    }
}