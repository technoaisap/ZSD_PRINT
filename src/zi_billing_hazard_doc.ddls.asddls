@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hazardous material per billing document'
define view entity ZI_BILLING_HAZARD_DOC
  as select from ZR_BILLING_PRINT_ITEM as item
    inner join ztb_hazard_mat as haz
      on haz.materialcode = item.Material
{
  key item.BillingDocument,
  min( haz.materialcode ) as MaterialCode
}
group by item.BillingDocument
