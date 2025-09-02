*&---------------------------------------------------------------------*
*& Include          ZSTK_ENT_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  gt_tab_zstock  TYPE TABLE OF zstock,
  gs_est_zstock  TYPE zsstock,
  gs_itab_zstock TYPE zstock,

  " TABELA ZMOV
  gt_tab_zmov    TYPE TABLE OF zmov,
  gs_est_zmov    TYPE zsmov,
  gs_itab_zmov   TYPE zmov,

  " VARIAVEIS
  gr_alv         TYPE REF TO cl_salv_table,
  gv_data        TYPE dats,
  gv_IDMOV       TYPE ze_guid32,
  gc_TPMOV        TYPE c LENGTH 2 VALUE 'EN',
  gv_HORA        TYPE tims,
  gv_qty         TYPE ze_qty3,
  gv_matnr       TYPE ze_matnr.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_LOCID TYPE ze_LOCID OBLIGATORY,
              p_QTY   TYPE ze_QTY3 OBLIGATORY,
              p_OBS   TYPE ze_OBS.

SELECTION-SCREEN END OF BLOCK b01.
