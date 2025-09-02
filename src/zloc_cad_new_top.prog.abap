*&---------------------------------------------------------------------*
*& Include          ZLOC_CAD_NEW_TOP
*&---------------------------------------------------------------------*

DATA:
      gt_tab_zloc  TYPE TABLE OF zloc,
      gs_est_zloc  TYPE zsloc,
      gs_itab_zloc TYPE zloc,
      gr_alv       TYPE REF TO cl_salv_table,
      gv_locid     TYPE ze_locid.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_LOCID TYPE ze_LOCID OBLIGATORY,
              p_DESCR TYPE ze_DESCR,
              p_ATIVO TYPE ze_flag.

SELECTION-SCREEN END OF BLOCK b01.
