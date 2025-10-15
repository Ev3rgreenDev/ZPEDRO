*&---------------------------------------------------------------------*
*& Report ZRES_USAR_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zres_usar_new.

INCLUDE zres_usar_new_top.

INCLUDE zres_usar_new_f01.


AT SELECTION-SCREEN.

  PERFORM valida.

  PERFORM set_var CHANGING gv_data gv_hora.


 START-OF-SELECTION.

  PERFORM get_zres CHANGING gs_itab_zres.

  PERFORM get_stock CHANGING gv_qty_stock.

  PERFORM valida_qty_set_qty USING gv_qty_stock gs_itab_zres CHANGING gv_qty_final.

  PERFORM update_zstock USING gv_qty_final gv_data.

  PERFORM mov CHANGING gv_idmov gs_itab_zmov.

  PERFORM update_zres.

  PERFORM alv_event.
