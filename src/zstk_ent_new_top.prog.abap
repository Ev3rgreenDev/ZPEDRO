*&---------------------------------------------------------------------*
*& Include          ZSTK_ENT_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZMOV
  lt_tab_zmov    TYPE TABLE OF zmov,
  ls_est_zmov    TYPE zsmov,
  ls_itab_zmov   TYPE zmov,

  " VARIAVEIS
  lr_alv         TYPE REF TO cl_salv_table,
  lv_data        TYPE dats,
  lv_IDMOV       TYPE ze_guid32,
  c_TPMOV        TYPE c LENGTH 2 VALUE 'EN',
  lv_HORA        TYPE tims,
  lv_qty         TYPE ze_qty3,
  lv_matnr       TYPE ze_matnr.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_LOCID TYPE ze_LOCID OBLIGATORY,
              p_QTY   TYPE ze_QTY3 OBLIGATORY,
              p_OBS   TYPE ze_OBS.

SELECTION-SCREEN END OF BLOCK b01.
