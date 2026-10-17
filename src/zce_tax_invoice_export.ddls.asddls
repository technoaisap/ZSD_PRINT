@EndUserText.label: 'Tax Invoice Export'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_TAX_INVOICE_EXPORT'
@ObjectModel.supportedCapabilities: [ #OUTPUT_FORM_DATA_PROVIDER ]
define custom entity ZCE_TAX_INVOICE_EXPORT
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
      Form_TaxInvoiceExport : abap.rawstring( 0 );

  
}
