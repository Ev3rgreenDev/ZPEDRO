*&---------------------------------------------------------------------*
*& Report ZR02_SAQUE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr02_saque.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_CPF   TYPE ze_CPF OBLIGATORY,
              p_VALOR TYPE ze_valor OBLIGATORY.

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
  lv_saldo_final TYPE ze_saldo.


START-OF-SELECTION.

  " VERIFICAÇÕES

  SELECT SINGLE cpf
        INTO p_cpf
        FROM ztacc
        WHERE cpf = p_CPF.

  IF sy-subrc <> 0.
    MESSAGE 'CPF ínválido.' TYPE 'E'.

  ELSEIF p_valor LE 0.
    MESSAGE 'Insira um valor maior do que 0.' TYPE 'E'.

  ELSE.

    SELECT SINGLE saldo
      INTO lv_saldo_final
      FROM ztacc
      WHERE cpf = p_cpf.

    IF p_valor GT lv_saldo_final.
      MESSAGE 'Saldo insuficiente para saque.' TYPE 'E'.

    ELSE.

      " ATUALIZAÇÃO DO SALDO

      lv_saldo_final = lv_saldo_final - p_valor.

      UPDATE ztacc
      SET saldo = lv_saldo_final
      WHERE cpf = p_cpf.
      CLEAR ls_est_contas.

      WRITE: / 'Valor sacado:', p_valor,
             / 'Saldo atual:', lv_saldo_final.

      lv_data = sy-datum.
      lv_hora = sy-uzeit.

      UPDATE ztacc
      SET dt_atualiz = lv_data
      WHERE cpf = p_cpf.

      UPDATE ztacc
      SET hora_atualiz = lv_hora
      WHERE cpf = p_cpf.


      " INSERÇÃO ÀS TRANSAÇÕES

      SELECT *
          FROM ztacc_tx
          INTO TABLE lt_tab_TX.

      lv_tp_tx = 'D'.
      lv_data = sy-datum.
      lv_hora = sy-uzeit.
      lv_descr = 'Saque.'.


      ADD p_cpf     TO ls_est_tx-cpf.
      ADD p_VALOR   TO ls_est_tx-valor.
      MOVE lv_tp_tx TO ls_est_tx-tp_tx.
      ADD lv_data   TO ls_est_tx-data.
      ADD lv_hora   TO ls_est_tx-hora.
      MOVE lv_descr TO ls_est_tx-descr.

      SELECT MAX( id_tx )
        FROM ztacc_tx
        INTO lv_id_tx.

      lv_id_tx = lv_id_tx + 1.

      ADD lv_id_tx TO ls_est_tx-id_tx.


      APPEND ls_est_tx TO lt_ttab_tx.
      CLEAR ls_est_tx.


      LOOP AT lt_ttab_tx INTO ls_est_tx.

        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_est_tx-cpf
          IMPORTING
            output = ls_est_tx-cpf.

        ls_itab_tx = CORRESPONDING #( ls_est_tx ).
        INSERT ztacc_tx FROM ls_itab_tx.

      ENDLOOP.

    ENDIF.
  ENDIF.
