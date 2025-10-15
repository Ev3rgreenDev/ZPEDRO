*&---------------------------------------------------------------------*
*& Report ZCUST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zcust.

INCLUDE zcust_top.

INCLUDE zcust_f01.


AT SELECTION-SCREEN.
  PERFORM valida_cpf USING p_CPF.


START-OF-SELECTION.

  PERFORM create_custid CHANGING lv_custid.

  PERFORM create_client USING    p_CPF
                                 p_NOME
                                 p_ATIVO
                                 lv_CUSTID

                        CHANGING gwa_zcust.

  PERFORM alv_event.
