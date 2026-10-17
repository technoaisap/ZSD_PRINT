@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hazardous Material'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_HAZARD_MAT
  as projection on ZR_HAZARD_MAT
{
      @EndUserText.label: 'Materialcode'
  key Materialcode,
      @EndUserText.label: 'MaterialDesc'
      Materialdesc,
      @EndUserText.label: 'License No'
      Licenseno,
      @EndUserText.label: 'Validity'
      Validity
}
