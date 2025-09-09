*&---------------------------------------------------------------------*
*& Include          ZCUST_TOP
*&---------------------------------------------------------------------*

INCLUDE zcust_types.
INCLUDE zcust_const.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_CPF   TYPE ze_CPF2 OBLIGATORY,
              p_NOME  TYPE ze_NOME OBLIGATORY,
              p_ATIVO TYPE ze_FLAG.

SELECTION-SCREEN END OF BLOCK b01.
