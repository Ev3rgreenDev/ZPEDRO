*&---------------------------------------------------------------------*
*& Include          ZRES_CRIAR_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZMOV
  lt_tab_zres    TYPE TABLE OF zres,
  ls_est_zres    TYPE zres,
  ls_itab_zres   TYPE zres,

  " VARIAVEIS LOCAIS
  lr_alv         TYPE REF TO cl_salv_table,
  lv_data        TYPE dats,
  lv_IDRES       TYPE ze_guid32,
  lv_TPMOV       TYPE ze_tpmov,
  lv_HORA        TYPE tims,
  lv_status      TYPE ze_stat_res,
  lv_qty_res     TYPE ze_qty3.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_LOCID TYPE ze_LOCID OBLIGATORY,
              p_QTY   TYPE ze_QTY3  OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
