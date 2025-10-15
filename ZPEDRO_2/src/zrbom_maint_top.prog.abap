*&---------------------------------------------------------------------*
*& Include          ZRBOM_MAINT_TOP
*&---------------------------------------------------------------------*

INCLUDE zrbom_maint_var.
INCLUDE zrbom_maint_types.

SELECTION-SCREEN BEGIN OF BLOCK b01.
  PARAMETERS: rb1 RADIOBUTTON GROUP ab MODIF ID bl2,
              rb2 RADIOBUTTON GROUP ab MODIF ID bl2.

SELECTION-SCREEN END OF BLOCK b01.

SELECTION-SCREEN BEGIN OF SCREEN 100.
  PARAMETERS: p_matnr TYPE ze_matnr OBLIGATORY,
              p_qtd_b TYPE ze_qty3  OBLIGATORY,
              p_ativo TYPE ze_flag.

SELECTION-SCREEN END OF SCREEN 100.

SELECTION-SCREEN BEGIN OF SCREEN 200.
  PARAMETERS: p_bom_id TYPE ze_bom_id OBLIGATORY,
              p_matnrI TYPE ze_matnr  OBLIGATORY,
              p_qtd_c  TYPE ze_qty3   OBLIGATORY,
              p_unid   TYPE ze_unid   OBLIGATORY.

SELECTION-SCREEN END OF SCREEN 200.
