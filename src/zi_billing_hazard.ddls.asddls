@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hazardous material details for billing document'
define view entity ZI_BILLING_HAZARD
  as select from ZI_BILLING_HAZARD_DOC as doc
    inner join ztb_hazard_mat as haz
      on haz.materialcode = doc.MaterialCode
{
  key doc.BillingDocument,

  cast( 'X' as abap.char( 1 ) ) as HazardousMaterial,
  haz.licenseno                    as HazardLicenseNo,
  haz.validity1                    as HazardValidity
}
