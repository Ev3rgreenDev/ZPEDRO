*&---------------------------------------------------------------------*
*& Include          ZRES_CRIAR_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  gt_tab_zstock  TYPE TABLE OF zstock,
  gs_est_zstock  TYPE zsstock,
  gs_itab_zstock TYPE zstock,

  " TABELA ZMOV
  gt_tab_zres    TYPE TABLE OF zres,
  gs_est_zres    TYPE zres,
  gs_itab_zres   TYPE zres,

  " VARIAVEIS
  gr_alv         TYPE REF TO cl_salv_table,
  gv_data        TYPE dats,
  gv_IDRES       TYPE ze_guid32,
  gv_TPMOV       TYPE ze_tpmov,
  gv_HORA        TYPE tims,
  gc_status      TYPE c LENGTH 1 VALUE 'A',
  gv_qty_res     TYPE ze_qty3.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_LOCID TYPE ze_LOCID OBLIGATORY,
              p_QTY   TYPE ze_QTY3  OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
