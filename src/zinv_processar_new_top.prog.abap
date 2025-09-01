*&---------------------------------------------------------------------*
*& Include          ZINV_PROCESSAR_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZINV
  lt_tab_ZINV    TYPE TABLE OF zinv,
  ls_itab_ZINV   TYPE zinv,

  " TABELA ZMOV
  lt_tab_zmov    TYPE TABLE OF zmov,
  ls_est_zmov    TYPE zsmov,
  ls_itab_zmov   TYPE zmov,

  " VARIAVEIS LOCAIS
  lr_alv         TYPE REF TO cl_salv_table,
  lv_data        TYPE dats,
  lv_dif         TYPE ze_qty3,
  lv_qty_stock   TYPE ze_qty3,
  lv_qty_final   TYPE ze_qty3,
  lv_IDMOV       TYPE ze_guid32,
  lv_TPMOV       TYPE ze_tpmov,
  lv_HORA        TYPE tims,
  lv_obs         TYPE ze_obs.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_IDINV TYPE ze_guid32 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
