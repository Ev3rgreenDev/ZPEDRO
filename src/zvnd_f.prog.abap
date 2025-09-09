*&---------------------------------------------------------------------*
*& Report ZVND_F
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvnd_f.

INCLUDE zvnd_f_top.

INCLUDE zvnd_f_f01.


AT SELECTION-SCREEN.

  PERFORM valida_pedido USING p_VBELN.


START-OF-SELECTION.

  PERFORM change_status USING p_VBELN.

  PERFORM alv_event.
