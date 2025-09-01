*&---------------------------------------------------------------------*
*& Include          ZINV_CONTAR_NEW_TOP
*&---------------------------------------------------------------------*

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZINV
  lt_tab_ZINV    TYPE TABLE OF zinv,
  ls_itab_ZINV   TYPE zinv,

  " VARIAVEIS
  lr_alv         TYPE REF TO cl_salv_table,
  lv_data        TYPE dats,
  c_status      TYPE C LENGTH 1 VALUE 'A'.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_IDINV TYPE ze_guid32 OBLIGATORY,
              p_QTY   TYPE ze_qty3 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
