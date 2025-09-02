*&---------------------------------------------------------------------*
*& Report ZSTK_ENT_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSTK_ENT_NEW.

INCLUDE ZSTK_ENT_NEW_TOP.

INCLUDE ZSTK_ENT_NEW_F01.


START-OF-SELECTION.

PERFORM check_stock CHANGING gs_itab_zstock.

PERFORM update_stock USING p_QTY changing gv_qty gs_itab_zstock.

PERFORM create_stock USING gv_matnr CHANGING gs_itab_zstock.

PERFORM create_zmov USING p_QTY gv_qty CHANGING gv_idmov gs_itab_zmov.

PERFORM alv_event.
