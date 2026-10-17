CLASS lhc_ZR_BILLING_PRINT_HEAD DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      keys REQUEST requested_authorizations FOR zr_billing_print_head RESULT result.

*    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
*      REQUEST requested_authorizations FOR zr_billing_print_head RESULT result.

*    METHODS create FOR MODIFY
*       entities FOR CREATE zr_billing_print_head.
*
*    METHODS update FOR MODIFY
*       entities FOR UPDATE zr_billing_print_head.
*
*    METHODS delete FOR MODIFY
*       keys FOR DELETE zr_billing_print_head.

    METHODS read FOR READ
       keys FOR READ zr_billing_print_head RESULT result.

    METHODS lock FOR LOCK
       keys FOR LOCK zr_billing_print_head.

    METHODS rba_Item FOR READ
       keys_rba FOR READ zr_billing_print_head\_Item FULL result_requested RESULT result LINK association_links.

    METHODS cba_Item FOR MODIFY
       entities_cba FOR CREATE zr_billing_print_head\_Item.

ENDCLASS.

CLASS lhc_ZR_BILLING_PRINT_HEAD IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

*  METHOD get_global_authorizations.
*  ENDMETHOD.
*
*  METHOD create.
*  ENDMETHOD.
*
*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.

  METHOD read.
  ENDMETHOD.

  METHOD lock.
  ENDMETHOD.

  METHOD rba_Item.
  ENDMETHOD.

  METHOD cba_Item.
  ENDMETHOD.

ENDCLASS.

CLASS lhc_ZR_BILLING_PRINT_ITEM DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

*    METHODS update FOR MODIFY
*       entities FOR UPDATE zr_billing_print_item.
*
*    METHODS delete FOR MODIFY
*       keys FOR DELETE zr_billing_print_item.

*    METHODS read FOR READ
*       keys FOR READ zr_billing_print_item RESULT result.

    METHODS rba_Head FOR READ
       keys_rba FOR READ zr_billing_print_item\_Head FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lhc_ZR_BILLING_PRINT_ITEM IMPLEMENTATION.

*  METHOD update.
*  ENDMETHOD.
*
*  METHOD delete.
*  ENDMETHOD.
*
*  METHOD read.
*  ENDMETHOD.

  METHOD rba_Head.
  ENDMETHOD.

ENDCLASS.

CLASS lsc_ZR_BILLING_PRINT_HEAD DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS finalize REDEFINITION.

    METHODS check_before_save REDEFINITION.

    METHODS save REDEFINITION.

    METHODS cleanup REDEFINITION.

    METHODS cleanup_finalize REDEFINITION.

ENDCLASS.

CLASS lsc_ZR_BILLING_PRINT_HEAD IMPLEMENTATION.

  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
  ENDMETHOD.

  METHOD cleanup.
  ENDMETHOD.

  METHOD cleanup_finalize.
  ENDMETHOD.

ENDCLASS.
