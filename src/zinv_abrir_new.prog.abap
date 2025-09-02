*&---------------------------------------------------------------------*
*& Report ZINV_ABRIR_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zinv_abrir_new.

INCLUDE zinv_abrir_new_top.

INCLUDE zinv_abrir_new_f01.


AT SELECTION-SCREEN.

  PERFORM valida USING p_MATNR.


START-OF-SELECTION.

  PERFORM create_zinv CHANGING gv_idinv gv_data.

  PERFORM alv_event.
