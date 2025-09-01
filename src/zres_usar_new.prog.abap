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

  PERFORM set_var CHANGING lv_data lv_hora.


 START-OF-SELECTION.

  PERFORM get_zres CHANGING ls_itab_zres.

  PERFORM get_stock CHANGING lv_qty_stock.

  PERFORM valida_qty_set_qty USING lv_qty_stock ls_itab_zres CHANGING lv_qty_final.

  PERFORM update_zstock USING lv_qty_final lv_data.

  PERFORM mov CHANGING lv_idmov ls_itab_zmov.

  PERFORM update_zres.

  PERFORM alv_event.
