*&---------------------------------------------------------------------*
*& Include          ZVND_I_VAR
*&---------------------------------------------------------------------*

DATA:
  " VALORES
  gv_VAL_BRUTO TYPE ze_price,
  gv_val_desc  TYPE ze_price,
  gv_val_liq   TYPE ze_price,
  " DATA
  gv_data      TYPE dats,
  " VAR ZVND_I
  gv_posnr     TYPE posnr,

  gr_alv       TYPE REF TO cl_salv_table.
