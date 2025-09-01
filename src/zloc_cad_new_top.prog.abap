*&---------------------------------------------------------------------*
*& Include          ZLOC_CAD_NEW_TOP
*&---------------------------------------------------------------------*

DATA:
      lt_tab_zloc  TYPE TABLE OF zloc,
      ls_est_zloc  TYPE zsloc,
      ls_itab_zloc TYPE zloc,
      lr_alv       TYPE REF TO cl_salv_table,
      lv_locid     TYPE ze_locid.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_LOCID TYPE ze_LOCID OBLIGATORY,
              p_DESCR TYPE ze_DESCR,
              p_ATIVO TYPE ze_flag.

SELECTION-SCREEN END OF BLOCK b01.
