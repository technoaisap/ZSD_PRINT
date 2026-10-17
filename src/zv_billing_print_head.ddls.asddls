@AbapCatalog.sqlViewName: 'ZVBILLINGPTH'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Billing Print Head'
@Metadata.ignorePropagatedAnnotations: true
define view ZV_BILLING_PRINT_HEAD

  as select from    I_BillingDocument        as _head

    left outer join ZV_BILLING_PLANT_Details as _item           on _item.BillingDocument = _head.BillingDocument

  //Plant Address
    left outer join ZV_PLANT_Address         as plant_address   on plant_address.plant = _item.Plant
  //Company code Address
    left outer join ZV_COMPANY_ADDRESS       as company_address on company_address.CompanyCode = _head.CompanyCode 
  //Company Details
    left outer join ZV_COMPANY_DETAILS       as Company_Details on Company_Details.Companycode = _head.CompanyCode
  //Ship to Party
    left outer join I_BillingDocumentPartner as shipto          on  shipto.BillingDocument = _head.BillingDocument
                                                                and shipto.PartnerFunction = 'WE'
  //Ship to Party Address
    left outer join ZV_CUSTOMER_Address      as shipto_address  on shipto_address.Customer = shipto.Customer
    

  //Bill to Party
    left outer join I_BillingDocumentPartner as billto          on  billto.BillingDocument = _head.BillingDocument
                                                                and billto.PartnerFunction = 'RE'
  //Bill to Party Address
    left outer join ZV_CUSTOMER_Address      as billto_address  on billto_address.Customer = billto.Customer

  // IRN Details
    left outer join zj1iginvref_num          as irn_details     on irn_details.docno = _head.BillingDocument

  // E-way Details
    left outer join zeway_details            as eway_deatils    on eway_deatils.bill_doc = _head.BillingDocument

  // payment Terms
    left outer join I_PaymentTermsText       as pay_terms       on  pay_terms.PaymentTerms = _head.CustomerPaymentTerms
                                                                and pay_terms.Language     = $session.system_language

  //Sales Order Header deatils
    left outer join I_SalesDocument          as sales_order_h   on sales_order_h.SalesDocument = _item.SalesDocument

  //Sales Order Item deatils
    left outer join I_SalesDocumentItem      as sales_order_i   on  sales_order_i.SalesDocument     = sales_order_h.SalesDocument
                                                                and sales_order_i.SalesDocumentItem = '000010'

  //Deliver Details
    left outer join I_DeliveryDocument       as delivery_head   on delivery_head.DeliveryDocument = _item.ReferenceSDDocument


  // Notify Party
    left outer join zsd_so_itemtext          as ntp             on  ntp.vbeln      = sales_order_i.SalesDocument
                                                                and ntp.posnr      = sales_order_i.SalesDocumentItem
                                                                and ntp.spras      = $session.system_language
                                                                and ntp.zlevel     = 'HEADER'
                                                                and ntp.longtextid = 'ZNTP'

  //InterBank Details
    left outer join zsd_so_itemtext          as ibd             on  ibd.vbeln      = sales_order_i.SalesDocument
                                                                and ibd.posnr      = sales_order_i.SalesDocumentItem
                                                                and ibd.spras      = $session.system_language
                                                                and ibd.zlevel     = 'HEADER'
                                                                and ibd.longtextid = 'ZIBD'
  //Kind Attention
    left outer join zsd_so_itemtext          as kat             on  kat.vbeln      = sales_order_i.SalesDocument
                                                                and kat.posnr      = sales_order_i.SalesDocumentItem
                                                                and kat.spras      = $session.system_language
                                                                and kat.zlevel     = 'HEADER'
                                                                and kat.longtextid = 'ZKAT'

  //Iban
    left outer join zsd_so_itemtext          as iban            on  iban.vbeln      = sales_order_i.SalesDocument
                                                                and iban.posnr      = sales_order_i.SalesDocumentItem
                                                                and iban.spras      = $session.system_language
                                                                and iban.zlevel     = 'HEADER'
                                                                and iban.longtextid = 'ZBAN'

  //ISC
    left outer join zsd_so_itemtext          as isc             on  isc.vbeln      = sales_order_i.SalesDocument
                                                                and isc.posnr      = sales_order_i.SalesDocumentItem
                                                                and isc.spras      = $session.system_language
                                                                and isc.zlevel     = 'HEADER'
                                                                and isc.longtextid = 'ZISC'
  //Payment Instruction
    left outer join zsd_so_itemtext          as pyt             on  pyt.vbeln      = sales_order_i.SalesDocument
                                                                and pyt.posnr      = sales_order_i.SalesDocumentItem
                                                                and pyt.spras      = $session.system_language
                                                                and pyt.zlevel     = 'HEADER'
                                                                and pyt.longtextid = 'ZPYT'

  //bfc
    left outer join zsd_so_itemtext          as bfc             on  bfc.vbeln      = sales_order_i.SalesDocument
                                                                and bfc.posnr      = sales_order_i.SalesDocumentItem
                                                                and bfc.spras      = $session.system_language
                                                                and bfc.zlevel     = 'HEADER'
                                                                and bfc.longtextid = 'ZBFC'
  //bfca
    left outer join zsd_so_itemtext          as bfa             on  bfa.vbeln      = sales_order_i.SalesDocument
                                                                and bfa.posnr      = sales_order_i.SalesDocumentItem
                                                                and bfa.spras      = $session.system_language
                                                                and bfa.zlevel     = 'HEADER'
                                                                and bfa.longtextid = 'ZBFA'
  //bfca
    left outer join zsd_so_itemtext          as bsc             on  bsc.vbeln      = sales_order_i.SalesDocument
                                                                and bsc.posnr      = sales_order_i.SalesDocumentItem
                                                                and bsc.spras      = $session.system_language
                                                                and bsc.zlevel     = 'HEADER'
                                                                and bsc.longtextid = 'ZBSC'

   //ins
    left outer join zsd_so_itemtext          as ins             on  ins.vbeln      = sales_order_i.SalesDocument
                                                                and ins.posnr      = sales_order_i.SalesDocumentItem
                                                                and ins.spras      = $session.system_language
                                                                and ins.zlevel     = 'HEADER'
                                                                and ins.longtextid = 'ZINS'

  //Bussiness partner Details (contact person)
    left outer join I_BillingDocumentPartner as buss_part       on  buss_part.BillingDocument = _head.BillingDocument
                                                                and buss_part.PartnerFunction = 'AP'

  //Plant Unit
    left outer join ZV_PLANT_UNIT_ADDRESS    as Plant_Unit      on Plant_Unit.Werks = plant_address.plant
    
