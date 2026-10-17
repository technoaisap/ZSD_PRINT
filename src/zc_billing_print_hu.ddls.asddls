@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Print Handling'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_BILLING_PRINT_HU
  as projection on ZR_BILLING_PRINT_HU
{
      @EndUserText.label: 'Delivery Document'
  key DeliveryDocument,
      @EndUserText.label: 'Higher Level Item of Batch Split Item'
  key HigherLvlItmOfBatSpltItm,
      @EndUserText.label: 'Billing Document'
  key BillingDocument,
      @EndUserText.label: 'Billing Document Item'
  key BillingDocumentItem,
      @EndUserText.label: 'Quantity'
      @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityUnit'
      HandlingUnitQuantity,
      HandlingUnitQuantityUnit,
      @EndUserText.label: 'Total Handling Unit Quantity'
      @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityUnit'
      TotalHandlingUnitQuantity,
      @EndUserText.label: 'Total Net Weight'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      TotalNetWeight,
      @EndUserText.label: 'Total Tare Weight'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      TotalTareWeight,
      @EndUserText.label: 'Total Gross Weight'
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      TotalGrossWeight,
      WeightUnit,
      PackFirstToLastItem,
      FirstHandlingUnitItem,
      LastHandlingUnitItem,
      PalletNo,
      PackingPattern,
      @EndUserText.label: 'Total Quantity'
      @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityUnit'
      TotalQty,
      NoOfPack,
      _item : redirected to parent ZC_BILLING_PRINT_ITEM

}
