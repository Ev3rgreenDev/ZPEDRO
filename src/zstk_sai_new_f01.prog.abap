*&---------------------------------------------------------------------*
*& Include          ZSTK_SAI_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida_matnr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATNR
*&---------------------------------------------------------------------*
FORM valida_matnr USING p_p_matnr TYPE ze_matnr.

  SELECT SINGLE matnr
    FROM zstock
    INTO p_p_matnr
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.

  IF sy-subrc NE 0.
    MESSAGE 'Cadastro de estoque não existe!' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_stock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_ITAB_ZSTOCK
*&---------------------------------------------------------------------*
FORM check_stock  CHANGING p_gs_itab_zstock TYPE zstock.

  SELECT SINGLE *
   FROM zstock
   INTO p_gs_itab_zstock
   WHERE matnr = p_MATNR
   AND locid = p_LOCID.

  IF p_gs_itab_zstock-qty LT p_QTY.
    MESSAGE 'Quantidade em estoque é menor do que a quantidade desejada para saída.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_stock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_ITAB_ZSTOCK
*&---------------------------------------------------------------------*
FORM update_stock  CHANGING i_gv_qty TYPE ze_qty3.

  i_gv_qty = gs_itab_zstock-qty - p_QTY.

  UPDATE zstock
  SET qty = i_gv_qty
  WHERE matnr = p_MATNR
  AND locid = p_LOCID.

  IF sy-subrc NE 0.
    MESSAGE e003(zpedro)
      WITH 'ZSTOCK'.
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
  FROM zstock
  INTO TABLE gt_tab_zstock
  WHERE matnr = p_MATNR
  AND locid = p_LOCID.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZSTOCK'.
  ENDIF.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_tab_zstock.

    CATCH cx_salv_msg.
      MESSAGE e001(zpedro).

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zmov
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_IDMOV
*&      <-- LS_ITAB_ZMOV
*&---------------------------------------------------------------------*
FORM create_zmov  CHANGING p_gv_idmov TYPE ze_guid32
                           p_gs_itab_zmov TYPE zmov.

  SELECT MAX( idmov )
  FROM zmov
  INTO gv_idmov.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'IDMOV MAX'.
  ENDIF.

  p_gv_idmov = p_gv_idmov + 1.
  gv_data = sy-datum.
  gv_hora = sy-uzeit.

  MOVE gv_idmov TO p_gs_itab_zmov-idmov.
  MOVE p_MATNR  TO p_gs_itab_zmov-matnr.
  MOVE p_LOCID  TO p_gs_itab_zmov-locid.
  MOVE gc_TPMOV TO p_gs_itab_zmov-tpmov.
  MOVE p_QTY    TO p_gs_itab_zmov-qty.
  MOVE gv_data  TO p_gs_itab_zmov-data.
  MOVE gv_HORA  TO p_gs_itab_zmov-hora.
  MOVE p_OBS    TO p_gs_itab_zmov-obs.

  p_gs_itab_zmov-idmov = |{ p_gs_itab_zmov-idmov ALPHA = IN }|.
  p_gs_itab_zmov-locid = |{ p_gs_itab_zmov-locid ALPHA = IN }|.

  INSERT zmov FROM p_gs_itab_zmov.

  IF sy-subrc NE 0.
    MESSAGE e000(zpedro)
      WITH 'ZMOV'.
  ENDIF.

ENDFORM.
