*&---------------------------------------------------------------------*
*& Include          ZSTK_TRF_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATNR
*&---------------------------------------------------------------------*
FORM valida USING p_p_matnr TYPE ze_matnr.

  IF p_ORIGEM = p_DESTIN.
    MESSAGE 'Defina um local de destino diferente do local de origem.' TYPE 'E'.
  ENDIF.

  SELECT SINGLE matnr
    FROM zstock
    INTO p_p_MATNR
    WHERE locid = p_ORIGEM
    AND matnr = p_MATNR.

  IF sy-subrc NE 0.
    MESSAGE 'Local de origem ou material inválido.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_dt_hr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_DATA
*&      <-- LV_HORA
*&---------------------------------------------------------------------*
FORM get_dt_hr CHANGING p_gv_data TYPE dats
                        p_gv_hora TYPE tims.

  p_gv_data = sy-datum.
  p_gv_HORA = sy-uzeit.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_qty
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_qty.

  SELECT SINGLE qty
    FROM zstock
    INTO @DATA(p_QTY_v)
    WHERE locid = @p_ORIGEM
    AND matnr = @p_MATNR
    AND qty GE @p_QTY.

  IF sy-subrc NE 0.
    MESSAGE 'Saldo indisponivel para realizar transferência.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_destin
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_DESTIN
*&---------------------------------------------------------------------*
FORM check_destin CHANGING p_gv_destin TYPE ze_locid.

  SELECT SINGLE locid
      FROM zstock
      INTO p_gv_destin
      WHERE locid = p_DESTIN
      AND matnr = p_MATNR.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZSTOCK'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_stock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_ORIGEM
*&---------------------------------------------------------------------*
FORM get_stock.

  SELECT SINGLE *
    FROM zstock
    INTO gs_itab_zstock
    WHERE locid = p_ORIGEM
    AND matnr = p_MATNR.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZSTOCK'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_qty_origem
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_ORIGEM
*&---------------------------------------------------------------------*
FORM update_qty_origem CHANGING p_gv_qty_origem TYPE ze_qty3.

  gv_qty_origem = gs_itab_zstock-qty - p_QTY.

  UPDATE zstock
  SET qty = @p_gv_qty_origem,
  dt_atualiz = @gv_data
  WHERE locid = @p_ORIGEM
  AND matnr = @p_MATNR.

  IF sy-subrc NE 0.
    MESSAGE e003(zpedro)
      WITH 'ZSTOCK'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_qty_destino
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_DESTINO
*&---------------------------------------------------------------------*
FORM update_qty_destino CHANGING p_gv_qty_destino TYPE ze_qty3.

  IF gv_destin IS NOT INITIAL.

    p_gv_qty_destino = gs_itab_zstock-qty + p_QTY.

    UPDATE zstock
    SET qty = @gv_qty_destino,
    dt_atualiz = @gv_data
    WHERE locid = @p_DESTIN
    AND matnr = @p_MATNR.

    IF sy-subrc NE 0.
      MESSAGE e003(zpedro)
      WITH 'ZSTOCK'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_qty_destino
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_ITAB_ZSTOCK
*&---------------------------------------------------------------------*
FORM create_qty_destino CHANGING p_gs_itab_zstock TYPE zstock.

  IF gv_destin IS INITIAL.

    MOVE p_MATNR  TO p_gs_itab_zstock-matnr.
    MOVE p_DESTIN TO p_gs_itab_zstock-locid.
    MOVE p_QTY    TO p_gs_itab_zstock-qty.
    MOVE gv_data  TO p_gs_itab_zstock-dt_atualiz.

    p_gs_itab_zstock-locid = |{ p_gs_itab_zstock-locid ALPHA = IN }|.

    INSERT zstock FROM p_gs_itab_zstock.

    IF sy-subrc NE 0.
      MESSAGE e000(zpedro)
      WITH 'ZSTOCK'.
    ENDIF.

    CLEAR p_gs_itab_zstock.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zmov_origem
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_ITAB_ZMOV
*&      <-- LV_IDMOV
*&---------------------------------------------------------------------*
FORM create_zmov_origem CHANGING p_gv_idmov     TYPE ze_guid32
                                 p_gs_itab_zmov TYPE zmov.

  SELECT MAX( idmov )
    FROM zmov
    INTO p_gv_idmov.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'IDMOV MAX'.
  ENDIF.

  p_gv_idmov = p_gv_idmov + 1.

  MOVE p_gv_idmov    TO p_gs_itab_zmov-idmov.
  MOVE p_MATNR     TO p_gs_itab_zmov-matnr.
  MOVE p_origem    TO p_gs_itab_zmov-locid.
  MOVE gc_TPMOV_tr TO p_gs_itab_zmov-tpmov.
  MOVE p_QTY       TO p_gs_itab_zmov-qty.
  MOVE gv_data     TO p_gs_itab_zmov-data.
  MOVE gv_HORA     TO p_gs_itab_zmov-hora.
  MOVE p_OBS       TO p_gs_itab_zmov-obs.
  MOVE p_DESTIN    TO p_gs_itab_zmov-loc_dest.

  p_gs_itab_zmov-idmov = |{ p_gs_itab_zmov-idmov ALPHA = IN }|.
  p_gs_itab_zmov-locid = |{ p_gs_itab_zmov-locid ALPHA = IN }|.

  INSERT zmov FROM p_gs_itab_zmov.

  IF sy-subrc NE 0.
    MESSAGE e000(zpedro)
      with 'ZRES'.
  ENDIF.

  CLEAR p_gs_itab_zmov.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zmov_destino
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_ITAB_ZMOV
*&      <-- LV_IDMOV
*&---------------------------------------------------------------------*
FORM create_zmov_destino CHANGING p_gv_idmov     TYPE ze_guid32
                                  p_gs_itab_zmov TYPE zmov.

  SELECT MAX( idmov )
        FROM zmov
        INTO p_gv_idmov.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'IDMOV MAX'.
  ENDIF.

  p_gv_idmov = p_gv_idmov + 1.

  MOVE p_gv_idmov  TO p_gs_itab_zmov-idmov.
  MOVE p_MATNR     TO p_gs_itab_zmov-matnr.
  MOVE p_destin    TO p_gs_itab_zmov-locid.
  MOVE gc_TPMOV_td TO p_gs_itab_zmov-tpmov.
  MOVE p_QTY       TO p_gs_itab_zmov-qty.
  MOVE gv_data     TO p_gs_itab_zmov-data.
  MOVE gv_HORA     TO p_gs_itab_zmov-hora.
  MOVE p_OBS       TO p_gs_itab_zmov-obs.

  p_gs_itab_zmov-idmov = |{ p_gs_itab_zmov-idmov ALPHA = IN }|.
  p_gs_itab_zmov-locid = |{ p_gs_itab_zmov-locid ALPHA = IN }|.

  INSERT zmov FROM p_gs_itab_zmov.

  IF sy-subrc NE 0.
    MESSAGE e000(zpedro)
      WITH 'ZMOV'.
  ENDIF.

  CLEAR p_gs_itab_zmov.

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
    AND locid = p_ORIGEM
    OR locid = p_DESTIN
    AND matnr = p_MATNR.

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
