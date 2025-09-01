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
FORM get_dt_hr CHANGING p_lv_data TYPE dats
                         p_lv_hora TYPE tims.

  lv_data = sy-datum.
  lv_HORA = sy-uzeit.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_qty
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_qty .

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
FORM check_destin CHANGING lv_destin TYPE ze_locid.

  SELECT SINGLE locid
      FROM zstock
      INTO lv_destin
      WHERE locid = p_DESTIN
      AND matnr = p_MATNR.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
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
    INTO ls_itab_zstock
    WHERE locid = p_ORIGEM
    AND matnr = p_MATNR.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_qty_origem
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_ORIGEM
*&---------------------------------------------------------------------*
FORM update_qty_origem CHANGING lv_qty_origem TYPE ze_qty3.

  lv_qty_origem = ls_itab_zstock-qty - p_QTY.

  UPDATE zstock
  SET qty = @lv_qty_origem,
  dt_atualiz = @lv_data
  WHERE locid = @p_ORIGEM
  AND matnr = @p_MATNR.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer update!' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_qty_destino
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_DESTINO
*&---------------------------------------------------------------------*
FORM update_qty_destino CHANGING lv_qty_destino TYPE ze_qty3.

  IF lv_destin IS NOT INITIAL.

    lv_qty_destino = ls_itab_zstock-qty + p_QTY.

    UPDATE zstock
    SET qty = @lv_qty_destino,
    dt_atualiz = @lv_data
    WHERE locid = @p_DESTIN
    AND matnr = @p_MATNR.

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer update!' TYPE 'E'.
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
FORM create_qty_destino CHANGING ls_itab_zstock TYPE zstock.

  IF lv_destin IS INITIAL.

    MOVE p_MATNR  TO ls_itab_zstock-matnr.
    MOVE p_DESTIN TO ls_itab_zstock-locid.
    MOVE p_QTY    TO ls_itab_zstock-qty.
    MOVE lv_data  TO ls_itab_zstock-dt_atualiz.

    ls_itab_zstock-matnr = CONV char18( |{ ls_itab_zstock-matnr ALPHA = IN }| ).
    ls_itab_zstock-locid = |{ ls_itab_zstock-locid ALPHA = IN }|.

    INSERT zstock FROM ls_itab_zstock.

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer insert!' TYPE 'E'.
    ENDIF.

    CLEAR ls_itab_zstock.

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
FORM create_zmov_origem CHANGING lv_idmov     TYPE ze_guid32
                                 ls_itab_zmov TYPE zmov.

  SELECT MAX( idmov )
    FROM zmov
    INTO lv_idmov.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
  ENDIF.

  lv_idmov = lv_idmov + 1.

  MOVE lv_idmov   TO ls_itab_zmov-idmov.
  MOVE p_MATNR    TO ls_itab_zmov-matnr.
  MOVE p_origem   TO ls_itab_zmov-locid.
  MOVE c_TPMOV_tr TO ls_itab_zmov-tpmov.
  MOVE p_QTY      TO ls_itab_zmov-qty.
  MOVE lv_data    TO ls_itab_zmov-data.
  MOVE lv_HORA    TO ls_itab_zmov-hora.
  MOVE p_OBS      TO ls_itab_zmov-obs.
  MOVE p_DESTIN   TO ls_itab_zmov-loc_dest.

  ls_itab_zmov-idmov = |{ ls_itab_zmov-idmov ALPHA = IN }|.
  ls_itab_zmov-matnr = |{ ls_itab_zmov-matnr ALPHA = IN }|.
  ls_itab_zmov-locid = |{ ls_itab_zmov-locid ALPHA = IN }|.

  INSERT zmov FROM ls_itab_zmov.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer insert!' TYPE 'E'.
  ENDIF.

  CLEAR ls_itab_zmov.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zmov_destino
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_ITAB_ZMOV
*&      <-- LV_IDMOV
*&---------------------------------------------------------------------*
FORM create_zmov_destino CHANGING lv_idmov     TYPE ze_guid32
                                  ls_itab_zmov TYPE zmov.

  SELECT MAX( idmov )
        FROM zmov
        INTO lv_idmov.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
  ENDIF.

  lv_idmov = lv_idmov + 1.

  MOVE lv_idmov   TO ls_itab_zmov-idmov.
  MOVE p_MATNR    TO ls_itab_zmov-matnr.
  MOVE p_destin   TO ls_itab_zmov-locid.
  MOVE c_TPMOV_td TO ls_itab_zmov-tpmov.
  MOVE p_QTY      TO ls_itab_zmov-qty.
  MOVE lv_data    TO ls_itab_zmov-data.
  MOVE lv_HORA    TO ls_itab_zmov-hora.
  MOVE p_OBS      TO ls_itab_zmov-obs.

  ls_itab_zmov-idmov = |{ ls_itab_zmov-idmov ALPHA = IN }|.
  ls_itab_zmov-matnr = CONV char18( |{ ls_itab_zmov-matnr ALPHA = IN }| ).
  ls_itab_zmov-locid = |{ ls_itab_zmov-locid ALPHA = IN }|.

  INSERT zmov FROM ls_itab_zmov.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer insert!' TYPE 'E'.
  ENDIF.

  CLEAR ls_itab_zmov.

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
    AND locid = p_ORIGEM
    OR locid = p_DESTIN
    AND matnr = p_MATNR.

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
          t_table      = lt_tab_zstock.

    CATCH cx_salv_msg.
      MESSAGE 'Erro ao fazer try!' TYPE 'E'.

  ENDTRY.

  CALL METHOD lr_alv->display.

ENDFORM.
