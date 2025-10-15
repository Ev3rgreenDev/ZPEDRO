*&---------------------------------------------------------------------*
*& Report ZSTK_ENT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstk_ent.

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
  lv_HORA        TYPE tims.


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

  IF sy-subrc = 0.

    p_QTY = ls_itab_zstock-qty + p_QTY.

    UPDATE zstock
    SET qty = p_QTY
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.

    UPDATE zstock
    SET dt_atualiz = lv_DATA
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.

    " MOV
    SELECT MAX( idmov )
      FROM zmov
      INTO lv_idmov.

    lv_idmov = lv_idmov + 1.

    lv_tpmov = 'EN'.

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

  ELSE.

    SELECT SINGLE matnr
      FROM zstock
      INTO p_MATNR
      WHERE matnr = p_MATNR.

    "SE MATERIAL NÃO EXISTIR
    IF sy-subrc = 4.

      MOVE p_MATNR TO ls_itab_zstock-matnr.
      MOVE p_LOCID TO ls_itab_zstock-locid.
      MOVE p_QTY TO ls_itab_zstock-qty.
      MOVE lv_data TO ls_itab_zstock-dt_atualiz.

      ls_itab_zstock-matnr = |{ ls_itab_zstock-matnr ALPHA = IN }|.
      ls_itab_zstock-locid = |{ ls_itab_zstock-locid ALPHA = IN }|.

      INSERT zstock FROM ls_itab_zstock.


      " MOV
      SELECT MAX( idmov )
        FROM zmov
        INTO lv_idmov.

      lv_idmov = lv_idmov + 1.

      lv_tpmov = 'EN'.

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


      "SE MATERIAL EXISTIR
    ELSEIF sy-subrc = 0.

      SELECT SINGLE locid
        FROM zstock
        INTO p_LOCID
        WHERE locid = p_LOCID.

      "SE LOCAL NÃO EXISTIR
      IF sy-subrc = 4.

        MOVE p_MATNR TO ls_itab_zstock-matnr.
        MOVE p_LOCID TO ls_itab_zstock-locid.
        MOVE p_QTY   TO ls_itab_zstock-qty.
        MOVE lv_data TO ls_itab_zstock-dt_atualiz.

        ls_itab_zstock-matnr = |{ ls_itab_zstock-matnr ALPHA = IN }|.
        ls_itab_zstock-locid = |{ ls_itab_zstock-locid ALPHA = IN }|.

        INSERT zstock FROM ls_itab_zstock.


        " MOV
        SELECT MAX( idmov )
          FROM zmov
          INTO lv_idmov.

        lv_idmov = lv_idmov + 1.

        lv_tpmov = 'EN'.

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


        "SE LOCAL EXISTIR
      ELSEIF sy-subrc = 0.

        MOVE p_MATNR TO ls_itab_zstock-matnr.
        MOVE p_LOCID TO ls_itab_zstock-locid.
        MOVE p_QTY   TO ls_itab_zstock-qty.
        MOVE lv_data TO ls_itab_zstock-dt_atualiz.

        ls_itab_zstock-matnr = |{ ls_itab_zstock-matnr ALPHA = IN }|.
        ls_itab_zstock-locid = |{ ls_itab_zstock-locid ALPHA = IN }|.

        INSERT zstock FROM ls_itab_zstock.

        " MOV
        SELECT MAX( idmov )
          FROM zmov
          INTO lv_idmov.

        lv_idmov = lv_idmov + 1.

        lv_tpmov = 'EN'.

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


      ELSE.
        MESSAGE 'Algo deu errado com o local!' TYPE 'E'.
      ENDIF.

    ELSE.
      MESSAGE 'Algo deu errado com o material!' TYPE 'E'.
    ENDIF.
  ENDIF.
