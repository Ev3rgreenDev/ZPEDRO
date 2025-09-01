*&---------------------------------------------------------------------*
*& Include          ZINV_PROCESSAR_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM valida .

  SELECT SINGLE status
   FROM zinv
   INTO @DATA(lv_status)
   WHERE idinv = @p_IDINV.

  IF sy-subrc NE 0.
    MESSAGE 'ID inválido.' TYPE 'E'.

  ELSEIF lv_status NE 'F'.
    MESSAGE 'Inventário ainda não foi fechado.' TYPE 'E'.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_zinv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_ITAB_ZINV
*&---------------------------------------------------------------------*
FORM get_zinv  CHANGING p_ls_itab_zinv.

  SELECT SINGLE *
  FROM zinv
  INTO ls_itab_zinv
  WHERE idinv = p_IDINV.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_stock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_STOCK
*&---------------------------------------------------------------------*
FORM get_stock  CHANGING p_lv_qty_stock TYPE ze_qty3
                         lv_dif TYPE ze_qty3.

  SELECT SINGLE qty
   FROM zstock
   INTO lv_qty_stock
   WHERE matnr = ls_itab_zinv-matnr
   AND locid = ls_itab_zinv-locid.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao acessar o material correspondente ao IDINV inserido.' TYPE 'E'.
  ENDIF.

  lv_dif = ls_itab_zinv-qty_contada - lv_qty_stock.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zstock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_FINAL
*&---------------------------------------------------------------------*
FORM update_zstock_add  CHANGING p_lv_qty_final TYPE ze_qty3.

  IF lv_dif GT 0.

    lv_qty_final = lv_dif + lv_qty_stock.

    UPDATE zstock
    SET qty = lv_qty_final
    WHERE matnr = ls_itab_zinv-matnr
    AND locid = ls_itab_zinv-locid.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zstock_sub
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_FINAL
*&---------------------------------------------------------------------*
FORM update_zstock_sub  CHANGING p_lv_qty_final TYPE ze_qty3.

  IF lv_dif LT 0.

    lv_qty_final = lv_qty_stock - lv_dif.

    IF lv_qty_final LT 0.
      MESSAGE 'Ajuste não pode deixar o valor final ser negativo!' TYPE 'E'.
    ENDIF.

    UPDATE zstock
    SET qty = lv_qty_final
    WHERE matnr = ls_itab_zinv-matnr
    AND locid = ls_itab_zinv-locid.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zinv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_zinv .

  UPDATE zinv
  SET status = 'p'
  WHERE idinv = p_IDINV.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form mov
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_IDMOV
*&      <-- LV_TPMOV
*&      <-- LS_ITAB_ZMOV
*&---------------------------------------------------------------------*
FORM mov  CHANGING p_lv_idmov TYPE ze_guid32
                   p_lv_tpmov TYPE ze_tpmov
                   p_ls_itab_zmov TYPE zmov.

  SELECT MAX( idmov )
    FROM zmov
    INTO lv_idmov.

  lv_idmov = lv_idmov + 1.
  lv_tpmov = 'AJ'.

  MOVE lv_idmov            TO ls_itab_zmov-idmov.
  MOVE ls_itab_zinv-matnr  TO ls_itab_zmov-matnr.
  MOVE ls_itab_zinv-locid  TO ls_itab_zmov-locid.
  MOVE lv_TPMOV            TO ls_itab_zmov-tpmov.
  MOVE lv_dif              TO ls_itab_zmov-qty.
  MOVE lv_data             TO ls_itab_zmov-data.
  MOVE lv_HORA             TO ls_itab_zmov-hora.
  MOVE lv_OBS              TO ls_itab_zmov-obs.

  ls_itab_zmov-idmov = |{ ls_itab_zmov-idmov ALPHA = IN }|.
  ls_itab_zmov-matnr = |{ ls_itab_zmov-matnr ALPHA = IN }|.
  ls_itab_zmov-locid = |{ ls_itab_zmov-locid ALPHA = IN }|.

  INSERT zmov FROM ls_itab_zmov.

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
    WHERE matnr = ls_itab_zinv-matnr
    AND locid = ls_itab_zinv-locid.

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
