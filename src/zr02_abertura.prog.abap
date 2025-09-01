*&---------------------------------------------------------------------*
*& Report ZR02_ABERTURA
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr02_abertura.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_CPF   TYPE ze_CPF OBLIGATORY,
              p_NOME  TYPE ze_NOME OBLIGATORY,
              p_SALDO TYPE ze_saldo.

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
  lv_hora        TYPE tims.


START-OF-SELECTION.

  SELECT SINGLE cpf
    INTO p_cpf
    FROM ztacc
    WHERE cpf = p_CPF.

  IF sy-subrc = 0.
    MESSAGE 'CPF já foi cadastrado.' TYPE 'E'.

  ELSE.

    lv_data = sy-datum.
    " CRIAÇÃO DO USUÁRIO
    ADD p_cpf   TO ls_est_contas-cpf.
    MOVE p_nome TO ls_est_contas-nome.
    ADD p_saldo TO ls_est_contas-saldo.
    ADD lv_data TO ls_est_contas-dt_atualiz.

    APPEND ls_est_contas TO lt_ttab_contas.
    CLEAR ls_est_contas.

    LOOP AT lt_ttab_contas INTO ls_est_contas.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_est_contas-cpf
        IMPORTING
          output = ls_est_contas-cpf.

      ls_itab_contas = CORRESPONDING #( ls_est_contas ).
      MODIFY ztACC FROM ls_itab_contas.

      MESSAGE 'Conta criada com sucesso!' TYPE 'S'.

      WRITE: /'Sua conta foi criada',
             /'CPF:', p_cpf,
             /'Nome:', p_nome,
             /'Saldo:', p_saldo.

    ENDLOOP.
  ENDIF.



  " INSERÇÃO ÀS TRANSAÇÕES

  IF p_saldo IS NOT INITIAL.

    SELECT *
        FROM ztacc_tx
        INTO TABLE lt_tab_TX.

    lv_tp_tx = 'C'.
    lv_data = sy-datum.
    lv_hora = sy-uzeit.
    lv_descr = 'Depósito inicial de abertura de conta.'.


    ADD p_cpf     TO ls_est_tx-cpf.
    ADD p_saldo   TO ls_est_tx-valor.
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
