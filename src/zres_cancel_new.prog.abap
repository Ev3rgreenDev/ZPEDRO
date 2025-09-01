*&---------------------------------------------------------------------*
*& Report ZRES_CANCEL_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zres_cancel_new.

INCLUDE zres_cancel_new_top.

INCLUDE zres_cancel_new_f01.

AT SELECTION-SCREEN.

  PERFORM valida.


START-OF-SELECTION.

PERFORM update_zres.

PERFORM alv_event.
