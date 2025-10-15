*&---------------------------------------------------------------------*
*& Include          ZVND_H_TOP
*&---------------------------------------------------------------------*

INCLUDE zvnd_h_types.
INCLUDE zvnd_h_var.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_CUSTID TYPE ze_CUSTID OBLIGATORY,
              p_MOEDA  TYPE tcurc-waers  MATCHCODE OBJECT rscurrency OBLIGATORY,
              p_OBS    TYPE ZE_OBS.

SELECTION-SCREEN END OF BLOCK b01.
