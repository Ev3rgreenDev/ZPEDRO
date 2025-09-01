*&---------------------------------------------------------------------*
*& Report ZRES_CRIAR_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zres_criar_new.

INCLUDE zres_criar_new_top.

INCLUDE zres_criar_new_f01.


AT SELECTION-SCREEN.

  PERFORM valida_matnr_locid.

  PERFORM valida_qty.

  PERFORM set_data CHANGING lv_data.



START-OF-SELECTION.

  PERFORM mov CHANGING lv_idres ls_itab_zres.

  PERFORM alv_event.
