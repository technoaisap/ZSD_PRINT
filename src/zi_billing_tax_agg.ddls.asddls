@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Tax Aggregates'
define view entity ZI_BILLING_TAX_AGG
  as select from ZV_BILLING_TAX
{
  key BillingDocument,
  key TransactionCurrency,

      max(
        case when TaxName = 'IGST'
          then ConditionRateValue
        end
      ) as IGSTRate,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(
        sum(
          case
            when TaxName = 'IGST'
              then curr_to_decfloat_amount( ConditionAmount )
            else cast( 0 as abap.decfloat34 )
          end
        )
        as abap.dec( 23, 2 )
      ) as IGSTAmount,

      max(
        case when TaxName = 'CGST'
          then ConditionRateValue
        end
      ) as CGSTRate,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
      cast(
   sum(
     case when TaxName = 'CGST'
       then curr_to_decfloat_amount( ConditionAmount )
       else cast( 0 as abap.decfloat34 )
     end
   ) as abap.dec( 23, 2 )
 ) as CGSTAmount,

      max(
        case when TaxName = 'SGST'
          then ConditionRateValue
        end
      ) as SGSTRate,

      @Semantics.amount.currencyCode: 'TransactionCurrency'
cast(
   sum(
     case when TaxName = 'SGST'
       then curr_to_decfloat_amount( ConditionAmount )
       else cast( 0 as abap.decfloat34 )
     end
   ) as abap.dec( 23, 2 )
 ) as SGSTAmount
}
group by
  BillingDocument,
  TransactionCurrency
