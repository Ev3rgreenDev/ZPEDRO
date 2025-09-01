*&---------------------------------------------------------------------*
*& Report ZINV_PROCESSAR_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zinv_processar_new.

INCLUDE zinv_processar_new_top.

INCLUDE zinv_processar_new_f01.


AT SELECTION-SCREEN.

  PERFORM valida.



START-OF-SELECTION.

  PERFORM get_zinv CHANGING ls_itab_zinv.

  PERFORM get_stock CHANGING lv_qty_stock lv_dif.

  PERFORM update_zstock_add CHANGING lv_qty_final.

  PERFORM update_zstock_sub CHANGING lv_qty_final.

  PERFORM update_zinv.

  PERFORM mov CHANGING lv_idmov lv_tpmov ls_itab_zmov.

  PERFORM alv_event.
