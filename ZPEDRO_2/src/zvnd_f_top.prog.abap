*&---------------------------------------------------------------------*
*& Include          ZVND_F_TOP
*&---------------------------------------------------------------------*

INCLUDE zvnd_f_types.

INCLUDE zvnd_f_var.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_VBELN  TYPE vbeln OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
