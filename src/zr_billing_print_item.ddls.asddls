@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Print Item'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_BILLING_PRINT_ITEM
  as select from ZV_BILLING_PRINT_ITEM
  //composition of target_data_source_name as _association_name
  association to parent ZR_BILLING_PRINT_HEAD as _head on _head.BillingDocument = $projection.BillingDocument
  composition [0..*] of ZR_BILLING_PRINT_HU   as _hu
{
  key BillingDocument,
  key BillingDocumentItem,
  key ReferenceSDDocument,
  key ReferenceSDDocumentItem,
      Material,
      SalesOffice,
      Batch,
      Plant,
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
      _head,
      _hu
      //    _association_name // Make association public
}
