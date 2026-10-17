@AbapCatalog.sqlViewName: 'ZVBILLHU'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Print Handling'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_BILLING_PRINT_HU
  as select from    ZV_Batch_item_unit_new as _hu
    left outer join I_BillingDocumentItem  as _item on  _hu.DeliveryDocument         = _item.ReferenceSDDocument
                                                    and _hu.HigherLvlItmOfBatSpltItm = _item.ReferenceSDDocumentItem
{
  key _hu.DeliveryDocument,
  key _hu.HigherLvlItmOfBatSpltItm,
  key _item.BillingDocument,
  key _item.BillingDocumentItem,
      _hu.HandlingUnitQuantity,
      _hu.HandlingUnitQuantityUnit,
      _hu.TotalHandlingUnitQuantity,
      _hu.TotalNetWeight,
      _hu.TotalTareWeight,
      _hu.TotalGrossWeight,
      _hu.WeightUnit,
      _hu.PackFirstToLastItem,
      _hu.FirstHandlingUnitItem,
      _hu.LastHandlingUnitItem,
      _hu.PalletNo,
      _hu.PackingPattern,
      _hu.TotalQty,
      _hu.NoOfPack
}