//    left outer join ZV_BILLING_PRINT_HU
    

{
  key _head.BillingDocument                           as BillingDocument, //Invoice no
      _head.BillingDocumentType                       as BillingDocumentType,
      _head.BillingDocumentDate                       as BillingDocumentDate,
      _head.SalesOrganization                         as SalesOrganization,
      _head.CompanyCode                               as CompanyCode,
      _head.FiscalYear                                as FiscalYear,
      _head.CreationDate                              as BillingDocumentCreatedOn, // Invoice Date,Date of Supply
      _head.DistributionChannel                       as DistributionChannel,

      _item.Plant                                     as Plant,

      irn_details.irn                                 as irn,
      irn_details.ack_no                              as ascno,
      irn_details.ack_date                            as ascdate,
      irn_details.qr_code                             as QRCode,

      eway_deatils.zewbnum                            as EWBNo,
      eway_deatils.ewb_due_date                       as EWBValidDateTo,
      eway_deatils.ewb_valid_fr_date                  as EWBValidDateFrom,

      shipto_address.CustomerName                     as ShpName,
      shipto_address.GstStateregioncode               as ShpStateCode,
      shipto_address.GSTNumber                        as ShpGSTIN,
      shipto_address.MobileNumber                     as ShpMobileNo,
      shipto_address.GstStateName                     as GstStateName, //Place Of Supply

      billto_address.CustomerName                     as BtpName,
      billto_address.GstStateregioncode               as BtpStateCode,
      billto_address.GSTNumber                        as BtpGSTIN,
      billto_address.MobileNumber                     as BtpMobileNo,
      billto_address.Customer                         as CustomerCode,

      delivery_head.DeliveryDocument                  as ChallanNo,
      delivery_head.ActualGoodsMovementDate           as ChallanDate,
      upper ( delivery_head.YY1_TransporterName_DLH ) as TranspoterName,
      delivery_head.YY1_VehicleNo_DLH                 as VehicleNo,
      delivery_head.YY1_LorryReceiptNumber_DLH        as LRNo,
      delivery_head.YY1_LorryReceiptDate_DLH          as LRDate,
      delivery_head.YY1_DriverName_DLH                as DriverName,
      delivery_head.YY1_DriverMobileNo_DLH            as DriverMobileNo,
      delivery_head.YY1_VesselflightNo_DLH            as FlightNo,

      sales_order_h.PurchaseOrderByCustomer           as PONo,
      sales_order_h.CustomerPurchaseOrderDate         as PODate,

      pay_terms.PaymentTermsName                      as PaymentTerms,

      company_address.CompanyCodeName                 as CompanyName,
      company_address.GstNumber                       as ComGSTIN,
      company_address.GstStateregioncode              as StateCode,
      company_address.StateName                       as State,
      company_address.EmailID                         as ComEmail,
      Company_Details.CinNumber                       as ComCIN,
      Company_Details.IecNumber                       as IECCode,
      Company_Details.PanNumber                       as PANNo,
      Company_Details.GstNumber                       as ComGST,
      Company_Details.IecNumber                       as ComIECNo,
      Company_Details.BankDetails                     as BankDetails,
      Company_Details.BranchCode                      as BranchCode,
      Company_Details.RTGSNEFT                        as RTGSNEFT,
      Company_Details.AccountNo                       as AccountNo,    


      ibd.longtext                                    as InterBankDetails,
      ntp.longtext                                    as NotifyParty,
      kat.longtext                                    as KindAtt,
      iban.longtext                                   as IBAN,
      isc.longtext                                    as ISC,
      pyt.longtext                                    as PaymentInstruction,
      bfc.longtext                                    as BFC,
      bfa.longtext                                    as BFA,
      bsc.longtext                                    as BSC,
      ins.longtext                                    as INS,

      sales_order_h.YY1_Precarriageby1_SDH            as PreCarriageBy,
      sales_order_h.YY1_PortofDischargeAir_SDH        as PortOfDischarge,
      sales_order_h.YY1_PortofLoadingAirpo_SDH        as PortOfLoading, // Place of receipt Pre-Carrier
      //      _head.YY1_TransportationMode_BDH                as TranportationMode,
      shipto_address.CountryName                      as FinalDestination,
      sales_order_h.YY1_TermsofDelivery2_SDH          as TermsOfDelivery,
      buss_part.ReferenceBusinessPartner              as ContactPerson,

      concat_with_space(
      concat_with_space(
      concat_with_space(
      concat_with_space(
        concat_with_space(
          concat_with_space(
            concat_with_space(
              concat_with_space(
                concat_with_space(
                  coalesce( Plant_Unit.unitdec, '' ),
                  coalesce( plant_address.Addressline1, '' ),
                  1
                ),
                coalesce( plant_address.Addressline2, '' ),
                1
              ),
              coalesce( plant_address.Addressline3, '' ),
              1
            ),
            coalesce( plant_address.Addressline4, '' ),
            1
          ),
          coalesce( plant_address.Addressline5, '' ),
          1
        ),
        coalesce( plant_address.CityName, '' ),
        1
      ),
      coalesce( plant_address.PostalCode, '' ),
      1
      ),
      coalesce( plant_address.StateName, '' ),
      1
      ),
      coalesce( plant_address.CountryName, '' ),
      1
      )                                               as CompanyAddress,

//      upper(
//        concat_with_space(
//          concat_with_space(
//            concat_with_space(
//              concat_with_space(
//                concat_with_space(
//                  concat_with_space(
//                    concat_with_space(
//                      concat_with_space(
//                        company_address.Addressline1,
//                        company_address.Addressline2,
//                        1
//                      ),
//                      company_address.Addressline3,
//                      1
//                    ),
//                    company_address.Addressline4,
//                    1
//                  ),
//                  company_address.Addressline5,
//                  1
//                ),
//                company_address.CityName,
//                1
//              ),
//              company_address.PostalCode,
//              1
//            ),
//            company_address.StateName,
//            1
//          ),
//          company_address.CountryName,
//          1
//        )
//      )                                               as CompanyAddress,

      upper(
              concat_with_space(
                concat_with_space(
                  concat_with_space(
                    concat_with_space(
                      concat_with_space(
                        concat_with_space(
                          coalesce( shipto_address.Addressline3, '' ),
                          coalesce( shipto_address.Addressline1, '' ),
                          1
                        ),
                        coalesce( shipto_address.Addressline2, '' ),
                        1
                      ),
                      coalesce( shipto_address.CityName, '' ),
                      1
                    ),
                    coalesce( shipto_address.PostalCode, '' ),
                    1
                  ),
                  coalesce( shipto_address.GstStateName, '' ),
                  1
                ),
                coalesce( shipto_address.CountryName, '' ),
                1
              )
            )                                         as ShpAddress,

      upper(
        concat_with_space(
          concat_with_space(
            concat_with_space(
              concat_with_space(
                concat_with_space(
                  concat_with_space(
                    coalesce( billto_address.Addressline3, '' ),
                    coalesce( billto_address.Addressline1, '' ),
                    1
                  ),
                  coalesce( billto_address.Addressline2, '' ),
                  1
                ),
                coalesce( billto_address.CityName, '' ),
                1
              ),
              coalesce( billto_address.PostalCode, '' ),
              1
            ),
            coalesce( billto_address.GstStateName, '' ),
            1
          ),
          coalesce( billto_address.CountryName, '' ),
          1
        )
      )                                               as BtpAddress,

      concat_with_space(
      company_address.MobileNumber,
      concat( '/', company_address.TelNumber ),
      1
      )                                               as ComTelNo,



      concat_with_space(
      concat_with_space(
      concat_with_space(
      concat_with_space(
        concat_with_space(
          concat_with_space(
            concat_with_space(
              concat_with_space(
                concat_with_space(
                  plant_address.Plantname,
                  plant_address.Addressline1,
                  1
                ),
                plant_address.Addressline2,
                1
              ),
              plant_address.Addressline3,
              1
            ),
            plant_address.Addressline4,
            1
          ),
          plant_address.Addressline5,
          1
        ),
        plant_address.CityName,
        1
      ),
      plant_address.PostalCode,
      1
      ),
      plant_address.StateName,
      1
      ),
      plant_address.CountryName,
      1
      )                                               as PlantAddress,

      _head.YY1_TransportationMode_BDH                as TMode,

      case
         when _head.YY1_TransportationMode_BDH = '1'
         then 'Road'
         when _head.YY1_TransportationMode_BDH = '2'
         then 'Rail'
         when _head.YY1_TransportationMode_BDH = '3'
         then 'Air'
         when _head.YY1_TransportationMode_BDH = '4'
         then 'Ship'
         else ''
         end                                          as TranportationMode

}
