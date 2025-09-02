*&---------------------------------------------------------------------*
*& Report ZR02_CONTA_COM_CPF
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr02_conta_com_cpf.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_CPF   TYPE ze02_CPF OBLIGATORY,
              p_NOME  TYPE ze02_NOME,
              p_VALOR TYPE ze02_valor_conta.

SELECTION-SCREEN END OF BLOCK b01.


DATA: LT_tab_conta_cpf     TYPE TABLE OF zt02_conta_cpf,
      LS_est_conta_cpf     TYPE zs02_conta_cpf,
      ls_est_conta_cpf_tab TYPE zt02_conta_cpf,
      LT_ttab_conta_cpf    TYPE ztt02_conta_cpf.



AT SELECTION-SCREEN ON p_cpf.
  IF p_CPF = ' '.
    MESSAGE 'Favor insira o seu CPF.' TYPE 'E'.
  ENDIF.


START-OF-SELECTION.

  SELECT SINGLE cpf
    INTO P_cpf
    FROM zt02_conta_cpf
    WHERE cpf = P_cpf.

  IF sy-subrc <> 0.
    IF p_nome = ' '.
      MESSAGE 'Favor insira o seu nome.' TYPE 'E'.

    ELSE.

      ADD p_cpf TO ls_est_conta_cpf-cpf.
      MOVE p_nome TO ls_est_conta_cpf-nome.
      ADD p_valor TO ls_est_conta_cpf-valor_conta.

      APPEND ls_est_conta_cpf TO LT_ttab_conta_cpf.
      CLEAR ls_est_conta_cpf.

      LOOP AT LT_ttab_conta_cpf INTO ls_est_conta_cpf.

        ls_est_conta_cpf_tab = CORRESPONDING #( ls_est_conta_cpf ).
        MODIFY zt02_conta_cpf FROM ls_est_conta_cpf_tab.

        MESSAGE 'Conta criada com sucesso!' TYPE 'S'.

      ENDLOOP.
    ENDIF.

  ELSE.

    SELECT *
     FROM zt02_conta_cpf
     INTO TABLE LT_tab_conta_cpf
     WHERE cpf = p_CPF.

    LOOP AT LT_tab_conta_cpf INTO ls_est_conta_cpf_tab.



      WRITE: ls_est_conta_cpf_tab-nome, sy-uline.

      IF p_valor = ' '.
        MESSAGE 'Favor insira um valor a ser retirado.' TYPE 'E'.

      ELSEIF p_valor GT ls_est_conta_cpf_tab-valor_conta.
        MESSAGE 'Valor a ser sacado é maior do que o valor em conta.' TYPE 'E'.

      ELSE.
        ls_est_conta_cpf_tab-valor_conta = ls_est_conta_cpf_tab-valor_conta - p_valor.

        WRITE: ls_est_conta_cpf_tab-valor_conta, sy-uline.

        UPDATE zt02_conta_cpf
        SET valor_conta = ls_est_conta_cpf_tab-valor_conta
        WHERE cpf = p_CPF.


      ENDIF.
    ENDLOOP.
  ENDIF.
