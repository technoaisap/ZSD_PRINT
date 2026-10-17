@AbapCatalog.sqlViewName: 'ZVBILLPRINTITEM'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Print Item'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_BILLING_PRINT_ITEM

  as select from    I_BillingDocumentItem          as _item

    left outer join I_BillingDocument              as _head           on _head.BillingDocument = _item.BillingDocument
  //Product Details
    left outer join I_Product                      as product_details on product_details.Product = _item.Product

  //Product Description
    left outer join I_ProductDescription           as product_desc    on  product_desc.Product  = _item.Product
                                                                      and product_desc.Language = $session.system_language
  // HSN Code
    left outer join I_ProductPlantBasic            as hsn_code_data   on  hsn_code_data.Product = _item.Product
                                                                      and hsn_code_data.Plant   = _item.Plant
  // HU packing Patern
  //    left outer join ZV_Batch_item_unit_new         as hu_packpattern  on  hu_packpattern.DeliveryDocument         = _item.ReferenceSDDocument
  //                                                                      and hu_packpattern.HigherLvlItmOfBatSpltItm = _item.ReferenceSDDocumentItem

    left outer join I_BillingDocItemPrcgElmntBasic as price           on  price.BillingDocument     = _item.BillingDocument
                                                                      and price.BillingDocumentItem = _item.BillingDocumentItem
                                                                      and price.ConditionType       = 'PPR0'


{
  key       _item.BillingDocument                as BillingDocument,
  key       _item.BillingDocumentItem            as BillingDocumentItem,
  key       _item.ReferenceSDDocument            as ReferenceSDDocument,
  key       _item.ReferenceSDDocumentItem        as ReferenceSDDocumentItem,
            _item.Material                       as Material,
            _item.SalesOffice                    as SalesOffice,
            _item.Batch                          as Batch,
            _item.Plant                          as Plant,
            _item.SalesDocument                  as SalesDocument,

            product_desc.ProductDescription      as MaterialDesc,
            product_details.YY1_CASNumber_PRD    as CASNo,

            hsn_code_data.ConsumptionTaxCtrlCode as HSNCode,

            @Semantics.quantity.unitOfMeasure: 'NetQtyUOM'
            _item.BillingQuantity                as NetQuantity,
            _item.BillingQuantityUnit            as NetQtyUOM,
            @Semantics.amount.currencyCode: 'RateUOM'
            price.ConditionRateAmount            as RatePerKg2,
            @Semantics.amount.currencyCode: 'RateUOM'
            cast(
            _head.AccountingExchangeRate * price.ConditionRateAmount
            as abap.dec(15,2)
            )                                    as RatePerKg,
            price.ConditionRateAmount            as Rate,
            _head.AccountingExchangeRate         as ExchangeRate,
            @Semantics.amount.currencyCode: 'RateUOM'
            price.ConditionAmount                as Amount2,
            cast(
            price.ConditionAmount * _head.AccountingExchangeRate
            as abap.dec(15,2)
            )                                    as Amount,
            price.TransactionCurrency            as RateUOM,

            _head.AccountingExchangeRate         as ExchageRate,

            cast( '' as abap.char(144) )         as BatchRange

}
where
  _item.BillingQuantity <> 0
