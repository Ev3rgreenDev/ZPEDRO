*&---------------------------------------------------------------------*
*& Include          ZINV_ABRIR_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATNR
*&---------------------------------------------------------------------*
FORM valida  USING p_p_matnr.

  SELECT SINGLE matnr
    FROM zstock
    INTO p_p_MATNR
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.

  IF sy-subrc NE 0.
    MESSAGE 'Cadastro selecionado inválido.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zinv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_IDINV
*&      <-- LV_STATUS
*&      <-- LV_DATA
*&---------------------------------------------------------------------*
FORM create_zinv  CHANGING lv_idinv TYPE ze_guid32
                           lv_status TYPE ze_stat_inv
                           lv_data TYPE dats.

  SELECT MAX( idinv )
      FROM zinv
      INTO lv_idinv.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
  ENDIF.

  lv_idinv  = lv_idinv + 1.
  lv_status = 'A'.
  lv_data   = sy-datum.

  MOVE lv_idinv TO ls_itab_zinv-idinv.
  MOVE p_MATNR TO ls_itab_zinv-matnr.
  MOVE p_LOCID TO ls_itab_zinv-locid.
  MOVE lv_data TO ls_itab_zinv-data_cont.
  MOVE lv_status TO ls_itab_zinv-status.


  ls_itab_zinv-idinv = |{ ls_itab_zinv-idinv ALPHA = IN }|.
  ls_itab_zinv-matnr = |{ ls_itab_zinv-matnr ALPHA = IN }|.
  ls_itab_zinv-locid = |{ ls_itab_zinv-locid ALPHA = IN }|.

  INSERT zinv FROM ls_itab_zinv.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer insert!' TYPE 'E'.
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
    FROM zinv
    INTO TABLE lt_tab_zinv
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.

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
          t_table      = lt_tab_zinv.

    CATCH cx_salv_msg.
      MESSAGE 'Erro ao fazer try!' TYPE 'E'.

  ENDTRY.

  CALL METHOD lr_alv->display.

ENDFORM.
