*&---------------------------------------------------------------------*
*& Form get_string
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_STRING
*&---------------------------------------------------------------------*
FORM get_string CHANGING lv_string TYPE string.

  IF p_MATNR IS NOT INITIAL AND p_LOCID IS NOT INITIAL.

    lv_string = 'matnr = p_MATNR AND locid = p_LOCID'.

  ELSEIF p_MATNR IS NOT INITIAL.

    lv_string = 'matnr = p_MATNR'.

  ELSEIF p_LOCID IS NOT INITIAL.

    lv_string = 'locid = p_LOCID'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form alv_event
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_STRING
*&---------------------------------------------------------------------*
FORM alv_event USING lv_string TYPE string.

  IF p_MATNR IS INITIAL AND p_LOCID IS INITIAL.

    SELECT *
      FROM zstock
      INTO TABLE lt_tab_zstock.

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer select!' TYPE 'E'.
    ENDIF.

  ELSE.

    SELECT *
      FROM zstock
      INTO TABLE lt_tab_zstock
      WHERE (lv_string).

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer select!' TYPE 'E'.
    ENDIF.

  ENDIF.

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
      MESSAGE 'Erro ao fazer try!' TYPE 'E'.

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
      MESSAGE 'Erro ao fazer try!' TYPE 'E'.
  ENDTRY.

  CALL METHOD lr_alv->display.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form valida
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATNR
*&      --> P_LOCID
*&---------------------------------------------------------------------*
FORM valida  USING    p_p_matnr TYPE ze_matnr
                      p_p_locid TYPE ze_locid.

  IF p_MATNR IS NOT INITIAL AND p_LOCID IS NOT INITIAL.

    SELECT SINGLE matnr
      FROM zstock
      INTO p_p_matnr
      WHERE matnr = p_MATNR
      AND locid = p_LOCID.

    IF sy-subrc NE 0.
      MESSAGE 'O cadastro selecionado é inválido.' TYPE 'E'.
    ENDIF.


  ELSEIF p_MATNR IS NOT INITIAL.

    SELECT SINGLE matnr
      FROM zstock
      INTO p_p_matnr
      WHERE matnr = p_MATNR.

    IF sy-subrc NE 0.
      MESSAGE 'O material selecionado é inválido.' TYPE 'E'.
    ENDIF.

  ELSEIF p_LOCID IS NOT INITIAL.

    SELECT SINGLE matnr
      FROM zstock
      INTO p_p_matnr
      WHERE locid = p_LOCID.

    IF sy-subrc NE 0.
      MESSAGE 'O local selecionado é inválido.' TYPE 'E'.
    ENDIF.

  ENDIF.


ENDFORM.
