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
FORM create_zinv  CHANGING i_gv_idinv  TYPE ze_guid32
                           i_gv_data   TYPE dats.

  SELECT MAX( idinv )
      FROM zinv
      INTO i_gv_idinv.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
  ENDIF.

  i_gv_idinv  = i_gv_idinv + 1.
  i_gv_data   = sy-datum.

  MOVE i_gv_idinv TO gs_itab_zinv-idinv.
  MOVE p_MATNR    TO gs_itab_zinv-matnr.
  MOVE p_LOCID    TO gs_itab_zinv-locid.
  MOVE i_gv_data  TO gs_itab_zinv-data_cont.
  MOVE gc_status  TO gs_itab_zinv-status.


  gs_itab_zinv-idinv = |{ gs_itab_zinv-idinv ALPHA = IN }|.
  gs_itab_zinv-matnr = |{ gs_itab_zinv-matnr ALPHA = IN }|.
  gs_itab_zinv-locid = |{ gs_itab_zinv-locid ALPHA = IN }|.

  INSERT zinv FROM gs_itab_zinv.

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
    INTO TABLE gt_tab_zinv
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
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_tab_zinv.

    CATCH cx_salv_msg.
      MESSAGE 'Erro ao fazer try!' TYPE 'E'.

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
