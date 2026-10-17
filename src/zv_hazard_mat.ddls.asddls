@AbapCatalog.sqlViewName: 'ZVHAZARDMAT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Hazardous Material'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_HAZARD_MAT
  as select from ztb_hazard_mat
{
  key materialcode as Materialcode,
      materialdesc as Materialdesc,
      licenseno    as Licenseno,
      validity1    as Validity
}
