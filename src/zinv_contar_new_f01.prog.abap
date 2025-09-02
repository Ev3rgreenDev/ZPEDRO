*&---------------------------------------------------------------------*
*& Include          ZINV_CONTAR_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_IDINV
*&      <-- LV_DATA
*&---------------------------------------------------------------------*
FORM valida CHANGING p_idinv TYPE ze_guid32
                     i_gv_data TYPE dats.

  SELECT SINGLE idinv
  FROM zinv
  INTO p_IDINV
  WHERE idinv = p_IDINV
  AND status = gc_status.

  IF sy-subrc NE 0.
    MESSAGE 'Item inválido.' TYPE 'E'.
  ENDIF.

  IF p_QTY LT 0.
    MESSAGE 'Insira uma quantidade maior ou igual a 0.' TYPE 'E'.
  ENDIF.

  i_gv_data = sy-datum.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zinv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_QTY
*&      --> LV_DATA
*&---------------------------------------------------------------------*
FORM update_zinv  USING i_p_qty   TYPE ze_qty3
                        i_gv_data TYPE dats.


  UPDATE zinv
  SET qty_contada = @i_p_QTY,
  status = @gc_status,
  data_cont = @i_gv_data
  WHERE idinv = @p_IDINV.

  IF sy-subrc NE 0.
    MESSAGE e003(zpedro)
      with 'ZINV'.
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

  SELECT *
  FROM zinv
  INTO TABLE gt_tab_zinv
  WHERE idinv = p_IDINV.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      with 'ZINV'.
  ENDIF.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_tab_zinv.

    CATCH cx_salv_msg.
      MESSAGE e001(zpedro).

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
