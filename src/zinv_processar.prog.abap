*&---------------------------------------------------------------------*
*& Report ZINV_PROCESSAR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zinv_processar.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_IDINV TYPE ze_guid32 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZINV
  lt_tab_ZINV    TYPE TABLE OF zinv,
  ls_itab_ZINV   TYPE zinv,

  " TABELA ZMOV
  lt_tab_zmov    TYPE TABLE OF zmov,
  ls_est_zmov    TYPE zsmov,
  ls_itab_zmov   TYPE zmov,

  " VARIAVEIS LOCAIS
  lr_alv         TYPE REF TO cl_salv_table,
  lv_data        TYPE dats,
  lv_dif         TYPE ze_qty3,
  lv_qty_stock   TYPE ze_qty3,
  lv_qty_final   TYPE ze_qty3,
  lv_IDMOV       TYPE ze_guid32,
  lv_TPMOV       TYPE ze_tpmov,
  lv_HORA        TYPE tims,
  lv_obs         TYPE ze_obs.


AT SELECTION-SCREEN.

  SELECT SINGLE status
    FROM zinv
    INTO @DATA(lv_status)
    WHERE idinv = @p_IDINV.

  IF sy-subrc NE 0.
    MESSAGE 'ID inválido.' TYPE 'E'.

  ELSEIF lv_status NE 'F'.
    MESSAGE 'Inventário ainda não foi fechado.' TYPE 'E'.

  ENDIF.


START-OF-SELECTION.

  SELECT SINGLE *
    FROM zinv
    INTO ls_itab_zinv
    WHERE idinv = p_IDINV.

  SELECT SINGLE qty
    FROM zstock
    INTO lv_qty_stock
    WHERE matnr = ls_itab_zinv-matnr
    AND locid = ls_itab_zinv-locid.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao acessar o material correspondente ao IDINV inserido.' TYPE 'E'.
  ENDIF.

  lv_dif = ls_itab_zinv-qty_contada - lv_qty_stock.


  IF lv_dif GT 0.

    lv_qty_final = lv_dif + lv_qty_stock.

    UPDATE zstock
    SET qty = lv_qty_final
    WHERE matnr = ls_itab_zinv-matnr
    AND locid = ls_itab_zinv-locid.

    " MOV
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

    " RELATÓRIO ALV
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
    " FIM RELATÓRIO ALV

  ELSEIF lv_dif LT 0.

    lv_qty_final = lv_qty_stock - lv_dif.

    IF lv_qty_final lt 0.
      MESSAGE 'Ajuste não pode deixar o valor final ser negativo!' TYPE 'E'.
    ENDIF.

    UPDATE zstock
    SET qty = lv_qty_final
    WHERE matnr = ls_itab_zinv-matnr
    AND locid = ls_itab_zinv-locid.

    " MOV
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

    " RELATÓRIO ALV
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
    " FIM RELATÓRIO ALV
  ENDIF.

  UPDATE zinv
  set status = 'p'
  WHERE idinv = p_IDINV.
