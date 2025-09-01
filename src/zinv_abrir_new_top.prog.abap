*&---------------------------------------------------------------------*
*& Include          ZINV_ABRIR_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZINV
  lt_tab_ZINV    TYPE TABLE OF zinv,
  ls_itab_ZINV   TYPE zinv,

  " ALV
  lr_alv         TYPE REF TO cl_salv_table,
  lo_agregador   TYPE REF TO cl_salv_aggregations,
  oref           TYPE REF TO cx_root,
  lo_sort        TYPE REF TO cl_salv_sorts,
  lo_sort_column TYPE REF TO cl_salv_sort,

  " VARIAVEIS LOCAIS
  lv_data        TYPE dats,
  lv_IDINV       TYPE ze_guid32,
  lv_status      TYPE ze_stat_inv,
  lv_HORA        TYPE tims,
  lv_qty_origem  TYPE ze_qty3,
  lv_qty_destino TYPE ze_qty3,
  lv_saida       TYPE ze_qty3,
  lv_campos      TYPE string.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_LOCID TYPE ze_LOCID OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
