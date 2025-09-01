*&---------------------------------------------------------------------*
*& Report ZR02_JUROS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr02_juros.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_TAXA TYPE ze_TAXA OBLIGATORY,
              p_MES  TYPE ze_COMPETENCIA OBLIGATORY,
              p_ANO  TYPE ze_ANO OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b01.

DATA: " TABELA DE CONTAS
  lt_tab_contas    TYPE TABLE OF ztacc,
  ls_est_contas    TYPE zsacc,
  lt_ttab_contas   TYPE zttacc,
  ls_itab_contas   TYPE ztacc,
  lt_cpf           TYPE TABLE OF /iwbep/s_cod_select_option,

  "TABELA DE TRANSAÇÕES
  lt_tab_tx        TYPE TABLE OF ztacc_tx,
  ls_est_tx        TYPE zsacc_tx,
  lt_ttab_tx       TYPE zttacc_tx,
  ls_itab_tx       TYPE ztacc_tx,

  " VARIAVEIS LOCAIS
  lv_id_tx         TYPE ze_id_tx,
  lv_tp_tx         TYPE ze_tp_tx,
  lv_descr         TYPE ze_desc,
  lv_data_I        TYPE dats,
  lv_data_F        TYPE dats,
  lv_data          TYPE dats,
  lv_hora          TYPE tims,
  lv_saldo_inicial TYPE ze_saldo,
  lv_saldo_final   TYPE ze_saldo,
  lv_juros         TYPE ze_valor.


AT SELECTION-SCREEN.

  CONCATENATE '31'
              p_MES
              p_ANO

  INTO lv_data_F.

  CONCATENATE '01'
              p_MES
              p_ANO

  INTO lv_data_F.

  lv_data = sy-datum.
  lv_hora = sy-uzeit.


START-OF-SELECTION.

  SELECT *
    FROM ztacc_tx
    INTO TABLE lt_tab_tx
    WHERE tp_tx = 'J'.

*  LOOP AT lt_tab_tx INTO ls_itab_tx.
*
*    APPEND VALUE /iwbep/s_cod_select_option(
*        sign   = 'I'
*        option = 'NE'  "BT = BETWEEN
*        low    = ls_itab_tx-cpf
*     ) TO lt_CPF.
*
*  ENDLOOP.

  lt_cpf = VALUE #(
    FOR ls_tx IN lt_tab_tx (
        sign   = 'I'
        option = 'NE'
        low    = ls_tx-cpf
    )
  ).


  SELECT cpf, SUM( valor ) AS valor
    FROM ztacc_tx
    INTO TABLE @DATA(lt_tab_tx_juros)
    WHERE cpf IN @lt_cpf
    AND data GE @lv_data_I
    AND data GE @lv_data_F
          GROUP BY cpf.



  LOOP AT lt_tab_TX_juros INTO DATA(ls_itab_TX_juros).

    lv_juros = ls_itab_TX_juros-valor * ( p_TAXA / 100  ).

    WRITE: /'CPF:', ls_itab_TX_juros-cpf,
           /'Saldo:', lv_juros.


    SELECT *
          INTO ls_itab_contas
          FROM ztacc
          WHERE cpf = ls_itab_TX_juros-cpf
          AND saldo GT lv_juros.
    ENDSELECT.

    lv_saldo_final = ls_itab_contas-saldo - lv_juros.

    " INSERÇÃO ÀS TRANSAÇÕES

    SELECT *
    FROM ztacc_tx
    INTO TABLE @DATA(lt_tab_tx_nova).

    lv_tp_tx = 'J'.
    lv_descr = 'Aplicação de juros.'.

    ADD ls_itab_contas-cpf TO ls_est_tx-cpf.
    ADD lv_juros           TO ls_est_tx-valor.
    MOVE lv_tp_tx          TO ls_est_tx-tp_tx.
    ADD lv_data            TO ls_est_tx-data.
    ADD lv_hora            TO ls_est_tx-hora.
    MOVE lv_descr          TO ls_est_tx-descr.


    SELECT MAX( id_tx )
      FROM ztacc_tx
      INTO lv_id_tx.

    lv_id_tx = lv_id_tx + 1.

    ADD lv_id_tx TO ls_est_tx-id_tx.

    ls_est_tx-cpf = |{ ls_est_tx-cpf ALPHA = IN }|.
    ls_est_tx-cpf_DEST = |{ ls_est_tx-cpf_DEST ALPHA = IN }|.

    ls_itab_tx = CORRESPONDING #( ls_est_tx ).
    INSERT ztacc_tx FROM ls_itab_tx.

    CLEAR ls_est_tx.
    CLEAR ls_itab_tx.


    " ATUALIZAÇÃO DO SALDO

    UPDATE ztacc
    SET saldo = lv_saldo_final
    WHERE cpf = ls_itab_TX_juros-cpf.

    UPDATE ztacc
    SET dt_atualiz = lv_data
    WHERE cpf = ls_itab_TX_juros-cpf.

    UPDATE ztacc
    SET hora_atualiz = lv_hora
    WHERE cpf = ls_itab_TX_juros-cpf.

  ENDLOOP.
