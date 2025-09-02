*&---------------------------------------------------------------------*
*& Report ZSTK_TRF_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstk_trf_new.

INCLUDE zstk_trf_new_top.
INCLUDE zstk_trf_new_f01.


AT SELECTION-SCREEN.

  PERFORM valida USING p_MATNR.
  PERFORM get_dt_hr CHANGING gv_data gv_hora.


START-OF-SELECTION.

PERFORM check_qty.

PERFORM check_destin CHANGING gv_destin.

PERFORM get_stock.

PERFORM update_qty_origem CHANGING gv_qty_origem.

PERFORM update_qty_destino CHANGING gv_qty_destino.

PERFORM create_qty_destino CHANGING gs_itab_zstock.

PERFORM create_zmov_origem CHANGING gv_idmov gs_itab_zmov.

PERFORM create_zmov_destino CHANGING gv_idmov gs_itab_zmov.

PERFORM alv_event.
