@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Print Item'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BILLING_PRINT_ITEM
  as projection on ZR_BILLING_PRINT_ITEM
{
      @EndUserText.label: 'Billing Document'
  key BillingDocument,
      @EndUserText.label: 'Billing Document Item'
  key BillingDocumentItem,
  key ReferenceSDDocument,
  key ReferenceSDDocumentItem,
      @EndUserText.label: 'Material'
      Material,
      @EndUserText.label: 'Sales Office'
      SalesOffice,
      @EndUserText.label: 'Batch'
      Batch,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Sales Document'
      SalesDocument,
      MaterialDesc,
      CASNo,
      HSNCode,
      @Semantics.quantity.unitOfMeasure: 'NetQtyUOM'
      NetQuantity,
      NetQtyUOM,
      @Semantics.amount.currencyCode: 'RateUOM'
      RatePerKg,
      @Semantics.amount.currencyCode: 'RateUOM'
      Amount,
      @Semantics.amount.currencyCode: 'RateUOM'
      Amount2,
      @Semantics.amount.currencyCode: 'RateUOM'
      RatePerKg2,
      RateUOM,
      BatchRange,
      _head : redirected to parent ZC_BILLING_PRINT_HEAD,
      _hu : redirected to composition child ZC_BILLING_PRINT_HU
}
