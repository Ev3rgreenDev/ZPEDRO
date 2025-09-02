*&---------------------------------------------------------------------*
*& Form get_string
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_STRING
*&---------------------------------------------------------------------*
FORM get_string CHANGING i_gv_string TYPE string.

  IF p_MATNR IS NOT INITIAL AND p_LOCID IS NOT INITIAL.

    i_gv_string = 'matnr = p_MATNR AND locid = p_LOCID'.

  ELSEIF p_MATNR IS NOT INITIAL.

    i_gv_string = 'matnr = p_MATNR'.

  ELSEIF p_LOCID IS NOT INITIAL.

    i_gv_string = 'locid = p_LOCID'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form alv_event
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_STRING
*&---------------------------------------------------------------------*
FORM alv_event USING i_gv_string TYPE string.

  IF p_MATNR IS INITIAL AND p_LOCID IS INITIAL.

    SELECT *
      FROM zstock
      INTO TABLE gt_tab_zstock.

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer select!' TYPE 'E'.
    ENDIF.

  ELSE.

    SELECT *
      FROM zstock
      INTO TABLE gt_tab_zstock
      WHERE (i_gv_string).

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer select!' TYPE 'E'.
    ENDIF.

  ENDIF.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_tab_zstock.

      go_agregador = gr_alv->get_aggregations( ).

      CALL METHOD go_agregador->add_aggregation
        EXPORTING
          columnname  = 'QTY'
          aggregation = if_salv_c_aggregation=>total.

    CATCH cx_salv_msg cx_salv_not_found cx_salv_data_error cx_salv_existing INTO oref.
      MESSAGE 'Erro ao fazer try!' TYPE 'E'.

  ENDTRY.

  CALL METHOD gr_alv->get_sorts
    RECEIVING
      value = go_sort.

  TRY.
      CALL METHOD go_sort->add_sort
        EXPORTING
          columnname = 'MATNR'
        RECEIVING
          value      = go_sort_column.

      CALL METHOD go_sort_column->set_subtotal
        EXPORTING
          value = if_salv_c_bool_sap=>true.
    CATCH cx_salv_data_error cx_salv_not_found cx_salv_existing.
      MESSAGE 'Erro ao fazer try!' TYPE 'E'.
  ENDTRY.

  CALL METHOD gr_alv->display.

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
