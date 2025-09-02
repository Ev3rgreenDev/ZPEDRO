*&---------------------------------------------------------------------*
*& Report ZRES_CRIAR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zres_criar.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_LOCID TYPE ze_LOCID OBLIGATORY,
              p_QTY   TYPE ze_QTY3  OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZMOV
  lt_tab_zres    TYPE TABLE OF zres,
  ls_est_zres    TYPE zres,
  ls_itab_zres   TYPE zres,

  " VARIAVEIS LOCAIS
  lr_alv         TYPE REF TO cl_salv_table,
  lv_data        TYPE dats,
  lv_IDRES       TYPE ze_guid32,
  lv_TPMOV       TYPE ze_tpmov,
  lv_HORA        TYPE tims,
  lv_status      TYPE ze_stat_res,
  lv_qty_res     TYPE ze_qty3.

AT SELECTION-SCREEN.

  SELECT SINGLE matnr
    FROM zstock
    INTO p_MATNR
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.

  IF sy-subrc NE 0.
    MESSAGE 'Material e/ou local inválido.' TYPE 'E'.
  ENDIF.

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

  lv_data = sy-datum.


START-OF-SELECTION.

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

  " RELATÓRIO ALV
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
  " FIM RELATÓRIO ALV
