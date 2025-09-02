*&---------------------------------------------------------------------*
*& Report ZINV_CONTAR
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zinv_contar.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_IDINV TYPE ze_guid32 OBLIGATORY,
              p_QTY   TYPE ze_qty3 OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.

DATA: "TABELA ZSTOCK
  lt_tab_zstock  TYPE TABLE OF zstock,
  ls_est_zstock  TYPE zsstock,
  ls_itab_zstock TYPE zstock,

  " TABELA ZINV
  lt_tab_ZINV    TYPE TABLE OF zinv,
  ls_itab_ZINV   TYPE zinv,

  " VARIAVEIS LOCAIS
  lr_alv         TYPE REF TO cl_salv_table,
  lv_data        TYPE dats.


AT SELECTION-SCREEN.

  SELECT SINGLE idinv
    FROM zinv
    INTO p_IDINV
    WHERE idinv = p_IDINV
    AND status = 'A'.

  IF sy-subrc NE 0.
    MESSAGE 'Item inválido.' TYPE 'E'.
  ENDIF.

  IF p_QTY LT 0.
    MESSAGE 'Insira uma quantidade maior ou igual a 0.' TYPE 'E'.
  ENDIF.

  lv_data = sy-datum.


START-OF-SELECTION.

  UPDATE zinv
  SET qty_contada = p_QTY
  WHERE idinv = p_IDINV.

  UPDATE zinv
  SET status = 'F'
  WHERE idinv = p_IDINV.

  UPDATE zinv
  SET data_cont = lv_data
  WHERE idinv = p_IDINV.


  " RELATÓRIO ALV
  SELECT *
    FROM zinv
    INTO TABLE lt_tab_zinv
    WHERE idinv = p_IDINV.

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
