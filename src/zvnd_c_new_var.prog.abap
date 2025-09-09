*&---------------------------------------------------------------------*
*& Include          ZVND_C_NEW_VAR
*&---------------------------------------------------------------------*

CLASS lcl_report DEFINITION DEFERRED.

DATA: ok_code      TYPE sy-ucomm,
      gv_campos    TYPE string,

      " ALV
      go_alv       TYPE REF TO cl_salv_table,
      go_container TYPE REF TO cl_gui_custom_container,
      gv_message   TYPE REF TO cx_salv_msg,
      go_report    TYPE REF TO lcl_report,
      oref         TYPE REF TO cx_root.
