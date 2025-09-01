*&---------------------------------------------------------------------*
*& Include          ZSTK_SALDO_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZMOV
  lt_tab_zmov    TYPE TABLE OF zmov,
  ls_est_zmov    TYPE zsmov,
  ls_itab_zmov   TYPE zmov,

  " ALV
  lr_alv         TYPE REF TO cl_salv_table,
  lo_agregador   TYPE REF TO cl_salv_aggregations,
  oref           TYPE REF TO cx_root,
  lo_sort        TYPE REF TO cl_salv_sorts,
  lo_sort_column TYPE REF TO cl_salv_sort,

  " VARIAVEIS
  lv_data        TYPE dats,
  lv_IDMOV       TYPE ze_guid32,
  lv_TPMOV       TYPE ze_tpmov,
  lv_HORA        TYPE tims,
  lv_qty_origem  TYPE ze_qty3,
  lv_qty_destino TYPE ze_qty3,
  lv_string      TYPE string.



SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR,
              p_LOCID TYPE ze_LOCID.

SELECTION-SCREEN END OF BLOCK b01.
