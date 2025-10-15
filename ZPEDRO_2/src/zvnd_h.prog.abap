*&---------------------------------------------------------------------*
*& Report ZVND_H
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvnd_h.

INCLUDE zvnd_h_top.
INCLUDE zvnd_h_f01.

AT SELECTION-SCREEN.
  PERFORM valida_parameters USING p_CUSTID p_MOEDA.


START-OF-SELECTION.

  PERFORM create_zvnd_h USING p_CUSTID p_MOEDA p_OBS CHANGING gwa_zvnd_h gv_vbeln.

  PERFORM alv_event.
