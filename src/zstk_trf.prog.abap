*&---------------------------------------------------------------------*
*& Report ZSTK_TRF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstk_trf.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR  TYPE ze_MATNR OBLIGATORY,
              p_ORIGEM TYPE ze_LOCID OBLIGATORY,
              p_DESTIN TYPE ze_LOCID OBLIGATORY,
              p_QTY    TYPE ze_QTY3 OBLIGATORY,
              p_OBS    TYPE ze_OBS.

SELECTION-SCREEN END OF BLOCK b01.

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZMOV
  lt_tab_zmov    TYPE TABLE OF zmov,
  ls_est_zmov    TYPE zsmov,
  ls_itab_zmov   TYPE zmov,

  " VARIAVEIS LOCAIS
  lr_alv         TYPE REF TO cl_salv_table,
  lv_data        TYPE dats,
  lv_IDMOV       TYPE ze_guid32,
  lv_TPMOV       TYPE ze_tpmov,
  lv_HORA        TYPE tims,
  lv_qty_origem  TYPE ze_qty3,
  lv_qty_destino TYPE ze_qty3.


AT SELECTION-SCREEN.

  IF p_ORIGEM = p_DESTIN.
    MESSAGE 'Defina um local de destino diferente do local de origem.' TYPE 'E'.
  ENDIF.

  SELECT SINGLE matnr
    FROM zstock
    INTO p_MATNR
    WHERE locid = p_ORIGEM
    AND matnr = p_MATNR.

  IF sy-subrc NE 0.
    MESSAGE 'Local de origem ou material inválido.' TYPE 'E'.
  ENDIF.

  lv_data = sy-datum.
  lv_HORA = sy-uzeit.


