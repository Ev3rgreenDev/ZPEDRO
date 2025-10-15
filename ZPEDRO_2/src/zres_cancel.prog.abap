*&---------------------------------------------------------------------*
*& Report ZRES_CANCEL
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zres_cancel.

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
    WHERE idres = p_IDRES
    AND status = 'A'.

  IF sy-subrc NE 0.
    MESSAGE 'A reserva requisitada não existe' TYPE 'E'.
  ENDIF.


START-OF-SELECTION.

  UPDATE zres
   SET status = 'C'
   WHERE idres = p_IDRES.

  " RELATÓRIO ALV
  SELECT *
    FROM zres
    INTO TABLE lt_tab_zres
    WHERE idres = p_IDRES.

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
