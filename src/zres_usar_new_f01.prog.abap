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
*&      <-- gv_DATA
*&      <-- gv_HORA
*&---------------------------------------------------------------------*
FORM set_var  CHANGING p_gv_data TYPE dats
                       p_gv_hora TYPE tims.

  p_gv_data = sy-datum.
  p_gv_hora = sy-uzeit.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_zres
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- gs_ITAB_ZRES
*&---------------------------------------------------------------------*
FORM get_zres  CHANGING p_gs_itab_zres TYPE zres.

  SELECT SINGLE *
    FROM zres
    INTO p_gs_itab_zres
    WHERE idres = p_IDRES.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZRES'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_stock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- gv_QTY_STOCK
*&---------------------------------------------------------------------*
FORM get_stock  CHANGING p_gv_qty_stock TYPE ze_qty3.

  SELECT SINGLE qty
    FROM zstock
    INTO p_gv_qty_stock
    WHERE matnr = gs_itab_zres-matnr
    AND locid = gs_itab_zres-locid.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZSTOCK'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form valida_qty_set_qty
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> gv_QTY_STOCK
*&      --> gs_ITAB_ZRES
*&      <-- gv_QTY_FINAL
*&---------------------------------------------------------------------*
FORM valida_qty_set_qty  USING    p_gv_qty_stock TYPE ze_qty3
                                  p_gs_itab_zres TYPE zres
                         CHANGING p_gv_qty_final TYPE ze_qty3.

  IF p_gv_qty_stock LT p_gs_itab_zres-qty_res.
    MESSAGE 'Valor da reserva é maior do que valor em estoque.' TYPE 'E'.
  ENDIF.

  p_gv_qty_final = p_gv_qty_stock - p_gs_itab_zres-qty_res.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zstock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> gv_QTY_FINAL
*&      --> gv_DATA
*&---------------------------------------------------------------------*
FORM update_zstock  USING p_gv_qty_final TYPE ze_qty3
                          p_gv_data      TYPE dats.

  UPDATE zstock
  SET qty = @p_gv_qty_final,
      dt_atualiz = @p_gv_data
  WHERE matnr = @gs_itab_zres-matnr
  AND locid = @gs_itab_zres-locid.

  IF sy-subrc NE 0.
    MESSAGE e003(zpedro)
      with 'ZSTOCK'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form mov
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- gv_IDMOV
*&      <-- gv_TPMOV
*&      <-- gs_ITAB_ZMOV
*&---------------------------------------------------------------------*
FORM mov  CHANGING p_gv_idmov TYPE ze_guid32
                   p_gs_itab_zmov TYPE zmov.

  SELECT MAX( idmov )
    FROM zmov
    INTO p_gv_idmov.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      with 'IDMOV MAX'.
  ENDIF.

  p_gv_idmov = p_gv_idmov + 1.

  MOVE p_gv_idmov           TO p_gs_itab_zmov-idmov.
  MOVE gs_itab_zres-matnr   TO p_gs_itab_zmov-matnr.
  MOVE gs_itab_zres-locid   TO p_gs_itab_zmov-locid.
  MOVE gv_TPMOV             TO p_gs_itab_zmov-tpmov.
  MOVE gs_itab_zres-qty_res TO p_gs_itab_zmov-qty.
  MOVE gv_data              TO p_gs_itab_zmov-data.
  MOVE gv_HORA              TO p_gs_itab_zmov-hora.

  p_gs_itab_zmov-idmov = |{ p_gs_itab_zmov-idmov ALPHA = IN }|.
  p_gs_itab_zmov-locid = |{ p_gs_itab_zmov-locid ALPHA = IN }|.

  INSERT zmov FROM p_gs_itab_zmov.

  IF sy-subrc NE 0.
    MESSAGE e000(zpedro)
      with 'ZMOV'..
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
FORM update_zres .

  UPDATE zres
  SET status = gc_status
  WHERE idres = p_IDRES.

  IF sy-subrc NE 0.
    MESSAGE e003(zpedro)
      with 'ZRES'.
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
   WHERE matnr = gs_itab_zmov-matnr
   AND locid = gs_itab_zmov-locid.

  IF sy-subrc NE 0.
    MESSAGE e000(zpedro)
      with 'ZSTOCK'.
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

  MESSAGE 'Reserva baixada com sucesso!' TYPE 'S'.

ENDFORM.
