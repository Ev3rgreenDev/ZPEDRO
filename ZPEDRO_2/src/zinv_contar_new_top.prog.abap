*&---------------------------------------------------------------------*
*& Include          ZINV_CONTAR_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  gt_tab_zstock  TYPE TABLE OF zstock,
  gs_est_zstock  TYPE zsstock,
  gs_itab_zstock TYPE zstock,

  " TABELA ZINV
  gt_tab_ZINV    TYPE TABLE OF zinv,
  gs_itab_ZINV   TYPE zinv,

  " VARIAVEIS
  gr_alv         TYPE REF TO cl_salv_table,
  gv_data        TYPE dats,
  gc_status      TYPE C LENGTH 1 VALUE 'A'.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_IDINV TYPE ze_guid32 OBLIGATORY,
              p_QTY   TYPE ze_qty3   OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
