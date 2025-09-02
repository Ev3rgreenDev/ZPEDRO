*&---------------------------------------------------------------------*
*& Report ZR02_EXTRATO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr02_extrato.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_CPF    TYPE ze_CPF OBLIGATORY,
              p_DATA_I TYPE dats,
              p_DATA_F TYPE dats,
              p_FILTRO TYPE ze_tp_tx.

SELECTION-SCREEN END OF BLOCK b01.

DATA: " TABELA DE CONTAS
  lt_tab_contas  TYPE TABLE OF ztacc,
  ls_est_contas  TYPE zsacc,
  lt_ttab_contas TYPE zttacc,
  ls_itab_contas TYPE ztacc,

  "TABELA DE TRANSAÇÕES
  lt_tab_tx      TYPE TABLE OF ztacc_tx,
  ls_est_tx      TYPE zsacc_tx,
  lt_ttab_tx     TYPE zttacc_tx,
  ls_itab_tx     TYPE ztacc_tx,

  " VARIAVEIS LOCAIS
  lv_id_tx       TYPE ze_id_tx,
  lv_tp_tx       TYPE ze_tp_tx,
  lv_descr       TYPE ze_desc,
  lv_data        TYPE dats,
  lv_hora        TYPE tims,
  lv_saldo_final TYPE ze_saldo,
  lr_alv         TYPE REF TO cl_salv_table..


"DATA INICIAL

AT SELECTION-SCREEN ON p_DATA_I.
  IF p_DATA_I IS INITIAL.
    SELECT MIN( data )
          INTO lv_data
    FROM ztacc_tx.

    p_DATA_I = lv_data.

  ENDIF.

  "DATA FINAL

AT SELECTION-SCREEN ON p_DATA_F.

  IF p_DATA_F IS INITIAL.
    p_DATA_F = sy-datum.

  ENDIF.



START-OF-SELECTION.

  " VERIFICAÇÕES

  SELECT SINGLE cpf
    INTO p_cpf
    FROM ztacc
    WHERE cpf = p_CPF.

  IF sy-subrc <> 0.
    MESSAGE 'CPF ínválido.' TYPE 'E'.

  ELSEIF p_FILTRO IS NOT INITIAL.

    SELECT *
      FROM ztacc_tx
      INTO TABLE lt_tab_tx
      WHERE tp_tx = p_FILTRO
        AND data GE p_DATA_I
          AND data LE p_DATA_F.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = lr_alv
          CHANGING
            t_table      = lt_tab_tx.

      CATCH cx_salv_msg.

    ENDTRY.

    CALL METHOD lr_alv->display.

  ELSE.

    SELECT *
          FROM ztacc_tx
          INTO TABLE lt_tab_tx
          WHERE data GE p_DATA_I
              AND data LE p_DATA_F.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = lr_alv
          CHANGING
            t_table      = lt_tab_tx.

      CATCH cx_salv_msg.

    ENDTRY.

    CALL METHOD lr_alv->display.

  ENDIF.
