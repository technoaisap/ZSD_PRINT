CLASS zcl_bill_item_batch_qp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_rap_query_provider.

    TYPES:
      BEGIN OF ty_batch_result,
        firstbatch TYPE c LENGTH 70,
        lastbatch  TYPE c LENGTH 70,
        batchrange TYPE c LENGTH 144,
      END OF ty_batch_result.

    " Reusable from the PDF provider later
    CLASS-METHODS get_batch_range
      IMPORTING
        iv_delivery_document TYPE
          i_billingdocumentitem-referencesddocument
        iv_delivery_item     TYPE
          i_billingdocumentitem-referencesddocumentitem
      RETURNING
        VALUE(rs_batch)      TYPE ty_batch_result.
  PROTECTED SECTION.
  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_result,
        billingdocument     TYPE c LENGTH 10,
        billingdocumentitem TYPE n LENGTH 6,
        firstbatch          TYPE c LENGTH 70,
        lastbatch           TYPE c LENGTH 70,
        batchrange          TYPE c LENGTH 144,
      END OF ty_result,

      tt_result TYPE STANDARD TABLE OF ty_result
        WITH EMPTY KEY.
ENDCLASS.



CLASS zcl_bill_item_batch_qp IMPLEMENTATION.
  METHOD get_batch_range.

    DATA:
      lv_first_batch TYPE i_clfnobjectcharcvalue-charcvalue,
      lv_last_batch  TYPE i_clfnobjectcharcvalue-charcvalue,
      lv_batch_value TYPE i_clfnobjectcharcvalue-charcvalue.

    IF iv_delivery_document IS NOT INITIAL
       AND iv_delivery_item IS NOT INITIAL.

      SELECT deliverydocumentitem,
             batch,
             plant
        FROM i_deliverydocumentitem
        WHERE deliverydocument = @iv_delivery_document
          AND higherlvlitmofbatspltitm = @iv_delivery_item
        ORDER BY deliverydocumentitem ASCENDING
        INTO TABLE @DATA(lt_del_split).

      LOOP AT lt_del_split INTO DATA(ls_del_split).

        IF ls_del_split-batch IS INITIAL.
          CONTINUE.
        ENDIF.

        CLEAR lv_batch_value.

        " Same lookup as the existing BAdI: batch + plant
        SELECT DISTINCT batch,
                        material,
                        plant,
                        clfnobjectinternalid
          FROM i_batch
          WHERE batch = @ls_del_split-batch
            AND plant = @ls_del_split-plant
          INTO TABLE @DATA(lt_batch_obj).

        LOOP AT lt_batch_obj INTO DATA(ls_batch_obj)
          WHERE clfnobjectinternalid IS NOT INITIAL.

          SELECT charcvalue
            FROM i_clfnobjectcharcvalue
            WHERE clfnobjectinternalid =
                  @ls_batch_obj-clfnobjectinternalid
            INTO TABLE @DATA(lt_char_values).

          " Same selection as the existing BAdI
          READ TABLE lt_char_values
            INTO DATA(ls_char_value)
            INDEX 1.

          IF sy-subrc = 0
             AND ls_char_value-charcvalue IS NOT INITIAL.

            lv_batch_value = ls_char_value-charcvalue.
            EXIT.

          ENDIF.

        ENDLOOP.

        " Fall back to the SAP batch number
        IF lv_batch_value IS INITIAL.
          lv_batch_value = ls_del_split-batch.
        ENDIF.

        IF lv_first_batch IS INITIAL.
          lv_first_batch = lv_batch_value.
        ENDIF.

        lv_last_batch = lv_batch_value.

      ENDLOOP.

    ENDIF.

    rs_batch-firstbatch = lv_first_batch.
    rs_batch-lastbatch  = lv_last_batch.

    " Preserve the original BAdI formatting
    rs_batch-batchrange =
      |{ lv_first_batch } TO { lv_last_batch }|.

  ENDMETHOD.


  METHOD if_rap_query_provider~select.

    DATA:
      lt_result          TYPE tt_result,
      lt_page            TYPE tt_result,

      lr_billingdocument TYPE RANGE OF
        i_billingdocumentitem-billingdocument,

      lr_billingitem     TYPE RANGE OF
        i_billingdocumentitem-billingdocumentitem.

    IF io_request->is_data_requested( ) = abap_false
       AND io_request->is_total_numb_of_rec_requested( )
           = abap_false.
      RETURN.
    ENDIF.

    " This provider does not implement free-text search
    IF io_request->get_search_expression( ) IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_bill_batch_query.
    ENDIF.

    " This provider returns detail rows, not aggregations
    IF io_request->get_aggregation(
         )->get_aggregated_elements( ) IS NOT INITIAL
       OR io_request->get_aggregation(
         )->get_grouped_elements( ) IS NOT INITIAL.
      RAISE EXCEPTION TYPE zcx_bill_batch_query.
    ENDIF.

    " Read request filters
    TRY.
        DATA(lt_filters) =
          io_request->get_filter( )->get_as_ranges( ).

      CATCH cx_rap_query_filter_no_range INTO DATA(lx_filter).
        RAISE EXCEPTION TYPE zcx_bill_batch_query
          EXPORTING
            previous = lx_filter.
    ENDTRY.

    LOOP AT lt_filters INTO DATA(ls_filter).

      CASE ls_filter-name.

        WHEN 'BILLINGDOCUMENT'.
          lr_billingdocument =
            CORRESPONDING #( ls_filter-range ).

        WHEN 'BILLINGDOCUMENTITEM'.
          lr_billingitem =
            CORRESPONDING #( ls_filter-range ).

        WHEN OTHERS.
          " Filtering on calculated batch fields
          " is not implemented in this version
          RAISE EXCEPTION TYPE zcx_bill_batch_query.

      ENDCASE.

    ENDLOOP.

    " Require explicit billing document numbers
    IF lr_billingdocument IS INITIAL.
