*&---------------------------------------------------------------------*
*& Report ZRES_USAR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zres_usar.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_IDRES TYPE ze_GUID32 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZRES
  lt_tab_zres    TYPE TABLE OF zres,
  ls_est_zres    TYPE zres,
  ls_itab_zres   TYPE zres,

  " TABELA ZMOV
  lt_tab_zmov    TYPE TABLE OF zmov,
  ls_est_zmov    TYPE zsmov,
  ls_itab_zmov   TYPE zmov,

  " VARIAVEIS LOCAIS
  lr_alv         TYPE REF TO cl_salv_table,
  lv_data        TYPE dats,
  lv_IDRES       TYPE ze_guid32,
  lv_idmov       TYPE ze_guid32,
  lv_TPMOV       TYPE ze_tpmov,
  lv_HORA        TYPE tims,
  lv_status      TYPE ze_stat_res,
  lv_qty_res     TYPE ze_qty3,
  lv_qty_final   TYPE ze_qty3,
  lv_qty_stock   TYPE ze_qty3.

AT SELECTION-SCREEN.

  SELECT SINGLE idres
    FROM zres
    INTO p_IDRES
    WHERE idres = p_IDRES.

  IF sy-subrc NE 0.
    MESSAGE 'A reserva requisitada não existe' TYPE 'E'.
  ENDIF.

  lv_data = sy-datum.
  lv_hora = sy-uzeit.



START-OF-SELECTION.

  SELECT SINGLE *
    FROM zres
    INTO ls_itab_zres
    WHERE idres = p_IDRES.

  SELECT SINGLE qty
    FROM zstock
    INTO lv_qty_stock
    WHERE matnr = ls_itab_zres-matnr
    AND locid = ls_itab_zres-locid.


  IF lv_qty_stock LT ls_itab_zres-qty_res.
    MESSAGE 'Valor da reserva é maior do que valor em estoque.' TYPE 'E'.
  ENDIF.

  lv_qty_final = lv_qty_stock - ls_itab_zres-qty_res.

  UPDATE zstock
  SET qty = lv_qty_final
  WHERE matnr = ls_itab_zres-matnr
  AND locid = ls_itab_zres-locid.

  UPDATE zstock
  SET dt_atualiz = lv_data
  WHERE matnr = ls_itab_zres-matnr
  AND locid = ls_itab_zres-locid.


  " MOV
  SELECT MAX( idmov )
    FROM zmov
    INTO lv_idmov.

  lv_idmov = lv_idmov + 1.

  lv_tpmov = 'SA'.

  MOVE lv_idmov             TO ls_itab_zmov-idmov.
  MOVE ls_itab_zres-matnr   TO ls_itab_zmov-matnr.
  MOVE ls_itab_zres-locid   TO ls_itab_zmov-locid.
  MOVE lv_TPMOV             TO ls_itab_zmov-tpmov.
  MOVE ls_itab_zres-qty_res TO ls_itab_zmov-qty.
  MOVE lv_data              TO ls_itab_zmov-data.
  MOVE lv_HORA              TO ls_itab_zmov-hora.

  ls_itab_zmov-idmov = |{ ls_itab_zmov-idmov ALPHA = IN }|.
  ls_itab_zmov-matnr = |{ ls_itab_zmov-matnr ALPHA = IN }|.
  ls_itab_zmov-locid = |{ ls_itab_zmov-locid ALPHA = IN }|.

  INSERT zmov FROM ls_itab_zmov.

  UPDATE zres
  SET status = 'U'
  WHERE idres = p_IDRES.

  " RELATÓRIO ALV
  SELECT *
    FROM zstock
    INTO TABLE lt_tab_zstock
    WHERE matnr = ls_itab_zmov-matnr
    AND locid = ls_itab_zmov-locid.

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

  MESSAGE 'Reserva baixada com sucesso!' TYPE 'S'.
