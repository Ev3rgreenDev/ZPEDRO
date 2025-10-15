*&---------------------------------------------------------------------*
*& Report ZINV_ABRIR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zinv_abrir.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_MATNR TYPE ze_MATNR OBLIGATORY,
              p_LOCID TYPE ze_LOCID OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZINV
  lt_tab_ZINV    TYPE TABLE OF zinv,
  ls_itab_ZINV   TYPE zinv,

  " ALV
  lr_alv         TYPE REF TO cl_salv_table,
  lo_agregador   TYPE REF TO cl_salv_aggregations,
  oref           TYPE REF TO cx_root,
  lo_sort        TYPE REF TO cl_salv_sorts,
  lo_sort_column TYPE REF TO cl_salv_sort,

  " VARIAVEIS LOCAIS
  lv_data        TYPE dats,
  lv_IDINV       TYPE ze_guid32,
  lv_status      TYPE ze_stat_inv,
  lv_HORA        TYPE tims,
  lv_qty_origem  TYPE ze_qty3,
  lv_qty_destino TYPE ze_qty3,
  lv_saida       TYPE ze_qty3,
  lv_campos      TYPE string.

AT SELECTION-SCREEN.

  SELECT SINGLE matnr
    FROM zstock
    INTO p_MATNR
    WHERE matnr = p_MATNR
    and locid = p_LOCID.

  IF sy-subrc NE 0.
    MESSAGE 'Material ou local inválido.' TYPE 'E'.
  ENDIF.


START-OF-SELECTION.

  SELECT MAX( idinv )
        FROM zinv
        INTO lv_idinv.

  lv_idinv  = lv_idinv + 1.
  lv_status = 'A'.
  lv_data   = sy-datum.

  MOVE lv_idinv TO ls_itab_zinv-idinv.
  MOVE p_MATNR TO ls_itab_zinv-matnr.
  MOVE p_LOCID TO ls_itab_zinv-locid.
  MOVE lv_data TO ls_itab_zinv-data_cont.
  MOVE lv_status TO ls_itab_zinv-status.


  ls_itab_zinv-idinv = |{ ls_itab_zinv-idinv ALPHA = IN }|.
  ls_itab_zinv-matnr = |{ ls_itab_zinv-matnr ALPHA = IN }|.
  ls_itab_zinv-locid = |{ ls_itab_zinv-locid ALPHA = IN }|.

  INSERT zinv FROM ls_itab_zinv.

  " RELATÓRIO ALV
      SELECT *
        FROM zinv
        INTO TABLE lt_tab_zinv
        WHERE MATNR = p_MATNR
        AND LOCID = p_LOCID.

      TRY.
          CALL METHOD cl_salv_table=>factory
            EXPORTING
              list_display = if_salv_c_bool_sap=>false
            IMPORTING
              r_salv_table = lr_alv
            CHANGING
              t_table      = lt_tab_zinv.

        CATCH cx_salv_msg.

      ENDTRY.

      CALL METHOD lr_alv->display.
      " FIM RELATÓRIO ALV
