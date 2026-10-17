@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Print Handling'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZR_BILLING_PRINT_HU
  as select from ZV_BILLING_PRINT_HU as _hu
  association to parent ZR_BILLING_PRINT_ITEM as _item on  _item.ReferenceSDDocument     = $projection.DeliveryDocument
                                                       and _item.ReferenceSDDocumentItem = $projection.HigherLvlItmOfBatSpltItm
                                                       and _item.BillingDocument         = $projection.BillingDocument
                                                       and _item.BillingDocumentItem     = $projection.BillingDocumentItem
  //composition of target_data_source_name as _association_name
{
  key DeliveryDocument,
  key HigherLvlItmOfBatSpltItm,
  key BillingDocument,
  key BillingDocumentItem,
      @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityUnit'
      HandlingUnitQuantity,
      HandlingUnitQuantityUnit,
      @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityUnit'
      TotalHandlingUnitQuantity,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      TotalNetWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      TotalTareWeight,
      @Semantics.quantity.unitOfMeasure: 'WeightUnit'
      TotalGrossWeight,
      WeightUnit,
      PackFirstToLastItem,
      FirstHandlingUnitItem,
      LastHandlingUnitItem,
      PalletNo,
      PackingPattern,
      @Semantics.quantity.unitOfMeasure: 'HandlingUnitQuantityUnit'
      TotalQty,
      NoOfPack,
      _item
      //    _association_name // Make association public
}
