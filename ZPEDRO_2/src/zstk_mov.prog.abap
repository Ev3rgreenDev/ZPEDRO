*&---------------------------------------------------------------------*
*& Report ZSTK_MOV
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstk_mov.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR  TYPE ze_MATNR,
              p_LOCID  TYPE ze_LOCID,
              p_DATA_I TYPE dats,
              p_DATA_F TYPE dats,
              p_TPMOV  TYPE ze_TPMOV.

SELECTION-SCREEN END OF BLOCK b01.

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZMOV
  lt_tab_zmov    TYPE TABLE OF zmov,
  ls_est_zmov    TYPE zsmov,
  ls_itab_zmov   TYPE zmov,

  " ALV
  lr_alv         TYPE REF TO cl_salv_table,
  lo_agregador   TYPE REF TO cl_salv_aggregations,
  oref           TYPE REF TO cx_root,
  lo_sort        TYPE REF TO cl_salv_sorts,
  lo_sort_column TYPE REF TO cl_salv_sort,

  " VARIAVEIS LOCAIS
  lv_data        TYPE dats,
  lv_IDMOV       TYPE ze_guid32,
  lv_TPMOV       TYPE ze_tpmov,
  lv_HORA        TYPE tims,
  lv_qty_origem  TYPE ze_qty3,
  lv_qty_destino TYPE ze_qty3,
  lv_saida       TYPE ze_qty3,
  lv_campos      TYPE string.

" VALIDAÇÕES ANTES DE RODAR

AT SELECTION-SCREEN.

  IF p_MATNR IS NOT INITIAL.

    SELECT SINGLE matnr
      FROM zmov
      INTO p_MATNR
    WHERE matnr = p_MATNR.

    IF sy-subrc NE 0.
      MESSAGE 'Material inválido.' TYPE 'E'.
    ENDIF.
  ENDIF.

  IF p_LOCID IS NOT INITIAL.

    SELECT SINGLE locid
      FROM zmov
      INTO p_LOCID
    WHERE locid = p_LOCID.

    IF sy-subrc NE 0.
      MESSAGE 'Local inválido.' TYPE 'E'.
    ENDIF.
  ENDIF.

  IF p_DATA_F IS INITIAL.

    p_DATA_F = sy-datum.

  ENDIF.

  IF p_DATA_I GT p_DATA_F.

    MESSAGE 'Insira uma data de inicio que anteceda a data final.' TYPE 'E'.

  ENDIF.


START-OF-SELECTION.

  IF p_MATNR IS NOT INITIAL.

    CONCATENATE 'MATNR = p_MATNR' lv_campos INTO lv_campos RESPECTING BLANKS.

  ENDIF.

  IF p_LOCID IS NOT INITIAL AND lv_campos IS INITIAL.

    CONCATENATE 'LOCID = p_LOCID' lv_campos INTO lv_campos RESPECTING BLANKS.

  ELSEIF p_LOCID IS NOT INITIAL AND lv_campos IS NOT INITIAL.

    CONCATENATE lv_campos ' AND LOCID = p_LOCID'  INTO lv_campos RESPECTING BLANKS.

  ENDIF.

  IF p_DATA_I IS NOT INITIAL AND lv_campos IS INITIAL.

    CONCATENATE 'DATA GE p_DATA_I AND DATA LE p_DATA_F' lv_campos INTO lv_campos RESPECTING BLANKS.

  ELSEIF p_DATA_I IS NOT INITIAL AND lv_campos IS NOT INITIAL.

    CONCATENATE lv_campos ' AND DATA GE p_DATA_I AND DATA LE p_DATA_F' INTO lv_campos RESPECTING BLANKS.

  ENDIF.

  IF p_TPMOV IS NOT INITIAL AND lv_campos IS INITIAL.

    CONCATENATE 'TPMOV = p_TPMOV' lv_campos INTO lv_campos RESPECTING BLANKS.

  ELSEIF p_TPMOV IS NOT INITIAL AND lv_campos IS NOT INITIAL.

    CONCATENATE lv_campos ' AND TPMOV = p_TPMOV'  INTO lv_campos RESPECTING BLANKS.

  ENDIF.

  IF p_MATNR IS NOT INITIAL OR p_LOCID IS NOT INITIAL OR p_DATA_I IS NOT INITIAL OR p_TPMOV IS NOT INITIAL.

    SELECT *
      FROM zmov
      INTO TABLE lt_tab_zmov
      WHERE (lv_campos).

  ELSE.

    SELECT *
      FROM zmov
      INTO TABLE lt_tab_zmov.

  ENDIF.

  IF p_TPMOV IS INITIAL.

    LOOP AT lt_tab_zmov INTO ls_itab_zmov WHERE tpmov = 'SA' OR tpmov = 'TD'.

      ls_itab_zmov-qty = ls_itab_zmov-qty * -1.

      MODIFY TABLE lt_tab_zmov FROM ls_itab_zmov TRANSPORTING qty.

    ENDLOOP.
  ENDIF.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = lr_alv
        CHANGING
          t_table      = lt_tab_zmov.

      lo_agregador = lr_alv->get_aggregations( ).

      CALL METHOD lo_agregador->add_aggregation
        EXPORTING
          columnname  = 'QTY'
          aggregation = if_salv_c_aggregation=>total.

    CATCH cx_salv_msg cx_salv_not_found cx_salv_data_error cx_salv_existing INTO oref.
  ENDTRY.

  IF p_TPMOV IS INITIAL.

    CALL METHOD lr_alv->get_sorts
      RECEIVING
        value = lo_sort.

    TRY.
        CALL METHOD lo_sort->add_sort
          EXPORTING
            columnname = 'TPMOV'
          RECEIVING
            value      = lo_sort_column.

        CALL METHOD lo_sort_column->set_subtotal
          EXPORTING
            value = if_salv_c_bool_sap=>true.
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_existing.
    ENDTRY.

  ENDIF.

  CALL METHOD lr_alv->display.
