@AccessControl.authorizationCheck: #NOT_REQUIRED
define view entity ZR_BILLING_PRINT_TAX
  as select from ZI_BILLING_TAX_FORM
  association to parent ZR_BILLING_PRINT_HEAD as _head
    on $projection.BillingDocument = _head.BillingDocument
{
  key BillingDocument,
  key TransactionCurrency,
  key TaxLine,
      TaxName,
      TaxRate,

  @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmount,

      _head
}
