*&---------------------------------------------------------------------*
*& Report ZSTK_SAI_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstk_sai_new.

INCLUDE zstk_sai_new_top.

INCLUDE zstk_sai_new_f01.


AT SELECTION-SCREEN.

  PERFORM valida_matnr USING p_matnr.


START-OF-SELECTION.

  PERFORM check_stock CHANGING gs_itab_zstock.

  PERFORM update_stock CHANGING gv_qty.

  PERFORM create_zmov CHANGING gv_idmov gs_itab_zmov.

  PERFORM alv_event.
