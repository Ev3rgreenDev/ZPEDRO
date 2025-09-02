*&---------------------------------------------------------------------*
*& Report ZSTK_REPOR_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstk_repor_new.

INCLUDE zstk_repor_new_top.

INCLUDE zstk_repor_new_f01.


AT SELECTION-SCREEN.

  PERFORM set_campos CHANGING gv_campos.


START-OF-SELECTION.

  PERFORM get_zstock.

  PERFORM set_zstock CHANGING gv_qty_sug gs_itab_zstock_aux.

  PERFORM alv_event.
