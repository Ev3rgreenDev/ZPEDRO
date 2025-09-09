*&---------------------------------------------------------------------*
*& Include          ZCUST_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida_cpf
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_CPF
*&---------------------------------------------------------------------*
FORM valida_cpf  USING i_p_cpf TYPE ze_CPF2.

  SELECT SINGLE cpf
    FROM zcust
    INTO p_CPF
    WHERE cpf = i_p_cpf.

  IF sy-subrc = 0.
    MESSAGE e005(zpedro).
  ENDIF.


  SELECT SINGLE *
    FROM ztacc
    INTO @DATA(ls_ztacc)
    WHERE cpf = @i_p_cpf.

  IF sy-subrc NE 0.
    MESSAGE e004(zpedro).

  ELSEIF p_NOME NE ls_ztacc-nome.
    MESSAGE e006(zpedro).

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_custid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_CUSTID
*&---------------------------------------------------------------------*
FORM create_custid CHANGING p_lv_custid TYPE ze_custid.

  SELECT MAX( custid )
    FROM zcust
    INTO p_lv_custid.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'CUSTID MAX'.
  ENDIF.

  p_lv_custid = p_lv_custid + 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_client
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_CPF
*&      --> P_NOME
*&      --> P_ATIVO
*&      <-- GWA_ZCUST
*&      <-- LV_CUSTID
*&---------------------------------------------------------------------*
FORM create_client  USING    i_p_cpf     TYPE ze_cpf2
                             i_p_nome    TYPE ze_nome
                             i_p_ativo   TYPE ze_flag
                             p_lv_custid TYPE ze_custid
                    CHANGING p_gwa_zcust TYPE zcust.

  MOVE p_lv_custid TO p_gwa_zcust-custid.
  MOVE i_p_cpf     TO p_gwa_zcust-cpf.
  MOVE i_p_nome    TO p_gwa_zcust-nome.
  MOVE i_p_ativo   TO p_gwa_zcust-ativo.

  p_gwa_zcust-custid = |{ p_gwa_zcust-custid ALPHA = IN }|.
  p_gwa_zcust-cpf    = |{ p_gwa_zcust-cpf ALPHA = IN }|.

  INSERT zcust FROM p_gwa_zcust.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form alv_event
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM alv_event.

  SELECT *
     FROM zcust
     INTO TABLE gt_zcust
     WHERE cpf = p_CPF.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZCUST'.
  ENDIF.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_ZCUST.

      MESSAGE s007(zpedro).

    CATCH cx_salv_msg.
      MESSAGE e001(zpedro).

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
