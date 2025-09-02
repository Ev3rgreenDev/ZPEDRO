*&---------------------------------------------------------------------*
*& Include          ZINV_PROCESSAR_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  gt_tab_zstock  TYPE TABLE OF zstock,
  gs_est_zstock  TYPE zsstock,
  gs_itab_zstock TYPE zstock,

  " TABELA ZINV
  gt_tab_ZINV    TYPE TABLE OF zinv,
  gs_itab_ZINV   TYPE zinv,

  " TABELA ZMOV
  gt_tab_zmov    TYPE TABLE OF zmov,
  gs_est_zmov    TYPE zsmov,
  gs_itab_zmov   TYPE zmov,

  " VARIAVEIS
  gr_alv         TYPE REF TO cl_salv_table,
  gv_data        TYPE dats,
  gv_dif         TYPE ze_qty3,
  gv_qty_stock   TYPE ze_qty3,
  gv_qty_final   TYPE ze_qty3,
  gv_IDMOV       TYPE ze_guid32,
  gc_TPMOV       TYPE c LENGTH 2 VALUE 'AJ',
  gv_HORA        TYPE tims,
  gv_obs         TYPE ze_obs,
  gc_status      TYPE c LENGTH 1 VALUE 'P'.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_IDINV TYPE ze_guid32 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
