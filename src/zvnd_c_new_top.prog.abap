*&---------------------------------------------------------------------*
*& Include          ZVND_C_NEW_TOP
*&---------------------------------------------------------------------*

INCLUDE ZVND_C_NEW_TYPES.
INCLUDE ZVND_C_NEW_VAR.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_vbeln  TYPE vbeln OBLIGATORY,
              p_custid TYPE ze_custid,
              p_data_i TYPE dats,
              p_data_f TYPE dats,
              p_status TYPE ze_status.

SELECTION-SCREEN END OF BLOCK b01.
