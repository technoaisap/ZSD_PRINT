@EndUserText.label: 'Delivery Challan'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_DELIVERY_CHALLAN_INV'
@ObjectModel.supportedCapabilities: [ #OUTPUT_FORM_DATA_PROVIDER ]
define custom entity ZCE_DELIEVRY_CHALLAN
  // with parameters parameter_name : parameter_type
{
  key BillingDocument    : vbeln;
      FileName           : abap.char( 80 );

      @Semantics.mimeType: true
      MimeType           : abap.char( 50 );

      @Semantics.largeObject  : {
        mimeType         : 'MimeType',
        fileName         : 'FileName',
       //contentDispositionPreference: #ATTACHMENT
        contentDispositionPreference: #INLINE
      }
      Form_DeliveryChallan : abap.rawstring( 0 );

}
