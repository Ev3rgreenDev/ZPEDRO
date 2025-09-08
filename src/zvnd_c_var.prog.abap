*&---------------------------------------------------------------------*
*& Include          ZVND_C_VAR
*&---------------------------------------------------------------------*

DATA: gv_campos    TYPE string,

      " ALV
      gr_alv       TYPE REF TO cl_salv_table,
      go_alv       TYPE REF TO cl_gui_alv_grid,
      go_cont      TYPE REF TO cl_gui_custom_container,
      go_agregador TYPE REF TO cl_salv_aggregations,
      oref         TYPE REF TO cx_root.
