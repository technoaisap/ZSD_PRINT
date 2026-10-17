@EndUserText.label: 'Domestic Proforma Invoice'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_PROFORMA_DOMESTIC'
@ObjectModel.supportedCapabilities: [ #OUTPUT_FORM_DATA_PROVIDER ]
define custom entity ZCE_PROFORMA_INVOICE_DOMESTIC

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
      Form_ProformaDomestic : abap.rawstring( 0 );
  
}
