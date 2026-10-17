@AbapCatalog.sqlViewName: 'ZBILLPLT'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Plant Details'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_BILLING_PLANT_Details 

as select distinct from I_BillingDocumentItem
{
    key BillingDocument,
        SalesDocument,
        ReferenceSDDocument,
        Plant
}
