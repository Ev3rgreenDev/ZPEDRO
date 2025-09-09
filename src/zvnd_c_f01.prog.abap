*&---------------------------------------------------------------------*
*& Include          ZVND_C_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_CUSTID
*&      --> P_DATA_I
*&      --> P_DATA_F
*&      --> P_STATUS
*&---------------------------------------------------------------------*
FORM valida  USING    i_p_vbeln  TYPE vbeln
                      i_p_custid TYPE ze_custid
                      i_p_data_i TYPE dats
                      i_p_status TYPE ze_status

             CHANGING i_p_data_f TYPE dats.

  IF i_p_vbeln IS NOT INITIAL.

    SELECT SINGLE vbeln
      FROM zvnd_h
      INTO @DATA(lv_p_vbeln)
      WHERE vbeln = @i_p_vbeln.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'do pedido'.
    ENDIF.
  ENDIF.

  IF i_p_custid IS NOT INITIAL.

    SELECT SINGLE custid
      FROM zvnd_h
      INTO @DATA(lv_custid)
      WHERE custid = @i_p_custid.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'de clientes do pedido'.
    ENDIF.
  ENDIF.

  IF i_p_data_i GT i_p_data_f.
    MESSAGE e020(zpedro).
  ENDIF.

  IF i_p_status IS NOT INITIAL.

    SELECT SINGLE status
      FROM zvnd_h
      INTO @DATA(lv_status)
      WHERE status = @i_p_status.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'de status do pedido'.
    ENDIF.
  ENDIF.

  IF i_p_data_f IS INITIAL.

    i_p_data_f = sy-datum.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_fields
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_CUSTID
*&      --> P_DATA_I
*&      --> P_DATA_F
*&      --> P_STATUS
*&---------------------------------------------------------------------*
FORM get_fields USING i_p_custid  TYPE ze_custid
                      i_p_data_i  TYPE dats
                      i_p_data_f  TYPE dats
                      i_p_status  TYPE ze_status

             CHANGING p_gv_campos TYPE string.


  IF p_vbeln IS NOT INITIAL.
    p_gv_campos = 'VBELN = p_vbeln'.
  ENDIF.

  IF i_p_custid IS NOT INITIAL.
    p_gv_campos = p_gv_campos && ' AND CUSTID = p_custid'.
  ENDIF.

  IF i_p_data_i IS NOT INITIAL.
    p_gv_campos = p_gv_campos && ' AND DATA_DOC GE p_data_i AND DATA_DOC LE p_data_f'.
  ENDIF.

  IF i_p_status IS NOT INITIAL.
    p_gv_campos = p_gv_campos && ' AND STATUS = p_status'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form super_alv
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GR_ALV
*&      --> GT_ZVND_H
*&      --> GT_ZVND_I
*&---------------------------------------------------------------------*
FORM super_alv USING p_gv_campos TYPE string.

  DATA: gd_fieldcat2 TYPE lvc_t_fcat.
  CLEAR gd_fieldcat2.

  SELECT *
    FROM zvnd_h
    INTO TABLE gt_zvnd_h
    WHERE (gv_campos).

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'da tabela de pedidos'.
  ENDIF.

  SELECT *
    FROM zvnd_i
    INTO TABLE gt_zvnd_i
    FOR ALL ENTRIES IN gt_zvnd_h
    WHERE vbeln = gt_zvnd_h-vbeln.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'da tabela de itens'.
  ENDIF.



ENDFORM.
