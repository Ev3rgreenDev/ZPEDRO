*&---------------------------------------------------------------------*
*& Include          ZVND_I_TOP
*&---------------------------------------------------------------------*

INCLUDE zvnd_i_types.
INCLUDE zvnd_i_var.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_VBELN TYPE vbeln    OBLIGATORY,
              p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_QTY   TYPE ze_QTY3  OBLIGATORY,
              p_DESC  TYPE ze_price OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
