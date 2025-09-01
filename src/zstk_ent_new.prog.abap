*&---------------------------------------------------------------------*
*& Report ZSTK_ENT_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZSTK_ENT_NEW.

INCLUDE ZSTK_ENT_NEW_TOP.

INCLUDE ZSTK_ENT_NEW_F01.


START-OF-SELECTION.

PERFORM check_stock CHANGING ls_itab_zstock.

PERFORM update_stock USING ls_itab_zstock p_QTY changing lv_qty.

PERFORM create_stock USING lv_matnr CHANGING ls_itab_zstock.

PERFORM create_zmov USING p_QTY lv_qty CHANGING lv_idmov ls_itab_zmov.

PERFORM alv_event.
