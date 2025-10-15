*&---------------------------------------------------------------------*
*& Include          ZPRICE_TOP
*&---------------------------------------------------------------------*

INCLUDE zprice_types.
INCLUDE zprice_vars.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR  TYPE ze_MATNR OBLIGATORY,
              p_VLD_FR TYPE dats     OBLIGATORY,
              p_VLD_TO TYPE dats     OBLIGATORY,
              p_PRICE  TYPE ze_PRICE OBLIGATORY,
              p_waers  TYPE tcurc-waers  MATCHCODE OBJECT rscurrency OBLIGATORY,
*              p_CURR   TYPE ze_CUKY5 OBLIGATORY,
              p_ATIVO  TYPE ze_FLAG.

SELECTION-SCREEN END OF BLOCK b01.
