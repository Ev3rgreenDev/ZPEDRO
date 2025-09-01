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
                     lv_data TYPE dats.

  SELECT SINGLE idinv
  FROM zinv
  INTO p_IDINV
  WHERE idinv = p_IDINV
  AND status = 'A'.

  IF sy-subrc NE 0.
    MESSAGE 'Item inválido.' TYPE 'E'.
  ENDIF.

  IF p_QTY LT 0.
    MESSAGE 'Insira uma quantidade maior ou igual a 0.' TYPE 'E'.
  ENDIF.

  lv_data = sy-datum.


ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zinv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_QTY
*&      --> LV_DATA
*&---------------------------------------------------------------------*
FORM update_zinv  USING    p_p_qty TYPE ze_qty3
                           p_lv_data TYPE dats.


  UPDATE zinv
  SET qty_contada = p_QTY
  WHERE idinv = p_IDINV.

  UPDATE zinv
  SET status = 'F'
  WHERE idinv = p_IDINV.

  UPDATE zinv
  SET data_cont = lv_data
  WHERE idinv = p_IDINV.

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
  INTO TABLE lt_tab_zinv
  WHERE idinv = p_IDINV.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = lr_alv
        CHANGING
          t_table      = lt_tab_zinv.

    CATCH cx_salv_msg.

  ENDTRY.

  CALL METHOD lr_alv->display.

ENDFORM.
