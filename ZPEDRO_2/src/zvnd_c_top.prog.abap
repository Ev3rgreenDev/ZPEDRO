*&---------------------------------------------------------------------*
*& Include          ZVND_C_TOP
*&---------------------------------------------------------------------*

INCLUDE zvnd_c_types.
INCLUDE zvnd_c_var.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_vbeln  TYPE vbeln OBLIGATORY,
              p_custid TYPE ze_custid,
              p_data_i TYPE dats,
              p_data_f TYPE dats,
              p_status TYPE ze_status.

SELECTION-SCREEN END OF BLOCK b01.
