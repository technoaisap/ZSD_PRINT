@EndUserText.label: 'Export Proforma Invoice'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PROFORMA_EXPORT'
@ObjectModel.supportedCapabilities: [ #OUTPUT_FORM_DATA_PROVIDER ]
define custom entity ZCE_PROFORMA_INVOICE_EXPORT
  // with parameters parameter_name : parameter_type
{
  key BillingDocument       : vbeln;
      FileName              : abap.char( 80 );

      @Semantics.mimeType   : true
      MimeType              : abap.char( 50 );

      @Semantics.largeObject: {
        mimeType            : 'MimeType',
        fileName            : 'FileName',
       //contentDispositionPreference: #ATTACHMENT
        contentDispositionPreference: #INLINE
      }
      Form_ProformaExport : abap.rawstring( 0 );

}
