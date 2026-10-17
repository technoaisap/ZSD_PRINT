@EndUserText.label: 'Commercial CHA'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_COMMERCIAL_INVOICE_CHA'
@ObjectModel.supportedCapabilities: [ #OUTPUT_FORM_DATA_PROVIDER ]
define custom entity ZCE_COMMERCIAL_INVOICE_CHA
// with parameters parameter_name : parameter_type
{
  key BillingDocument         : vbeln;
      FileName                : abap.char( 80 );

      @Semantics.mimeType     : true
      MimeType                : abap.char( 50 );

      @Semantics.largeObject  : {
        mimeType              : 'MimeType',
        fileName              : 'FileName',
       //contentDispositionPreference: #ATTACHMENT
        contentDispositionPreference: #INLINE
      }
      Form_CommercialCHA : abap.rawstring( 0 );
  
}
