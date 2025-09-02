*&---------------------------------------------------------------------*
*& Include          ZSTK_MOV_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- P_DATA_F
*&---------------------------------------------------------------------*
FORM valida CHANGING p_data_f.

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

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_selection
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_CAMPOS
*&---------------------------------------------------------------------*
FORM get_selection  CHANGING i_gv_campos.

  IF p_MATNR IS NOT INITIAL.

    CONCATENATE 'MATNR = p_MATNR' i_gv_campos INTO i_gv_campos RESPECTING BLANKS.

  ENDIF.

  IF p_LOCID IS NOT INITIAL AND i_gv_campos IS INITIAL.

    CONCATENATE 'LOCID = p_LOCID' i_gv_campos INTO i_gv_campos RESPECTING BLANKS.

  ELSEIF p_LOCID IS NOT INITIAL AND i_gv_campos IS NOT INITIAL.

    CONCATENATE i_gv_campos ' AND LOCID = p_LOCID'  INTO i_gv_campos RESPECTING BLANKS.

  ENDIF.

  IF p_DATA_I IS NOT INITIAL AND i_gv_campos IS INITIAL.

    CONCATENATE 'DATA GE p_DATA_I AND DATA LE p_DATA_F' i_gv_campos INTO i_gv_campos RESPECTING BLANKS.

  ELSEIF p_DATA_I IS NOT INITIAL AND i_gv_campos IS NOT INITIAL.

    CONCATENATE i_gv_campos ' AND DATA GE p_DATA_I AND DATA LE p_DATA_F' INTO i_gv_campos RESPECTING BLANKS.

  ENDIF.

  IF p_TPMOV IS NOT INITIAL AND i_gv_campos IS INITIAL.

    CONCATENATE 'TPMOV = p_TPMOV' i_gv_campos INTO i_gv_campos RESPECTING BLANKS.

  ELSEIF p_TPMOV IS NOT INITIAL AND i_gv_campos IS NOT INITIAL.

    CONCATENATE i_gv_campos ' AND TPMOV = p_TPMOV'  INTO i_gv_campos RESPECTING BLANKS.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_zmov
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_CAMPOS
*&      <-- LT_TAB_ZMOV
*&---------------------------------------------------------------------*
FORM get_zmov USING i_gv_campos TYPE string.

  IF p_MATNR IS NOT INITIAL
     OR p_LOCID IS NOT INITIAL
     OR p_DATA_I IS NOT INITIAL
     OR p_TPMOV IS NOT INITIAL.

    SELECT *
      FROM zmov
      INTO TABLE gt_tab_zmov
      WHERE (i_gv_campos).

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
      with 'ZMOV'.
    ENDIF.

  ELSE.

    SELECT *
      FROM zmov
      INTO TABLE gt_tab_zmov.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
      with 'ZMOV'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form tpmov_processing
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_ITAB_ZMOV
*&---------------------------------------------------------------------*
FORM tpmov_processing  CHANGING p_gs_itab_zmov TYPE zmov.

  IF p_TPMOV IS INITIAL.

    LOOP AT gt_tab_zmov INTO p_gs_itab_zmov WHERE tpmov = 'SA' OR tpmov = 'TD'.

      p_gs_itab_zmov-qty = p_gs_itab_zmov-qty * -1.

      MODIFY TABLE gt_tab_zmov FROM p_gs_itab_zmov TRANSPORTING qty.
      IF sy-subrc NE 0.
        MESSAGE 'Houve um erro ao modificar a tabela interna de ZMOV!' TYPE 'E'.
      ENDIF.

    ENDLOOP.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form alv_event
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM alv_event .

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_tab_zmov.

      go_agregador = gr_alv->get_aggregations( ).

      CALL METHOD go_agregador->add_aggregation
        EXPORTING
          columnname  = 'QTY'
          aggregation = if_salv_c_aggregation=>total.

    CATCH cx_salv_msg cx_salv_not_found cx_salv_data_error cx_salv_existing INTO oref.
      MESSAGE e001(zpedro).
  ENDTRY.

  IF p_TPMOV IS INITIAL.

    CALL METHOD gr_alv->get_sorts
      RECEIVING
        value = go_sort.

    TRY.
        CALL METHOD go_sort->add_sort
          EXPORTING
            columnname = 'TPMOV'
          RECEIVING
            value      = go_sort_column.

        CALL METHOD go_sort_column->set_subtotal
          EXPORTING
            value = if_salv_c_bool_sap=>true.
      CATCH cx_salv_data_error cx_salv_not_found cx_salv_existing.
        MESSAGE e001(zpedro).
    ENDTRY.

  ENDIF.

  CALL METHOD gr_alv->display.

ENDFORM.