START-OF-SELECTION.

  SELECT SINGLE qty
    FROM zstock
    INTO @data(p_QTY_v)
    WHERE locid = @p_ORIGEM
    AND matnr = @p_MATNR
    AND qty GE @p_QTY.

  IF sy-subrc NE 0.
    MESSAGE 'Saldo indisponivel para realizar transferência.' TYPE 'E'.

  ELSE.
    SELECT SINGLE locid
      FROM zstock
      INTO p_DESTIN
      WHERE locid = p_DESTIN.

    " CASO DESTINO EXISTA
    IF sy-subrc = 0.

      " DEBITO
      SELECT *
        FROM zstock
        INTO ls_itab_zstock
        WHERE locid = p_ORIGEM
        AND matnr = p_MATNR.
      ENDSELECT.

      lv_qty_origem = ls_itab_zstock-qty - p_QTY.

      UPDATE zstock
      SET qty = lv_qty_origem
      WHERE locid = p_ORIGEM
      AND matnr = p_MATNR.

      UPDATE zstock
      SET dt_atualiz = lv_data
      WHERE locid = p_ORIGEM
      AND matnr = p_MATNR.

      " MOV
      SELECT MAX( idmov )
        FROM zmov
        INTO lv_idmov.

      lv_idmov = lv_idmov + 1.

      lv_tpmov = 'TR'.

      MOVE lv_idmov TO ls_itab_zmov-idmov.
      MOVE p_MATNR  TO ls_itab_zmov-matnr.
      MOVE p_origem TO ls_itab_zmov-locid.
      MOVE lv_TPMOV TO ls_itab_zmov-tpmov.
      MOVE p_QTY    TO ls_itab_zmov-qty.
      MOVE lv_data  TO ls_itab_zmov-data.
      MOVE lv_HORA  TO ls_itab_zmov-hora.
      MOVE p_OBS    TO ls_itab_zmov-obs.
      MOVE p_DESTIN TO ls_itab_zmov-loc_dest.

      ls_itab_zmov-idmov = |{ ls_itab_zmov-idmov ALPHA = IN }|.
      ls_itab_zmov-matnr = |{ ls_itab_zmov-matnr ALPHA = IN }|.
      ls_itab_zmov-locid = |{ ls_itab_zmov-locid ALPHA = IN }|.

      INSERT zmov FROM ls_itab_zmov.
      CLEAR ls_itab_zstock.
      CLEAR ls_itab_zmov.

      " CREDITO
      SELECT *
        FROM zstock
        INTO ls_itab_zstock
        WHERE locid = p_DESTIN
        AND matnr = p_MATNR.
      ENDSELECT.

      lv_qty_destino = ls_itab_zstock-qty + p_QTY.

      UPDATE zstock
      SET qty = lv_qty_destino
      WHERE locid = p_DESTIN
      AND matnr = p_MATNR.

      UPDATE zstock
      SET dt_atualiz = lv_data
      WHERE locid = p_DESTIN
      AND matnr = p_MATNR.

      " MOV
      SELECT MAX( idmov )
        FROM zmov
        INTO lv_idmov.

      lv_idmov = lv_idmov + 1.

      lv_tpmov = 'TD'.

      MOVE lv_idmov TO ls_itab_zmov-idmov.
      MOVE p_MATNR  TO ls_itab_zmov-matnr.
      MOVE p_destin  TO ls_itab_zmov-locid.
      MOVE lv_TPMOV TO ls_itab_zmov-tpmov.
      MOVE p_QTY    TO ls_itab_zmov-qty.
      MOVE lv_data  TO ls_itab_zmov-data.
      MOVE lv_HORA  TO ls_itab_zmov-hora.
      MOVE p_OBS    TO ls_itab_zmov-obs.

      ls_itab_zmov-idmov = |{ ls_itab_zmov-idmov ALPHA = IN }|.
      ls_itab_zmov-matnr = |{ ls_itab_zmov-matnr ALPHA = IN }|.
      ls_itab_zmov-locid = |{ ls_itab_zmov-locid ALPHA = IN }|.

      INSERT zmov FROM ls_itab_zmov.

      CLEAR ls_itab_zstock.
      CLEAR ls_itab_zmov.

      " RELATÓRIO ALV
      SELECT *
        FROM zstock
        INTO TABLE lt_tab_zstock
        WHERE matnr = p_MATNR
        AND locid = p_ORIGEM
        OR locid = p_DESTIN.

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
      " FIM RELATÓRIO ALV

      " CASO NÃO EXISTA O DESTINO
    ELSEIF sy-subrc = 4.

      " DEBITO
      SELECT *
        FROM zstock
        INTO ls_itab_zstock
        WHERE locid = p_ORIGEM
        AND matnr = p_MATNR.
      ENDSELECT.

      lv_qty_origem = ls_itab_zstock-qty - p_QTY.

      UPDATE zstock
      SET qty = lv_qty_origem
      WHERE locid = p_ORIGEM
      AND matnr = p_MATNR.

      UPDATE zstock
      SET dt_atualiz = lv_data
      WHERE locid = p_ORIGEM
      AND matnr = p_MATNR.

      " MOV
      SELECT MAX( idmov )
        FROM zmov
        INTO lv_idmov.

      lv_idmov = lv_idmov + 1.

      lv_tpmov = 'TR'.

      MOVE lv_idmov TO ls_itab_zmov-idmov.
      MOVE p_MATNR  TO ls_itab_zmov-matnr.
      MOVE p_origem TO ls_itab_zmov-locid.
      MOVE lv_TPMOV TO ls_itab_zmov-tpmov.
      MOVE p_QTY    TO ls_itab_zmov-qty.
      MOVE lv_data  TO ls_itab_zmov-data.
      MOVE lv_HORA  TO ls_itab_zmov-hora.
      MOVE p_OBS    TO ls_itab_zmov-obs.
      MOVE p_DESTIN TO ls_itab_zmov-loc_dest.

      ls_itab_zmov-idmov = |{ ls_itab_zmov-idmov ALPHA = IN }|.
      ls_itab_zmov-matnr = |{ ls_itab_zmov-matnr ALPHA = IN }|.
      ls_itab_zmov-locid = |{ ls_itab_zmov-locid ALPHA = IN }|.

      INSERT zmov FROM ls_itab_zmov.
      CLEAR ls_itab_zstock.
      CLEAR ls_itab_zmov.

      " CREDITO
      MOVE p_MATNR  TO ls_itab_zstock-matnr.
      MOVE p_DESTIN TO ls_itab_zstock-locid.
      MOVE p_QTY    TO ls_itab_zstock-qty.
      MOVE lv_data  TO ls_itab_zstock-dt_atualiz.

      ls_itab_zstock-matnr = |{ ls_itab_zstock-matnr ALPHA = IN }|.
      ls_itab_zstock-locid = |{ ls_itab_zstock-locid ALPHA = IN }|.

      INSERT zstock FROM ls_itab_zstock.
      CLEAR ls_itab_zstock.

      " MOV
      SELECT MAX( idmov )
        FROM zmov
        INTO lv_idmov.

      lv_idmov = lv_idmov + 1.

      lv_tpmov = 'TD'.

      MOVE lv_idmov TO ls_itab_zmov-idmov.
      MOVE p_MATNR  TO ls_itab_zmov-matnr.
      MOVE p_destin  TO ls_itab_zmov-locid.
      MOVE lv_TPMOV TO ls_itab_zmov-tpmov.
      MOVE p_QTY    TO ls_itab_zmov-qty.
      MOVE lv_data  TO ls_itab_zmov-data.
      MOVE lv_HORA  TO ls_itab_zmov-hora.
      MOVE p_OBS    TO ls_itab_zmov-obs.

      ls_itab_zmov-idmov = |{ ls_itab_zmov-idmov ALPHA = IN }|.
      ls_itab_zmov-matnr = |{ ls_itab_zmov-matnr ALPHA = IN }|.
      ls_itab_zmov-locid = |{ ls_itab_zmov-locid ALPHA = IN }|.

      INSERT zmov FROM ls_itab_zmov.

      CLEAR ls_itab_zstock.
      CLEAR ls_itab_zmov.

      " RELATÓRIO ALV
      SELECT *
        FROM zstock
        INTO TABLE lt_tab_zstock
        WHERE matnr = p_MATNR
        AND locid = p_ORIGEM
        OR locid = p_DESTIN.

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
      " FIM RELATÓRIO ALV



    ELSE.
      MESSAGE 'Algo deu errado.' TYPE 'E'.
    ENDIF.
  ENDIF.
