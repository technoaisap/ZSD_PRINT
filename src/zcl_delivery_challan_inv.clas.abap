CLASS zcl_delivery_challan_inv DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_rap_query_provider.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zcl_delivery_challan_inv IMPLEMENTATION.

METHOD if_rap_query_provider~select.

    DATA lt_form TYPE STANDARD TABLE OF ZCE_DELIEVRY_CHALLAN.
    DATA ls_form TYPE ZCE_DELIEVRY_CHALLAN.

    DATA lv_billingdocument     TYPE vbeln.
    DATA lv_billingdocumentitem TYPE posnr.
    DATA lv_pdf                  TYPE xstring.
    DATA lv_text                 TYPE string.

    TRY.

        DATA(lt_filter_cond) =
          io_request->get_filter( )->get_as_ranges( ).

        LOOP AT lt_filter_cond INTO DATA(ls_filter_cond).

          "to_upper returns the filter name in uppercase,
          "therefore compare it with an uppercase value
          IF to_upper( ls_filter_cond-name ) = 'BILLINGDOCUMENT'.

            READ TABLE ls_filter_cond-range
              INTO DATA(ls_range)
              INDEX 1.

            IF sy-subrc = 0.
              lv_billingdocument =
                |{ ls_range-low ALPHA = IN }|.
            ENDIF.

          ENDIF.

        ENDLOOP.

        "Do not leave the query provider without setting the response
        IF lv_billingdocument IS INITIAL.

          CLEAR lt_form.

          io_response->set_data( lt_form ).

          io_response->set_total_number_of_records(
            0
          ).

          RETURN.

        ENDIF.

        SELECT SINGLE BillingDocumentItem
          FROM zc_billing_print_item
          WHERE BillingDocument = @lv_billingdocument
          INTO @lv_billingdocumentitem.

        IF sy-subrc <> 0
           OR lv_billingdocumentitem IS INITIAL.

          CLEAR lt_form.

          io_response->set_data( lt_form ).

          io_response->set_total_number_of_records(
            0
          ).

          RETURN.

        ENDIF.

        SELECT SINGLE * FROM I_BillingDocument
          WHERE BillingDocument = @lv_billingdocument
           INTO @DATA(ls_billing).

        IF sy-subrc <> 0
           OR lv_billingdocumentitem IS INITIAL.

          CLEAR lt_form.

          io_response->set_data( lt_form ).

          io_response->set_total_number_of_records(
            0
          ).

          RETURN.

        ENDIF.

        DATA(lo_reader) =
          cl_fp_form_reader=>create_form_reader(
            iv_formname = 'ZF_DELIEVRY_CHALLAN'
          ).

        DATA(lv_layout) = lo_reader->get_layout( ).

        DATA(lo_fdp_api) =
          cl_fp_fdp_services=>get_instance(
            iv_service_definition = 'ZSD_BILLING_PRINT_HEAD_DEF'
            iv_max_depth          = 2
          ).

        DATA(lt_keys) = lo_fdp_api->get_keys( ).

        "Find the Delivery Document key
        READ TABLE lt_keys
          ASSIGNING FIELD-SYMBOL(<ls_key>)
          WITH KEY name = 'BILLINGDOCUMENT'.

        IF sy-subrc <> 0.

          READ TABLE lt_keys
            ASSIGNING <ls_key>
            WITH KEY name = 'BillingDocument'.

        ENDIF.

        IF sy-subrc = 0.

          <ls_key>-value = lv_billingdocument.

        ELSE.

          "Required FDP key was not found.
          "Set an empty RAP response before leaving the method.
          CLEAR lt_form.

          io_response->set_data( lt_form ).

          io_response->set_total_number_of_records(
            0
          ).

          RETURN.

        ENDIF.

        READ TABLE lt_keys
          ASSIGNING <ls_key>
          WITH KEY name = 'BILLINGDOCUMENTITEM'.

        IF sy-subrc <> 0.

          READ TABLE lt_keys
            ASSIGNING <ls_key>
            WITH KEY name = 'BillingDocumentItem'.

        ENDIF.

        IF sy-subrc = 0.
          <ls_key>-value = lv_billingdocumentitem.
        ENDIF.

        DATA(lv_xml_data) =
          lo_fdp_api->read_to_xml_v2(
            it_select = lt_keys
          ).

        " Calculate batch ranges for all items in this invoice
        TYPES:
          BEGIN OF ty_item_batch,
            billingdocumentitem TYPE
                                  i_billingdocumentitem-billingdocumentitem,
            batchrange          TYPE c LENGTH 144,
          END OF ty_item_batch.

        DATA lt_item_batches TYPE STANDARD TABLE OF ty_item_batch
          WITH EMPTY KEY.

        SELECT billingdocumentitem,
               referencesddocument,
               referencesddocumentitem
          FROM i_billingdocumentitem
          WHERE billingdocument = @lv_billingdocument
          INTO TABLE @DATA(lt_invoice_items).

        LOOP AT lt_invoice_items INTO DATA(ls_invoice_item).

          DATA(ls_batch_result) =
            zcl_bill_item_batch_qp=>get_batch_range(
              iv_delivery_document =
                ls_invoice_item-referencesddocument
              iv_delivery_item =
                ls_invoice_item-referencesddocumentitem
            ).

          APPEND VALUE #(
            billingdocumentitem =
              ls_invoice_item-billingdocumentitem
            batchrange =
              ls_batch_result-batchrange
          ) TO lt_item_batches.

        ENDLOOP.

        DATA(lv_xml_preview) =
        cl_abap_conv_codepage=>create_in( )->convert(
          source = lv_xml_data
        ).

        " Parse the existing FDP XML
        DATA(lo_xml) = cl_ixml_core=>create( ).
        DATA(lo_stream_factory) = lo_xml->create_stream_factory( ).
        DATA(lo_document) = lo_xml->create_document( ).

        DATA(lo_input) =
          lo_stream_factory->create_istream_xstring(
            string = lv_xml_data
          ).

        DATA(lo_parser) = lo_xml->create_parser(
          document       = lo_document
          stream_factory = lo_stream_factory
          istream        = lo_input
        ).

        IF lo_parser->parse( ) <> 0.
          RAISE EXCEPTION TYPE zcx_bill_batch_query.
        ENDIF.

        DATA:
          lv_xml_billdoc TYPE i_billingdocumentitem-billingdocument,
          lv_xml_item    TYPE i_billingdocumentitem-billingdocumentitem,
          lo_range_node  TYPE REF TO if_ixml_node.

        " Walk through the XML and find invoice item elements
        DATA(lo_iterator) = lo_document->create_iterator( ).
        DATA(lo_node) = lo_iterator->get_next( ).

        WHILE lo_node IS BOUND.

          IF lo_node->get_name( ) = 'ZC_BILLING_PRINT_ITEM'.

            CLEAR:
              lv_xml_billdoc,
              lv_xml_item,
              lo_range_node.

            " Read the direct fields belonging to this item
            DATA(lo_field) = lo_node->get_first_child( ).

            WHILE lo_field IS BOUND.

              CASE lo_field->get_name( ).

                WHEN 'BillingDocument'.

                  DATA(lo_doc_text) = lo_field->get_first_child( ).

                  IF lo_doc_text IS BOUND.
                    lv_xml_billdoc = lo_doc_text->get_value( ).
                  ENDIF.

                WHEN 'BillingDocumentItem'.

                  DATA(lo_item_text) = lo_field->get_first_child( ).

                  IF lo_item_text IS BOUND.
                    lv_xml_item = lo_item_text->get_value( ).
                  ENDIF.

                WHEN 'BatchRange'.

                  lo_range_node = lo_field.

              ENDCASE.

              lo_field = lo_field->get_next( ).

            ENDWHILE.

            " Only update items belonging to this invoice
            IF lv_xml_billdoc = lv_billingdocument.

              READ TABLE lt_item_batches
                INTO DATA(ls_xml_batch)
                WITH KEY billingdocumentitem = lv_xml_item.

              IF sy-subrc <> 0 OR lo_range_node IS NOT BOUND.
                RAISE EXCEPTION TYPE zcx_bill_batch_query.
              ENDIF.

              " Remove any existing BatchRange text
              DATA(lo_old_text) = lo_range_node->get_first_child( ).

              WHILE lo_old_text IS BOUND.

                DATA(lv_remove_rc) =
                  lo_range_node->remove_child( lo_old_text ).

                IF lv_remove_rc <> 0.
                  RAISE EXCEPTION TYPE zcx_bill_batch_query.
                ENDIF.

                lo_old_text = lo_range_node->get_first_child( ).

              ENDWHILE.

              DATA(lo_new_text) = lo_document->create_text(
     text = CONV string( ls_xml_batch-batchrange )
   ).

              DATA(lv_append_rc) =
                lo_range_node->append_child( lo_new_text ).

              IF lv_append_rc <> 0.
                RAISE EXCEPTION TYPE zcx_bill_batch_query.
              ENDIF.

            ENDIF.

          ENDIF.

          lo_node = lo_iterator->get_next( ).

        ENDWHILE.

        " Serialize the updated document back to XML
        DATA lv_updated_xml TYPE xstring.

        DATA(lo_output) =
          lo_stream_factory->create_ostream_xstring(
            string = lv_updated_xml
          ).

        DATA(lo_renderer) = lo_xml->create_renderer(
          document = lo_document
          ostream  = lo_output
        ).

        IF lo_renderer->render( ) <> 0.
          RAISE EXCEPTION TYPE zcx_bill_batch_query.
        ENDIF.

        lv_xml_data = lv_updated_xml.
        lv_xml_preview =
          cl_abap_conv_codepage=>create_in( )->convert(
            source = lv_xml_data
          ).

        cl_fp_ads_util=>render_pdf(
          EXPORTING
            iv_xml_data   = lv_xml_data
            iv_xdp_layout = lv_layout
            iv_locale     = 'en_US'
          IMPORTING
            ev_pdf        = lv_pdf
        ).

        ls_form-billingdocument = lv_billingdocument.
        ls_form-filename         = |DeliveryChallan_{ lv_billingdocument }.pdf|.
        ls_form-mimetype         = 'application/pdf'.
        ls_form-Form_DeliveryChallan = lv_pdf.

      CATCH cx_root INTO DATA(lx_error).

        lv_text =
          |ERROR: { lx_error->get_text( ) } | &&
          |{ lx_error->get_longtext( ) }|.

        ls_form-billingdocument = lv_billingdocument.
        ls_form-filename         =
          |Error_{ lv_billingdocument }.txt|.
        ls_form-mimetype         = 'text/plain'.

        ls_form-Form_DeliveryChallan =
          cl_abap_conv_codepage=>create_out( )->convert(
            source = lv_text
          ).

    ENDTRY.

    APPEND ls_form TO lt_form.

    "Set query data response
    io_response->set_data( lt_form ).

    "Mandatory when RAP requests the total record count
    io_response->set_total_number_of_records(
      lines( lt_form )
    ).

  ENDMETHOD.

ENDCLASS.
