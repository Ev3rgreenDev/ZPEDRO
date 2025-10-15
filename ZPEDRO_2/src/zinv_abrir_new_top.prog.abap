*&---------------------------------------------------------------------*
*& Include          ZINV_ABRIR_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  gt_tab_zstock  TYPE TABLE OF zstock,
  gs_est_zstock  TYPE zsstock,
  gs_itab_zstock TYPE zstock,

  " TABELA ZINV
  gt_tab_ZINV    TYPE TABLE OF zinv,
  gs_itab_ZINV   TYPE zinv,

  " ALV
  gr_alv         TYPE REF TO cl_salv_table,
  go_agregador   TYPE REF TO cl_salv_aggregations,
  oref           TYPE REF TO cx_root,
  go_sort        TYPE REF TO cl_salv_sorts,
  go_sort_column TYPE REF TO cl_salv_sort,

  " VARIAVEIS
  gv_data        TYPE dats,
  gv_IDINV       TYPE ze_guid32,
  gc_status      TYPE c LENGTH 1 VALUE 'A',
  gv_HORA        TYPE tims,
  gv_qty_origem  TYPE ze_qty3,
  gv_qty_destino TYPE ze_qty3,
  gv_saida       TYPE ze_qty3,
  gv_campos      TYPE string.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_LOCID TYPE ze_LOCID OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
