@EndUserText.label: 'Billing item batch range'
@ObjectModel.query.implementedBy: 'ABAP:ZCL_BILL_ITEM_BATCH_QP'
define custom entity ZCE_BILL_ITEM_BATCH
{
  @EndUserText.label: 'Billing Document'
  key BillingDocument     : abap.char(10);

  @EndUserText.label: 'Billing Document Item'
  key BillingDocumentItem : abap.numc(6);

  @EndUserText.label: 'First Batch'
  FirstBatch              : abap.char(70);

  @EndUserText.label: 'Last Batch'
  LastBatch               : abap.char(70);

  @EndUserText.label: 'Batch Range'
  BatchRange              : abap.char(144);
}
