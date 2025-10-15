*&---------------------------------------------------------------------*
*& Include          ZR_PP_CREATE_TOP
*&---------------------------------------------------------------------*

INCLUDE zr_pp_create_types.
INCLUDE zr_pp_create_var.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_matnr  TYPE ze_matnr,
              p_loc    TYPE ze_loc_fim,
              p_qtd    TYPE ze_qty3,
              p_bom_id TYPE ze_bom_id.

SELECTION-SCREEN END OF BLOCK b01.
