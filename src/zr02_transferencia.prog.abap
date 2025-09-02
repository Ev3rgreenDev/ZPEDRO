*&---------------------------------------------------------------------*
*& Report ZR02_TRANSFERENCIA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr02_transferencia.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_CPFO  TYPE ze_CPF OBLIGATORY,
              p_CPFD  TYPE ze_cpf_dest OBLIGATORY,
              p_VALOR TYPE ze_valor OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.

DATA: " TABELA DE CONTAS
  lt_tab_contas    TYPE TABLE OF ztacc,
  ls_est_contas    TYPE zsacc,
  lt_ttab_contas   TYPE zttacc,
  ls_itab_contas   TYPE ztacc,

  "TABELA DE TRANSAÇÕES
  lt_tab_tx        TYPE TABLE OF ztacc_tx,
  ls_est_tx        TYPE zsacc_tx,
  lt_ttab_tx       TYPE zttacc_tx,
  ls_itab_tx       TYPE ztacc_tx,

  " VARIAVEIS LOCAIS
  lv_id_tx         TYPE ze_id_tx,
  lv_tp_tx         TYPE ze_tp_tx,
  lv_descr         TYPE ze_desc,
  lv_data          TYPE dats,
  lv_hora          TYPE tims,
  lv_saldo_final_o TYPE ze_saldo,
  lv_saldo_final_d TYPE ze_saldo.


START-OF-SELECTION.

  " VERIFICAÇÕES

  SELECT SINGLE cpf
        INTO p_cpfO
        FROM ztacc
        WHERE cpf = p_CPFO.

  IF sy-subrc <> 0.
    MESSAGE 'O CPF de origem é ínválido.' TYPE 'E'.

  ELSE.
    SELECT SINGLE cpf
      INTO p_cpfD
      FROM ztacc
      WHERE cpf = p_CPFD.

    IF sy-subrc <> 0.
      MESSAGE 'O CPF de destino é ínválido.' TYPE 'E'.

    ELSEIF p_valor LE 0.
      MESSAGE 'Insira um valor maior do que 0.' TYPE 'E'.

    ELSE.
      SELECT SINGLE saldo
        INTO lv_saldo_final_o
        FROM ztacc
        WHERE cpf = p_cpfo.

      IF p_valor GT lv_saldo_final_o.
        MESSAGE 'Saldo insuficiente para saque.' TYPE 'E'.

      ELSE.

        " ATUALIZAÇÃO DO SALDO


        " UPDATE NA CONTA ORIGEM
        lv_saldo_final_o = lv_saldo_final_o - p_valor.

        UPDATE ztacc
        SET saldo = lv_saldo_final_o
        WHERE cpf = p_cpfo.

        IF sy-subrc = 4.
          MESSAGE 'Erro em depositar na conta origem.' TYPE 'E'.
        ELSE.

          " UPDATE NA CONTA DESTINO
          SELECT SINGLE saldo
             INTO lv_saldo_final_D
             FROM ztacc
             WHERE cpf = p_cpfD.

          lv_saldo_final_d = lv_saldo_final_d + p_valor.

          UPDATE ztacc
          SET saldo = lv_saldo_final_d
          WHERE cpf = p_cpfd.

          IF sy-subrc = 4.
            MESSAGE 'Erro em creditar na conta destino.' TYPE 'E'.

            " ROLLBACK NA CONTA ORIGEM EM CASO DE ERRO
            SELECT SINGLE saldo
              INTO lv_saldo_final_o
              FROM ztacc
              WHERE cpf = p_cpfo.

            lv_saldo_final_o = lv_saldo_final_o + p_valor.

            UPDATE ztacc
              SET saldo = lv_saldo_final_o
              WHERE cpf = p_cpfo.

          ELSE.

            WRITE: / 'Valor transferido:', p_valor,
                   / 'Saldo atual:', lv_saldo_final_o.

            lv_data = sy-datum.
            lv_hora = sy-uzeit.

            " UPDATE NA CONTA ORIGEM
            UPDATE ztacc
            SET dt_atualiz = lv_data
            WHERE cpf = p_cpfo.

            UPDATE ztacc
            SET hora_atualiz = lv_hora
            WHERE cpf = p_cpfo.

            " UPDATE NA CONTA DESTINO
            UPDATE ztacc
            SET dt_atualiz = lv_data
            WHERE cpf = p_cpfD.

            UPDATE ztacc
            SET hora_atualiz = lv_hora
            WHERE cpf = p_cpfD.



            " INSERÇÃO ÀS TRANSAÇÕES

            SELECT *
                FROM ztacc_tx
                INTO TABLE lt_tab_TX.

            lv_tp_tx = 'D'.
            lv_data = sy-datum.
            lv_hora = sy-uzeit.
            lv_descr = 'Transferência.'.


            " TRANSAÇÃO DA CONTA ORIGEM
            ADD p_cpfO     TO ls_est_tx-cpf.
            ADD p_cpfd     TO ls_est_tx-cpf_DEST.
            ADD p_VALOR    TO ls_est_tx-valor.
            MOVE lv_tp_tx  TO ls_est_tx-tp_tx.
            ADD lv_data    TO ls_est_tx-data.
            ADD lv_hora    TO ls_est_tx-hora.
            MOVE lv_descr  TO ls_est_tx-descr.

            SELECT MAX( id_tx )
              FROM ztacc_tx
              INTO lv_id_tx.

            lv_id_tx = lv_id_tx + 1.

            ADD lv_id_tx TO ls_est_tx-id_tx.

            APPEND ls_est_tx TO lt_ttab_tx.
            CLEAR ls_est_tx.

            " TRANSAÇÃO DA CONTA DESTINO

            lv_tp_tx = 'C'.
            ADD p_cpfD     TO ls_est_tx-cpf.
            ADD p_VALOR    TO ls_est_tx-valor.
            MOVE lv_tp_tx  TO ls_est_tx-tp_tx.
            ADD lv_data    TO ls_est_tx-data.
            ADD lv_hora    TO ls_est_tx-hora.
            MOVE lv_descr  TO ls_est_tx-descr.

            SELECT MAX( id_tx )
              FROM ztacc_tx
              INTO lv_id_tx.

            lv_id_tx = lv_id_tx + 1.

            ADD lv_id_tx TO ls_est_tx-id_tx.

            APPEND ls_est_tx TO lt_ttab_tx.
            CLEAR ls_est_tx.



            " CONVERSÃO E INSERÇÃO
            LOOP AT lt_ttab_tx INTO ls_est_tx.

              ls_est_tx-cpf = |{ ls_est_tx-cpf ALPHA = IN }|.
              ls_est_tx-cpf_DEST = |{ ls_est_tx-cpf_DEST ALPHA = IN }|.

              ls_itab_tx = CORRESPONDING #( ls_est_tx ).
              INSERT ztacc_tx FROM ls_itab_tx.

            ENDLOOP.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.
