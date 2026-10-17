@EndUserText.label: 'Tax Invoice Domestic'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_TAX_INVOICE_DOMESTIC'
@ObjectModel.supportedCapabilities: [ #OUTPUT_FORM_DATA_PROVIDER ]
define custom entity ZCE_TAX_INVOICE_DOMESTIC
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
      Form_TaxInvoiceDomestic : abap.rawstring( 0 );


}
