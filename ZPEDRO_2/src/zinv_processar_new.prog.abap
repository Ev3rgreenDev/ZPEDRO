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

  PERFORM get_zinv CHANGING gs_itab_zinv.

  PERFORM get_stock CHANGING gv_qty_stock gv_dif.

  PERFORM update_zstock_add CHANGING gv_qty_final.

  PERFORM update_zstock_sub CHANGING gv_qty_final.

  PERFORM update_zinv.

  PERFORM mov CHANGING gv_idmov gs_itab_zmov.

  PERFORM alv_event.
