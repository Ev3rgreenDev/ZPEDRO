*&---------------------------------------------------------------------*
*& Report ZRES_REPOR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zres_repor.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR,
              p_LOCID TYPE ze_LOCID,
              p_QTY_M TYPE ze_QTY3,
              p_QTY_A TYPE ze_QTY3.

SELECTION-SCREEN END OF BLOCK b01.

DATA: "TABELA ZSTOCK
  lt_tab_zstock      TYPE TABLE OF zstock,
  ls_est_zstock      TYPE zsstock,
  ls_itab_zstock     TYPE zstock,
  lt_tab_zstock_aux  TYPE TABLE OF zstock_aux,
  ltt_est_zstock_aux TYPE zttstock_aux,
  ls_itab_zstock_aux TYPE zstock_aux,

  " TABELA ZMOV
  lt_tab_zmov        TYPE TABLE OF zmov,
  ls_est_zmov        TYPE zsmov,
  ls_itab_zmov       TYPE zmov,

  " ALV
  lr_alv             TYPE REF TO cl_salv_table,
  lo_agregador       TYPE REF TO cl_salv_aggregations,
  oref               TYPE REF TO cx_root,
  lo_sort            TYPE REF TO cl_salv_sorts,
  lo_sort_column     TYPE REF TO cl_salv_sort,

  " VARIAVEIS LOCAIS
  lv_data            TYPE dats,
  lv_IDMOV           TYPE ze_guid32,
  lv_TPMOV           TYPE ze_tpmov,
  lv_HORA            TYPE tims,
  lv_qty_origem      TYPE ze_qty3,
  lv_qty_destino     TYPE ze_qty3,
  lv_campos          TYPE string,
  lv_qty_sug         TYPE ze_qty3.



AT SELECTION-SCREEN.

  lv_campos = 'QTY LE p_QTY_M'.

  IF p_MATNR IS NOT INITIAL.

    CONCATENATE lv_campos ' AND MATNR = p_MATNR' INTO lv_campos RESPECTING BLANKS.

  ENDIF.

  IF p_LOCID IS NOT INITIAL AND lv_campos IS INITIAL.

    CONCATENATE lv_campos ' AND LOCID = p_LOCID' INTO lv_campos RESPECTING BLANKS.

  ELSEIF p_LOCID IS NOT INITIAL AND lv_campos IS NOT INITIAL.

    CONCATENATE lv_campos ' AND LOCID = p_LOCID'  INTO lv_campos RESPECTING BLANKS.

  ENDIF.



START-OF-SELECTION.


  SELECT *
    FROM zstock
    INTO TABLE lt_tab_zstock
    WHERE (lv_campos).



  LOOP AT lt_tab_zstock INTO ls_itab_zstock_aux.

    lv_qty_sug = p_QTY_A - ls_itab_zstock_aux-qty.

    MOVE lv_qty_sug TO ls_itab_zstock_aux-qty_sug.

    APPEND ls_itab_zstock_aux TO lt_tab_zstock_aux.

  ENDLOOP.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = lr_alv
        CHANGING
          t_table      = lt_tab_zstock_aux.

    CATCH cx_salv_msg.

  ENDTRY.

  CALL METHOD lr_alv->display.

  CLEAR lt_tab_zstock_aux.
