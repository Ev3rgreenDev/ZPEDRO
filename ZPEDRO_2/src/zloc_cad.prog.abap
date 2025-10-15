*&---------------------------------------------------------------------*
*& Report ZLOC_CAD
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zloc_cad.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_LOCID TYPE ze_LOCID OBLIGATORY,
              p_DESCR TYPE ze_DESCR,
              p_ATIVO TYPE ze_flag.

SELECTION-SCREEN END OF BLOCK b01.

DATA:
  lt_tab_zloc  TYPE TABLE OF zloc,
  ls_est_zloc  TYPE zsloc,
  ls_itab_zloc TYPE zloc,
  lr_alv       TYPE REF TO cl_salv_table.


START-OF-SELECTION.

  SELECT SINGLE locid
    FROM zloc
    INTO p_LOCID
    WHERE locid = p_LOCID.


  " SE EXISTIR LOCID
  IF sy-subrc = 0.
    UPDATE zloc
     SET descr = p_DESCR
     WHERE locid = p_LOCID.

    UPDATE zloc
    SET ativo = p_ATIVO
    WHERE locid = p_LOCID.

    " RELATÓRIO ALV
    SELECT *
  FROM zloc
  INTO TABLE lt_tab_ZLOC
  WHERE locid = p_LOCID.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = lr_alv
          CHANGING
            t_table      = lt_tab_zloc.

      CATCH cx_salv_msg.

    ENDTRY.

    CALL METHOD lr_alv->display.
    " FIM RELATÓRIO ALV


    " SE NÃO EXISTIR LOCID
  ELSEIF sy-subrc = 4.

    MOVE p_LOCID TO ls_itab_zloc-locid.
    MOVE p_DESCR TO ls_itab_zloc-descr.
    MOVE p_ATIVO TO ls_itab_zloc-ativo.

    ls_itab_zloc-locid = |{ ls_itab_zloc-locid ALPHA = IN }|.


    INSERT zloc FROM ls_itab_zloc.


    " RELATÓRIO ALV
    SELECT *
      FROM zloc
      INTO TABLE lt_tab_zloc.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = lr_alv
          CHANGING
            t_table      = lt_tab_zloc.

      CATCH cx_salv_msg.

    ENDTRY.

    CALL METHOD lr_alv->display.
    " FIM RELATÓRIO ALV


    " SE DER RUIM
  ELSE.
    MESSAGE 'Algo deu errado!' TYPE 'E'.
  ENDIF.
