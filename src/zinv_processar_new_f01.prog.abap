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
   INTO @DATA(gv_status)
   WHERE idinv = @p_IDINV.

  IF sy-subrc NE 0.
    MESSAGE 'ID inválido.' TYPE 'E'.

  ELSEIF gv_status NE 'F'.
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
FORM get_zinv  CHANGING p_gs_itab_zinv.

  SELECT SINGLE *
  FROM zinv
  INTO p_gs_itab_zinv
  WHERE idinv = p_IDINV.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_stock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_STOCK
*&---------------------------------------------------------------------*
FORM get_stock  CHANGING gv_qty_stock TYPE ze_qty3
                         gv_dif       TYPE ze_qty3.

  SELECT SINGLE qty
   FROM zstock
   INTO gv_qty_stock
   WHERE matnr = gs_itab_zinv-matnr
   AND locid = gs_itab_zinv-locid.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao acessar o material correspondente ao IDINV inserido.' TYPE 'E'.
  ENDIF.

  gv_dif = gs_itab_zinv-qty_contada - gv_qty_stock.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zstock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_FINAL
*&---------------------------------------------------------------------*
FORM update_zstock_add  CHANGING p_gv_qty_final TYPE ze_qty3.

  IF gv_dif GT 0.

    p_gv_qty_final = gv_dif + gv_qty_stock.

    UPDATE zstock
    SET qty = p_gv_qty_final
    WHERE matnr = gs_itab_zinv-matnr
    AND locid = gs_itab_zinv-locid.

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer update!' TYPE 'E'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zstock_sub
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_FINAL
*&---------------------------------------------------------------------*
FORM update_zstock_sub  CHANGING p_gv_qty_final TYPE ze_qty3.

  IF gv_dif LT 0.

    p_gv_qty_final = gv_qty_stock - gv_dif.

    IF p_gv_qty_final LT 0.
      MESSAGE 'Ajuste não pode deixar o valor final ser negativo!' TYPE 'E'.
    ENDIF.

    UPDATE zstock
    SET qty = p_gv_qty_final
    WHERE matnr = gs_itab_zinv-matnr
    AND locid = gs_itab_zinv-locid.

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer update!' TYPE 'E'.
    ENDIF.

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
  SET status = gc_status
  WHERE idinv = p_IDINV.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer update!' TYPE 'E'.
  ENDIF.

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
FORM mov  CHANGING p_gv_idmov     TYPE ze_guid32
                   p_gs_itab_zmov TYPE zmov.

  SELECT MAX( idmov )
    FROM zmov
    INTO p_gv_idmov.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
  ENDIF.

  p_gv_idmov = p_gv_idmov + 1.

  MOVE p_gv_idmov         TO gs_itab_zmov-idmov.
  MOVE gs_itab_zinv-matnr TO gs_itab_zmov-matnr.
  MOVE gs_itab_zinv-locid TO gs_itab_zmov-locid.
  MOVE gc_TPMOV           TO gs_itab_zmov-tpmov.
  MOVE gv_dif             TO gs_itab_zmov-qty.
  MOVE gv_data            TO gs_itab_zmov-data.
  MOVE gv_HORA            TO gs_itab_zmov-hora.
  MOVE gv_OBS             TO gs_itab_zmov-obs.

  p_gs_itab_zmov-idmov = |{ p_gs_itab_zmov-idmov ALPHA = IN }|.
  p_gs_itab_zmov-locid = |{ p_gs_itab_zmov-locid ALPHA = IN }|.

  INSERT zmov FROM p_gs_itab_zmov.

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
FORM alv_event .

  SELECT *
    FROM zstock
    INTO TABLE gt_tab_zstock
    WHERE matnr = gs_itab_zinv-matnr
    AND locid = gs_itab_zinv-locid.

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
          t_table      = gt_tab_zstock.

    CATCH cx_salv_msg.
      MESSAGE 'Erro ao fazer try!' TYPE 'E'.
  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
