*&---------------------------------------------------------------------*
*& Include          ZRES_CRIAR_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida_matnr_locid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM valida_matnr_locid .

  SELECT SINGLE matnr
    FROM zstock
    INTO p_MATNR
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.

  IF sy-subrc NE 0.
    MESSAGE 'Material e/ou local inválido.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form valida_qty
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM valida_qty .

  SELECT SINGLE *
   FROM zstock
   INTO @DATA(ls_itab_zres_c)
   WHERE matnr = @p_MATNR
   AND qty GE @p_QTY.

  IF sy-subrc NE 0.
    MESSAGE 'Valor a ser reservado é maior do que o valor em estoque.' TYPE 'E'.
  ENDIF.

  SELECT SINGLE qty_res
    FROM zres
    INTO lv_qty_res
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.

  IF sy-subrc = 0.
    IF p_QTY + lv_qty_res GT ls_itab_zres_c-qty.
      MESSAGE 'Valor a ser reservado é maior do que o valor em estoque.' TYPE 'E'.
    ENDIF.
  ENDIF.


  IF p_QTY LE 0.
    MESSAGE 'Quantidade precisa ser maior do que 0.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_DATA
*&---------------------------------------------------------------------*
FORM set_data  CHANGING p_lv_data TYPE dats.

  lv_data = sy-datum.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form mov
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_IDRES
*&      <-- LV_STATUS
*&      <-- LS_ITAB_ZRES
*&---------------------------------------------------------------------*
FORM mov  CHANGING p_lv_idres TYPE ze_guid32
                   p_lv_status TYPE ze_stat_res
                   p_ls_itab_zres TYPE zres.

  SELECT MAX( idres )
    FROM zres
    INTO lv_IDRES.

  lv_IDRES = lv_IDRES + 1.
  lv_status = 'A'.

  MOVE lv_IDRES  TO ls_itab_zres-idres.
  MOVE p_MATNR   TO ls_itab_zres-matnr.
  MOVE p_LOCID   TO ls_itab_zres-locid.
  MOVE p_QTY     TO ls_itab_zres-qty_res.
  MOVE lv_data   TO ls_itab_zres-data.
  MOVE lv_status TO ls_itab_zres-status.

  ls_itab_zres-idres = |{ ls_itab_zres-idres ALPHA = IN }|.
  ls_itab_zres-matnr = |{ ls_itab_zres-matnr ALPHA = IN }|.
  ls_itab_zres-locid = |{ ls_itab_zres-locid ALPHA = IN }|.

  INSERT zres FROM ls_itab_zres.


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
  FROM zres
  INTO TABLE lt_tab_zres
  WHERE idres = ls_itab_zres-idres.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = lr_alv
        CHANGING
          t_table      = lt_tab_zres.

    CATCH cx_salv_msg.

  ENDTRY.

  CALL METHOD lr_alv->display.

ENDFORM.
