@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Print Tax'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZC_BILLING_PRINT_TAX
  as projection on ZR_BILLING_PRINT_TAX
{
  key BillingDocument,
  key TransactionCurrency,
  key TaxLine,
      TaxName,
      TaxRate,

  @Semantics.amount.currencyCode: 'TransactionCurrency'
      TaxAmount,

      _head : redirected to parent ZC_BILLING_PRINT_HEAD
}
