@AccessControl.authorizationCheck: #NOT_REQUIRED
@Metadata.ignorePropagatedAnnotations: true
@EndUserText.label: 'Billing Tax Form Lines'
define view entity ZI_BILLING_TAX_FORM
  as select from ZI_BILLING_TAX_AGG
{
  key BillingDocument,
  key TransactionCurrency,
  key cast( '1' as abap.char(1) )    as TaxLine,

      cast( 'IGST' as abap.char(4) ) as TaxName,
      IGSTRate                       as TaxRate,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      IGSTAmount                     as TaxAmount
}
where
  IGSTRate is not null

union all

select from ZI_BILLING_TAX_AGG
{
  key BillingDocument,
  key TransactionCurrency,
  key cast( '1' as abap.char(1) )    as TaxLine,

      cast( 'CGST' as abap.char(4) ) as TaxName,
      CGSTRate                       as TaxRate,


      CGSTAmount                     as TaxAmount
}
where
  IGSTRate is null

union all

select from ZI_BILLING_TAX_AGG
{
  key BillingDocument,
  key TransactionCurrency,
  key cast( '2' as abap.char(1) )    as TaxLine,

      cast( 'SGST' as abap.char(4) ) as TaxName,
      SGSTRate                       as TaxRate,


      SGSTAmount                     as TaxAmount
}
where
  IGSTRate is null
