*&---------------------------------------------------------------------*
*& Include          ZRES_USAR_NEW_F01
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

  SELECT SINGLE idres
  FROM zres
  INTO p_IDRES
  WHERE idres = p_IDRES.

  IF sy-subrc NE 0.
    MESSAGE 'A reserva requisitada não existe' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_var
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_DATA
*&      <-- LV_HORA
*&---------------------------------------------------------------------*
FORM set_var  CHANGING p_lv_data TYPE dats
                       p_lv_hora TYPE tims.

  lv_data = sy-datum.
  lv_hora = sy-uzeit.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_zres
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_ITAB_ZRES
*&---------------------------------------------------------------------*
FORM get_zres  CHANGING p_ls_itab_zres TYPE zres.

  SELECT SINGLE *
    FROM zres
    INTO ls_itab_zres
    WHERE idres = p_IDRES.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_stock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_STOCK
*&---------------------------------------------------------------------*
FORM get_stock  CHANGING p_lv_qty_stock TYPE ze_qty3.

  SELECT SINGLE qty
    FROM zstock
    INTO lv_qty_stock
    WHERE matnr = ls_itab_zres-matnr
    AND locid = ls_itab_zres-locid.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form valida_qty_set_qty
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_QTY_STOCK
*&      --> LS_ITAB_ZRES
*&      <-- LV_QTY_FINAL
*&---------------------------------------------------------------------*
FORM valida_qty_set_qty  USING    p_lv_qty_stock TYPE ze_qty3
                                  p_ls_itab_zres TYPE zres
                         CHANGING p_lv_qty_final TYPE ze_qty3.

  IF lv_qty_stock LT ls_itab_zres-qty_res.
    MESSAGE 'Valor da reserva é maior do que valor em estoque.' TYPE 'E'.
  ENDIF.

  lv_qty_final = lv_qty_stock - ls_itab_zres-qty_res.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zstock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_QTY_FINAL
*&      --> LV_DATA
*&---------------------------------------------------------------------*
FORM update_zstock  USING    p_lv_qty_final TYPE ze_qty3
                             p_lv_data TYPE dats.

  UPDATE zstock
  SET qty = lv_qty_final
  WHERE matnr = ls_itab_zres-matnr
  AND locid = ls_itab_zres-locid.

  UPDATE zstock
  SET dt_atualiz = lv_data
  WHERE matnr = ls_itab_zres-matnr
  AND locid = ls_itab_zres-locid.

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

  lv_tpmov = 'SA'.

  MOVE lv_idmov             TO ls_itab_zmov-idmov.
  MOVE ls_itab_zres-matnr   TO ls_itab_zmov-matnr.
  MOVE ls_itab_zres-locid   TO ls_itab_zmov-locid.
  MOVE lv_TPMOV             TO ls_itab_zmov-tpmov.
  MOVE ls_itab_zres-qty_res TO ls_itab_zmov-qty.
  MOVE lv_data              TO ls_itab_zmov-data.
  MOVE lv_HORA              TO ls_itab_zmov-hora.

  ls_itab_zmov-idmov = |{ ls_itab_zmov-idmov ALPHA = IN }|.
  ls_itab_zmov-matnr = |{ ls_itab_zmov-matnr ALPHA = IN }|.
  ls_itab_zmov-locid = |{ ls_itab_zmov-locid ALPHA = IN }|.

  INSERT zmov FROM ls_itab_zmov.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zres
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_zres .

  UPDATE zres
  SET status = 'U'
  WHERE idres = p_IDRES.

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
   WHERE matnr = ls_itab_zmov-matnr
   AND locid = ls_itab_zmov-locid.

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

  MESSAGE 'Reserva baixada com sucesso!' TYPE 'S'.

ENDFORM.
