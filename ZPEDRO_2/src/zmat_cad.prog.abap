*&---------------------------------------------------------------------*
*& Report ZMAT_CAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmat_cad.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_DESCR TYPE ze_DESCR OBLIGATORY,
              p_UNID  TYPE ze_UNID  OBLIGATORY,
              p_ATIVO TYPE ze_FLAG  OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.

DATA:
  lt_tab_zmat  TYPE TABLE OF zmat,
  ls_est_zmat  TYPE zsmat,
  ls_itab_zmat TYPE zmat,
  lt_ttab_zmat TYPE zttmat,
  lr_alv       TYPE REF TO cl_salv_table.



AT SELECTION-SCREEN ON p_UNID.

  SELECT SINGLE msehi
    FROM t006
    INTO p_UNID
    WHERE msehi = p_UNID.

  IF sy-subrc NE 0.
    MESSAGE 'Unidade de medida inexistente, favor inserir uma unidade existente.' TYPE 'E'.
  ENDIF.


START-OF-SELECTION.

  SELECT SINGLE matnr
    FROM zmat
    INTO p_MATNR
    WHERE matnr = p_MATNR.


  " SE EXISTIR MATNR
  IF sy-subrc = 0.

    UPDATE zmat
    SET descr = p_DESCR
    WHERE matnr = p_MATNR.

    UPDATE zmat
    SET unid = p_UNID
    WHERE matnr = p_MATNR.

    UPDATE zmat
    SET ativo = p_ATIVO
    WHERE matnr = p_MATNR.


    " RELATÓRIO ALV
    SELECT *
  FROM zmat
  INTO TABLE lt_tab_zmat
  WHERE matnr = p_MATNR.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = lr_alv
          CHANGING
            t_table      = lt_tab_zmat.

      CATCH cx_salv_msg.

    ENDTRY.

    CALL METHOD lr_alv->display.
    " FIM RELATÓRIO ALV



    " SE NÃO EXISTIR MATNR
  ELSEIF sy-subrc = 4.

    MOVE p_MATNR TO ls_itab_zmat-matnr.
    MOVE p_DESCR TO ls_itab_zmat-descr.
    MOVE p_UNID  TO ls_itab_zmat-unid.
    MOVE p_ATIVO TO ls_itab_zmat-ativo.

    ls_itab_zmat-matnr = CONV char18( |{ ls_itab_zmat-matnr ALPHA = IN }| ).


    INSERT zmat FROM ls_itab_zmat.


    " RELATÓRIO ALV
    SELECT *
      FROM zmat
      INTO TABLE lt_tab_zmat
      WHERE matnr = p_MATNR.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = lr_alv
          CHANGING
            t_table      = lt_tab_zmat.

      CATCH cx_salv_msg.

    ENDTRY.

    CALL METHOD lr_alv->display.
    " FIM RELATÓRIO ALV


    " SE DER RUIM
  ELSE.
    MESSAGE 'Algo deu errado!' TYPE 'E'.
  ENDIF.
