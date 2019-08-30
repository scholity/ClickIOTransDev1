public class FulfillmentProcessSettlement {
  @InvocableMethod(label='Process Settlement' description='Settles authorization associated with order.')
  public static void processSettlements(List<ID> transactionPaymentIDs) {
      for (ID transactionPaymentID : transactionPaymentIDs) {
          Map<String,Object> result = ccpgcs.ccApiCyberSource.txnCapture(new Map<String, Object> {
                      ccrz.ccApi.API_VERSION => 1,
                      ccpgcs.cc_pgcs_ApiConstants.LOGIC_DATA => new Map<String, Object> {
                          ccpgcs.cc_pgcs_ApiConstants.CCRZ_V1_SFID => transactionPaymentID
             	      }
          });
      }
  }
}