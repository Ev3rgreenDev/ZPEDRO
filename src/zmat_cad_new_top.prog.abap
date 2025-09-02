*&---------------------------------------------------------------------*
*& Include          ZMAT_CAD_NEW_TOP
*&---------------------------------------------------------------------*

DATA: " TABELA ZMAT
      gt_tab_zmat  TYPE TABLE OF zmat,
      gs_est_zmat  TYPE zsmat,
      gs_itab_zmat TYPE zmat,
      gt_ttab_zmat TYPE zttmat,

      " ALV
      gr_alv       TYPE REF TO cl_salv_table,

      " VARIAVEIS
      gv_matnr     TYPE ze_matnr.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_DESCR TYPE ze_DESCR OBLIGATORY,
              p_UNID  TYPE ze_UNID  OBLIGATORY,
              p_ATIVO TYPE ze_FLAG  OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.
