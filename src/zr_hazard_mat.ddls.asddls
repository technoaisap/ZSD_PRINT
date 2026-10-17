@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hazardous Material'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_HAZARD_MAT
  as select from ZV_HAZARD_MAT
  //composition of target_data_source_name as _association_name
{
  key Materialcode,
      Materialdesc,
      Licenseno,
      Validity
      //    _association_name // Make association public
}