*      RAISE EXCEPTION TYPE zcx_bill_batch_query.
      " Initial request without a billing document filter
      IF lr_billingdocument IS INITIAL.

        " Read query options before returning an empty result
        DATA(lo_empty_paging) = io_request->get_paging( ).
        DATA(lv_empty_offset) = lo_empty_paging->get_offset( ).
        DATA(lv_empty_size)   = lo_empty_paging->get_page_size( ).

        DATA(lt_empty_sort) =
          io_request->get_sort_elements( ).

        DATA(lt_empty_requested) =
          io_request->get_requested_elements( ).

        CLEAR lt_result.

        IF io_request->is_total_numb_of_rec_requested( ).
          io_response->set_total_number_of_records( 0 ).
        ENDIF.

        IF io_request->is_data_requested( ).
          io_response->set_data( lt_result ).
        ENDIF.

        RETURN.

      ENDIF.
    ENDIF.

    LOOP AT lr_billingdocument INTO DATA(ls_document_filter).

      IF ls_document_filter-sign <> 'I'
         OR ls_document_filter-option <> 'EQ'
         OR ls_document_filter-low IS INITIAL.

        RAISE EXCEPTION TYPE zcx_bill_batch_query.

      ENDIF.

    ENDLOOP.

    " Fetch the billing items and their delivery references
    SELECT billingdocument,
           billingdocumentitem,
           referencesddocument,
           referencesddocumentitem
      FROM i_billingdocumentitem
      WHERE billingdocument IN @lr_billingdocument
        AND billingdocumentitem IN @lr_billingitem
      INTO TABLE @DATA(lt_bill_items).

    LOOP AT lt_bill_items INTO DATA(ls_bill_item).

      DATA(ls_batch) = get_batch_range(
        iv_delivery_document =
          ls_bill_item-referencesddocument
        iv_delivery_item =
          ls_bill_item-referencesddocumentitem
      ).

      APPEND VALUE #(
        billingdocument =
          ls_bill_item-billingdocument
        billingdocumentitem =
          ls_bill_item-billingdocumentitem
        firstbatch = ls_batch-firstbatch
        lastbatch  = ls_batch-lastbatch
        batchrange = ls_batch-batchrange
      ) TO lt_result.

    ENDLOOP.

    " Sort before applying paging
    DATA lt_sort TYPE abap_sortorder_tab.

    LOOP AT io_request->get_sort_elements( )
      INTO DATA(ls_sort).

      DATA(lv_sort_name) =
        to_upper( ls_sort-element_name ).

      CASE lv_sort_name.
        WHEN 'BILLINGDOCUMENT'
          OR 'BILLINGDOCUMENTITEM'
          OR 'FIRSTBATCH'
          OR 'LASTBATCH'
          OR 'BATCHRANGE'.

          APPEND VALUE #(
            name       = lv_sort_name
            descending = ls_sort-descending
          ) TO lt_sort.

        WHEN OTHERS.
          RAISE EXCEPTION TYPE zcx_bill_batch_query.
      ENDCASE.

    ENDLOOP.

    " Add keys as tie-breakers for stable paging
    IF NOT line_exists(
      lt_sort[ name = 'BILLINGDOCUMENT' ] ).

      APPEND VALUE #(
        name = 'BILLINGDOCUMENT'
      ) TO lt_sort.

    ENDIF.

    IF NOT line_exists(
      lt_sort[ name = 'BILLINGDOCUMENTITEM' ] ).

      APPEND VALUE #(
        name = 'BILLINGDOCUMENTITEM'
      ) TO lt_sort.

    ENDIF.

    SORT lt_result BY (lt_sort).

    " Count must be calculated before paging
    IF io_request->is_total_numb_of_rec_requested( ).
      io_response->set_total_number_of_records(
        lines( lt_result )
      ).
    ENDIF.

    IF io_request->is_data_requested( ).

      DATA(lv_offset) =
        io_request->get_paging( )->get_offset( ).

      DATA(lv_page_size) =
        io_request->get_paging( )->get_page_size( ).

      LOOP AT lt_result INTO DATA(ls_result).

        IF sy-tabix <= lv_offset.
          CONTINUE.
        ENDIF.

        IF lv_page_size <>
           if_rap_query_paging=>page_size_unlimited.

          IF lines( lt_page ) >= lv_page_size.
            EXIT.
          ENDIF.

        ENDIF.

        APPEND ls_result TO lt_page.

      ENDLOOP.

      io_response->set_data( lt_page ).

    ENDIF.

  ENDMETHOD.

ENDCLASS.
