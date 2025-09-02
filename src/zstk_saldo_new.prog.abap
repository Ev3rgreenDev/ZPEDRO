*&---------------------------------------------------------------------*
*& Report ZSTK_SALDO_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstk_saldo_new.

INCLUDE zstk_saldo_new_top.

INCLUDE zstk_saldo_f01.


AT SELECTION-SCREEN.

  PERFORM valida USING p_MATNR p_LOCID.


START-OF-SELECTION.

  PERFORM get_string CHANGING gv_string.

  PERFORM alv_event USING gv_string.
