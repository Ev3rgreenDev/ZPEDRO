*&---------------------------------------------------------------------*
*& Include          ZRES_CANCEL_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  gt_tab_zstock  TYPE TABLE OF zstock,
  gs_est_zstock  TYPE zsstock,
  gs_itab_zstock TYPE zstock,

  " TABELA ZRES
  gt_tab_zres    TYPE TABLE OF zres,
  gs_est_zres    TYPE zres,
  gs_itab_zres   TYPE zres,

  " TABELA ZMOV
  gt_tab_zmov    TYPE TABLE OF zmov,
  gs_est_zmov    TYPE zsmov,
  gs_itab_zmov   TYPE zmov,

  " VARIAVEIS
  gr_alv         TYPE REF TO cl_salv_table,
  gv_data        TYPE dats,
  gv_IDRES       TYPE ze_guid32,
  gv_idmov       TYPE ze_guid32,
  gv_TPMOV       TYPE ze_tpmov,
  gv_HORA        TYPE tims,
  gc_status_A    TYPE c LENGTH 1 VALUE 'A',
  gc_status_C    TYPE c LENGTH 1 VALUE 'C',
  gv_qty_res     TYPE ze_qty3,
  gv_qty_final   TYPE ze_qty3,
  gv_qty_stock   TYPE ze_qty3.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_IDRES TYPE ze_GUID32 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
