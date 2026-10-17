@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Print Head'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root view entity ZC_BILLING_PRINT_HEAD
  provider contract transactional_query
  as projection on ZR_BILLING_PRINT_HEAD
{
      @EndUserText.label: 'Billing Document'
  key BillingDocument,
      @EndUserText.label: 'Billing Document Type'
      BillingDocumentType,
      @EndUserText.label: 'Billing Document Date'
      BillingDocumentDate,
      @EndUserText.label: 'Sales Organaization'
      SalesOrganization,
      @EndUserText.label: 'Company Code'
      CompanyCode,
      @EndUserText.label: 'Plant'
      Plant,
      @EndUserText.label: 'Fiscal Year'
      FiscalYear,
      @EndUserText.label: 'Distribution Channel'
      DistributionChannel,
      BillingDocumentCreatedOn,
      irn,
      ascno,
      ascdate,
      QRCode,
      CompanyAddress,
      CompanyName,
      ComGSTIN,
      StateCode,
      State,
      ComEmail,
      ComCIN,
      ComTelNo,
      IECCode,
      PANNo,
      ComGST,
      ComIECNo,
      PlantAddress,
      BankDetails,
      BranchCode,
      RTGSNEFT,
      AccountNo,
      EWBNo,
      EWBValidDateTo,
      EWBValidDateFrom,
      @EndUserText.label: 'Ship-To Party'
      ShpName,
      ShpAddress,
      ShpStateCode,
      ShpGSTIN,
      ShpMobileNo,
      GstStateName,
      @EndUserText.label: 'Bill-To Party'
      BtpName,
      BtpAddress,
      BtpStateCode,
      BtpGSTIN,
      BtpMobileNo,
      CustomerCode,
      ChallanNo,
      ChallanDate,
      TranspoterName,
      VehicleNo,
      LRNo,
      LRDate,
      DriverName,
      DriverMobileNo,
      FlightNo,
      PONo,
      PODate,
      PaymentTerms,
      InterBankDetails,
      NotifyParty,
      KindAtt,
      IBAN,
      ISC,
      INS,
      PaymentInstruction,
      BFC,
      BFA,
      BSC,
      PreCarriageBy,
      PortOfDischarge,
      PortOfLoading,
      TranportationMode,
      FinalDestination,
      TermsOfDelivery,
      ContactPerson,

      @EndUserText.label: 'Domestic Tax Invoice'
      Form_TaxInvoiceDomestic,
      @UI.hidden: true
      FormURL_TaxInvoiceDomestic,
      @EndUserText.label: 'Export Tax Invoice'
      Form_TaxInvoiceExport,
      @UI.hidden: true
      FormURL_TaxInvoiceExport,
      @EndUserText.label: 'Domestic Proforma Invoice'
      Form_ProformaDomestic,
      @UI.hidden: true
      FormURL_ProformaDomestic,
      //      FC_ProformaDomestic,
      @EndUserText.label: 'Export Proforma Invoice'
      Form_ProformaExport,
      @UI.hidden: true
      FormURL_ProformaExport,
      @EndUserText.label: 'Commercial Invoice CHA'
      Form_CommercialCHA,
      @UI.hidden: true
      FormURL_CommercialCHA,
      @EndUserText.label: 'Commercial Invoice Buyer'
      Form_CommercialBuyer,
      @UI.hidden: true
      FormURL_CommercialBuyer,
      @EndUserText.label: 'Delivery Challan'
      Form_DeliveryChallan,
      @UI.hidden: true
      FormURL_DeliveryChallan,

      @EndUserText.label: 'Hazardous Material Indicator'
      HazardousMaterial,

      @EndUserText.label: 'MA II License Number'
      HazardLicenseNo,

      @EndUserText.label: 'MA II License Validity'
      HazardValidity,

      _item : redirected to composition child ZC_BILLING_PRINT_ITEM,
      _tax  : redirected to composition child ZC_BILLING_PRINT_TAX
}
