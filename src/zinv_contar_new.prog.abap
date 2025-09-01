*&---------------------------------------------------------------------*
*& Report ZINV_CONTAR_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zinv_contar_new.

INCLUDE zinv_contar_new_top.

INCLUDE zinv_contar_new_f01.

AT SELECTION-SCREEN.

  PERFORM valida CHANGING p_IDINV lv_data.


START-OF-SELECTION.

  PERFORM update_zinv USING p_QTY lv_data.

  PERFORM alv_event.
