*&---------------------------------------------------------------------*
*& Include          ZRES_CANCEL_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM valida.

  SELECT SINGLE idres
   FROM zres
   INTO p_IDRES
   WHERE idres = p_IDRES
   AND status = c_status_a.

  IF sy-subrc NE 0.
    MESSAGE 'A reserva requisitada não existe' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zres
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_zres.

  UPDATE zres
  SET status = c_status_c
  WHERE idres = p_IDRES.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer update!' TYPE 'E'.
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
FORM alv_event.

  SELECT *
  FROM zres
  INTO TABLE lt_tab_zres
  WHERE idres = p_IDRES.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
  ENDIF.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = lr_alv
        CHANGING
          t_table      = lt_tab_zres.

    CATCH cx_salv_msg.
      MESSAGE 'Erro ao fazer try!' TYPE 'E'.

  ENDTRY.

  CALL METHOD lr_alv->display.

ENDFORM.
