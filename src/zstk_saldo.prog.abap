*&---------------------------------------------------------------------*
*& Report ZSTK_SALDO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstk_saldo.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR,
              p_LOCID TYPE ze_LOCID.

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
  lv_qty_destino TYPE ze_qty3.



AT SELECTION-SCREEN ON p_MATNR.

  IF p_MATNR IS NOT INITIAL.

    SELECT SINGLE matnr
      FROM zstock
      INTO p_MATNR
      WHERE matnr = p_MATNR.

    IF sy-subrc NE 0.
      MESSAGE 'O material selecionado é inválido.' TYPE 'E'.
    ENDIF.
  ENDIF.


AT SELECTION-SCREEN ON p_LOCID.

  IF p_LOCID IS NOT INITIAL.

    SELECT SINGLE locid
    FROM zstock
    INTO p_LOCID
    WHERE locid = p_LOCID.

    IF sy-subrc NE 0.
      MESSAGE 'O local selecionado é inválido.' TYPE 'E'.
    ENDIF.
  ENDIF.


START-OF-SELECTION.

  IF p_MATNR IS NOT INITIAL.

    IF p_LOCID IS NOT INITIAL.

      " RELATÓRIO ALV GERAL
      SELECT *
        FROM zstock
        INTO TABLE lt_tab_zstock
        WHERE matnr = p_MATNR
        AND locid = p_LOCID.

      TRY.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              list_display = if_salv_c_bool_sap=>false
            IMPORTING
              r_salv_table = lr_alv
            CHANGING
              t_table      = lt_tab_zstock.

          lo_agregador = lr_alv->get_aggregations( ).

          CALL METHOD lo_agregador->add_aggregation
            EXPORTING
              columnname  = 'QTY'
              aggregation = if_salv_c_aggregation=>total.

        CATCH cx_salv_msg cx_salv_not_found cx_salv_data_error cx_salv_existing INTO oref.

      ENDTRY.

      CALL METHOD lr_alv->display.
      CLEAR lt_tab_zstock.


      " CASO LOCAL NÃO TENHA SIDO ESPECIFICADO
    ELSE.

      " RELATÓRIO ALV TOTALIZADO POR MATERIAL
      SELECT *
        FROM zstock
        INTO TABLE @DATA(lt_tab_zstock_tm)
        WHERE matnr = @p_MATNR.

      TRY.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              list_display = if_salv_c_bool_sap=>false
            IMPORTING
              r_salv_table = lr_alv
            CHANGING
              t_table      = lt_tab_zstock_tm.

          lo_agregador = lr_alv->get_aggregations( ).

          CALL METHOD lo_agregador->add_aggregation
            EXPORTING
              columnname  = 'QTY'
              aggregation = if_salv_c_aggregation=>total.

        CATCH cx_salv_msg cx_salv_not_found cx_salv_data_error cx_salv_existing INTO oref.

      ENDTRY.

      CALL METHOD lr_alv->display.

    ENDIF.


  ELSEIF p_LOCID IS INITIAL.

    " RELATÓRIO ALV TOTALIZADO POR MATERIAL
    SELECT *
      FROM zstock
      INTO TABLE @DATA(lt_tab_zstock_tl)
      WHERE locid = @p_LOCID.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = lr_alv
          CHANGING
            t_table      = lt_tab_zstock_tl.

        lo_agregador = lr_alv->get_aggregations( ).

        CALL METHOD lo_agregador->add_aggregation
          EXPORTING
            columnname  = 'QTY'
            aggregation = if_salv_c_aggregation=>total.

      CATCH cx_salv_msg cx_salv_not_found cx_salv_data_error cx_salv_existing INTO oref.

    ENDTRY.

    CALL METHOD lr_alv->get_sorts
      RECEIVING
        value = lo_sort.

    TRY.
        CALL METHOD lo_sort->add_sort
          EXPORTING
            columnname = 'MATNR'
          RECEIVING
            value      = lo_sort_column.

        CALL METHOD lo_sort_column->set_subtotal
          EXPORTING
            value = if_salv_c_bool_sap=>true.
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_existing.
    ENDTRY.

    CALL METHOD lr_alv->display.




    " CASO NÃO HAJA FILTROS
  ELSE.

    " RELATÓRIO ALV TOTALIZADO POR MATERIAL
    SELECT *
      FROM zstock
      INTO TABLE @DATA(lt_tab_zstock_tm2).

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = lr_alv
          CHANGING
            t_table      = lt_tab_zstock_tm2.

        lo_agregador = lr_alv->get_aggregations( ).

        CALL METHOD lo_agregador->add_aggregation
          EXPORTING
            columnname  = 'QTY'
            aggregation = if_salv_c_aggregation=>total.

      CATCH cx_salv_msg cx_salv_not_found cx_salv_data_error cx_salv_existing INTO oref.

    ENDTRY.

    CALL METHOD lr_alv->get_sorts
      RECEIVING
        value = lo_sort.

    TRY.
        CALL METHOD lo_sort->add_sort
          EXPORTING
            columnname = 'MATNR'
          RECEIVING
            value      = lo_sort_column.

        CALL METHOD lo_sort_column->set_subtotal
          EXPORTING
            value = if_salv_c_bool_sap=>true.
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_existing.
    ENDTRY.

    CALL METHOD lr_alv->display.

  ENDIF.
