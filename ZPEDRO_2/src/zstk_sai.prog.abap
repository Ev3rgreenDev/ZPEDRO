*&---------------------------------------------------------------------*
*& Report ZSTK_SAI
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstk_sai.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_LOCID TYPE ze_LOCID OBLIGATORY,
              p_QTY   TYPE ze_QTY3 OBLIGATORY,
              p_OBS   TYPE ze_OBS.

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
  lv_QTY         TYPE ze_QTY3.


AT SELECTION-SCREEN ON p_MATNR.

  SELECT SINGLE matnr
    FROM zstock
    INTO p_MATNR
    WHERE matnr = p_MATNR.

  IF sy-subrc NE 0.
    MESSAGE 'Material não existe!' TYPE 'E'.
  ENDIF.

AT SELECTION-SCREEN ON p_LOCID.

  SELECT SINGLE locid
  FROM zstock
  INTO p_LOCID
  WHERE locid = p_LOCID.

  IF sy-subrc NE 0.
    MESSAGE 'Local não existe!' TYPE 'E'.
  ENDIF.

AT SELECTION-SCREEN.
  lv_data = sy-datum.
  lv_HORA = sy-uzeit.


START-OF-SELECTION.

  SELECT *
    FROM zstock
    INTO ls_itab_zstock
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.
  ENDSELECT.

  IF ls_itab_zstock-qty LT p_QTY.

    MESSAGE 'Quantidade em estoque é menor do que a quantidade desejada para saída.' TYPE 'E'.

  ELSE.

    lv_QTY = ls_itab_zstock-qty - p_QTY.

    UPDATE zstock
    SET qty = lv_QTY
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.

    " MOV
    SELECT MAX( idmov )
      FROM zmov
      INTO lv_idmov.

    lv_idmov = lv_idmov + 1.

    lv_tpmov = 'SA'.

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

    " RELATÓRIO ALV
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
    " FIM RELATÓRIO ALV

  ENDIF.
