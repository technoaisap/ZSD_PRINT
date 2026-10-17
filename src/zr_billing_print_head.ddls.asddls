@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Print Head'
@Metadata.ignorePropagatedAnnotations: true
define root view entity ZR_BILLING_PRINT_HEAD

  as select from ZV_BILLING_PRINT_HEAD
  composition [0..*] of ZR_BILLING_PRINT_TAX  as _tax

  composition [0..*] of ZR_BILLING_PRINT_ITEM as _item
  association [0..1] to ZI_BILLING_HAZARD     as _Hazard on $projection.BillingDocument = _Hazard.BillingDocument
{
  key BillingDocument,
      BillingDocumentType,
      BillingDocumentDate,
      SalesOrganization,
      CompanyCode,
      FiscalYear,
      DistributionChannel,
      Plant,
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

      ShpName,
      ShpAddress,
      ShpStateCode,
      ShpGSTIN,
      ShpMobileNo,
      GstStateName,

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
      PaymentInstruction,
      BFC,
      BFA,
      BSC,
      INS,

      PreCarriageBy,
      PortOfDischarge,
      PortOfLoading,
      TranportationMode,
      FinalDestination,
      TermsOfDelivery,
      ContactPerson,

      coalesce( _Hazard.HazardousMaterial, '' ) as HazardousMaterial,
      _Hazard.HazardLicenseNo                   as HazardLicenseNo,
      _Hazard.HazardValidity                    as HazardValidity,

      //Domestic Tax Invoive
      cast(
                 concat(
                 '/sap/opu/odata/sap/ZSB_BILLING_PRINT_HEAD_SRV/ZCE_TAX_INVOICE_DOMESTIC(BillingDocument=%27',
                 concat( BillingDocument, '%27)/$value' )

                 ) as abap.char(255)
                 )                              as FormURL_TaxInvoiceDomestic,

      case
      when DistributionChannel <> '20' and BillingDocumentType = 'F2'
      then cast( concat( BillingDocument, '.pdf' )  as abap.char(20) )
      else ''
      end                                       as Form_TaxInvoiceDomestic,



      //Export Tax Invoive
      cast(
               concat(
               '/sap/opu/odata/sap/ZSB_BILLING_PRINT_HEAD_SRV/ZCE_TAX_INVOICE_EXPORT(BillingDocument=%27',
               concat( BillingDocument, '%27)/$value' )

               ) as abap.char(255)
               )                                as FormURL_TaxInvoiceExport,


      case
      when DistributionChannel = '20' and BillingDocumentType = 'F2'
      then cast( concat( BillingDocument, '.pdf' )  as abap.char(20) )
      else ''
      end                                       as Form_TaxInvoiceExport,


      //Domestic Proforma Invoive

      cast(
              concat(
              '/sap/opu/odata/sap/ZSB_BILLING_PRINT_HEAD_SRV/ZCE_PROFORMA_INVOICE_DOMESTIC(BillingDocument=%27',
              concat( BillingDocument, '%27)/$value' )

              ) as abap.char(255)
              )                                 as FormURL_ProformaDomestic,
      case
            when DistributionChannel <> '20' and BillingDocumentType = 'F5'
            then
            cast( concat( BillingDocument, '.pdf' )  as abap.char(20) )
            else ''
            end                                 as Form_ProformaDomestic,


      //Export Proforma Invoice
      cast(
               concat(
               '/sap/opu/odata/sap/ZSB_BILLING_PRINT_HEAD_SRV/ZCE_PROFORMA_INVOICE_EXPORT(BillingDocument=%27',
               concat( BillingDocument, '%27)/$value' )

               ) as abap.char(255)
               )                                as FormURL_ProformaExport,


      case
      when DistributionChannel = '20' and BillingDocumentType = 'F5'
      then cast( concat( BillingDocument, '.pdf' )  as abap.char(20) )
      else ''
      end                                       as Form_ProformaExport,


      //Commercial CHA
      cast(
               concat(
               '/sap/opu/odata/sap/ZSB_BILLING_PRINT_HEAD_SRV/ZCE_COMMERCIAL_INVOICE_CHA(BillingDocument=%27',
               concat( BillingDocument, '%27)/$value' )

               ) as abap.char(255)
               )                                as FormURL_CommercialCHA,

      case
      when DistributionChannel = '20' and BillingDocumentType = 'F2'
      then cast( concat( BillingDocument, '.pdf' )  as abap.char(20) )
      else ''
      end                                       as Form_CommercialCHA,


      // Commercial Buyer
      cast(
         concat(
         '/sap/opu/odata/sap/ZSB_BILLING_PRINT_HEAD_SRV/ZCE_COMMERCIAL_INVOICE_BUYER(BillingDocument=%27',
         concat( BillingDocument, '%27)/$value' )

         ) as abap.char(255)
         )                                      as FormURL_CommercialBuyer,

      case
      when DistributionChannel = '20' and BillingDocumentType = 'F2'
      then cast( concat( BillingDocument, '.pdf' )  as abap.char(20) )
      else ''
      end                                       as Form_CommercialBuyer,




      //Delivery Challan
      cast(
      concat(
      '/sap/opu/odata/sap/ZSB_BILLING_PRINT_HEAD_SRV/ZCE_DELIEVRY_CHALLAN(BillingDocument=%27',
      concat( BillingDocument, '%27)/$value' )

      ) as abap.char(255)
      )                                         as FormURL_DeliveryChallan,

      case
      when BillingDocumentType = 'F2'
      then cast( concat( BillingDocument, '.pdf' )  as abap.char(20) )
      else ''
      end                                       as Form_DeliveryChallan,

      _item,
      _tax
}
