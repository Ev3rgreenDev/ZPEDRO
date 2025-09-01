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
    and locid = p_LOCID.

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
FORM check_stock  CHANGING ls_itab_zstock TYPE zstock.

  SELECT *
   FROM zstock
   INTO ls_itab_zstock
   WHERE matnr = p_MATNR
   AND locid = p_LOCID.
  ENDSELECT.

  IF ls_itab_zstock-qty LT p_QTY.
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
FORM update_stock  CHANGING lv_qty TYPE ze_qty3.

  lv_qty = ls_itab_zstock-qty - p_QTY.

  UPDATE zstock
  SET qty = lv_qty
  WHERE matnr = p_MATNR
  AND locid = p_LOCID.

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

    CATCH cx_salv_msg.

  ENDTRY.

  CALL METHOD lr_alv->display.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zmov
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_IDMOV
*&      <-- LS_ITAB_ZMOV
*&---------------------------------------------------------------------*
FORM create_zmov  CHANGING p_lv_idmov TYPE ze_guid32 p_ls_itab_zmov TYPE zmov.

  SELECT MAX( idmov )
  FROM zmov
  INTO lv_idmov.

  lv_idmov = lv_idmov + 1.
  lv_tpmov = 'SA'.
  lv_data = sy-datum.
  lv_hora = sy-uzeit.

  MOVE lv_idmov TO ls_itab_zmov-idmov.
  MOVE p_MATNR  TO ls_itab_zmov-matnr.
  MOVE p_LOCID  TO ls_itab_zmov-locid.
  MOVE lv_TPMOV TO ls_itab_zmov-tpmov.
  MOVE p_QTY    TO ls_itab_zmov-qty.
  MOVE lv_data  TO ls_itab_zmov-data.
  MOVE lv_HORA  TO ls_itab_zmov-hora.
  MOVE p_OBS    TO ls_itab_zmov-obs.

  ls_itab_zmov-idmov = |{ ls_itab_zmov-idmov ALPHA = IN }|.
  ls_itab_zmov-matnr = |{ ls_itab_zmov-matnr ALPHA = IN }|.
  ls_itab_zmov-locid = |{ ls_itab_zmov-locid ALPHA = IN }|.

  INSERT zmov FROM ls_itab_zmov.

ENDFORM.
