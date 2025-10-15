*&---------------------------------------------------------------------*
*& Include          ZVND_H_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida_parameters
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_CUSTID
*&      --> P_MOEDA
*&---------------------------------------------------------------------*
FORM valida_parameters  USING i_p_custid TYPE ze_CUSTID
                              i_p_moeda  TYPE tcurc-waers.

  IF i_p_custid IS NOT INITIAL.

    SELECT SINGLE custid
      FROM zcust
      INTO i_p_custid
      WHERE custid = i_p_custid.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'de ID do cliente'.
    ENDIF.
  ENDIF.

  IF i_p_moeda IS NOT INITIAL.

    SELECT SINGLE waers
      FROM tcurc
      INTO p_moeda
      WHERE waers = p_moeda.

    IF sy-subrc NE 0.
      MESSAGE e010(zpedro).
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zvnd_h
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_CUSTID
*&      --> P_MOEDA
*&      --> P_OBS
*&      <-- GWA_ZVND_H
*&---------------------------------------------------------------------*
FORM create_zvnd_h  USING    i_p_custid   TYPE ze_CUSTID
                             i_p_moeda    TYPE tcurc-waers
                             i_p_obs      TYPE ze_obs

                    CHANGING p_gwa_zvnd_h TYPE zvnd_h
                             p_gv_vbeln   TYPE vbeln.

  DATA: lv_data_doc  TYPE dats,
        lv_hora_doc  TYPE tims,
        lv_val_bruto TYPE ze_price,
        lv_val_desc  TYPE ze_price,
        lv_val_liq   TYPE ze_price,
        lv_status    TYPE ze_status,
        lv_VBELN     TYPE vbeln.

  lv_DATA_DOC  = sy-datum.
  lv_hora_doc  = sy-uzeit.
  lv_status    = 'O'.
  lv_val_bruto = 0.
  lv_val_desc  = 0.
  lv_val_liq   = 0.

  SELECT MAX( vbeln )
    FROM zvnd_h
    INTO p_gv_VBELN.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'VBELN MAX'.
  ENDIF.

  p_gv_VBELN = p_gv_VBELN + 1.

  MOVE p_gv_VBELN     TO p_gwa_zvnd_h-vbeln.
  MOVE i_p_CUSTID   TO p_gwa_zvnd_h-custid.
  MOVE lv_DATA_DOC  TO p_gwa_zvnd_h-data_doc.
  MOVE lv_HORA_DOC  TO p_gwa_zvnd_h-hora_doc.
  MOVE i_p_MOEDA    TO p_gwa_zvnd_h-moeda.
  MOVE lv_VAL_BRUTO TO p_gwa_zvnd_h-val_bruto.
  MOVE lv_VAL_DESC  TO p_gwa_zvnd_h-val_desc.
  MOVE lv_VAL_LIQ   TO p_gwa_zvnd_h-val_liq.
  MOVE lv_STATUS    TO p_gwa_zvnd_h-status.
  MOVE i_p_OBS      TO p_gwa_zvnd_h-obs.

  p_gwa_zvnd_h-vbeln = |{ p_gwa_zvnd_h-vbeln ALPHA = IN }|.

  INSERT zvnd_h FROM p_gwa_zvnd_h.

  IF sy-subrc NE 0.
    MESSAGE e000(zpedro)
      WITH 'ZVND_H'.
  ENDIF.

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
     FROM zvnd_h
     INTO TABLE gt_ZVND_H
     WHERE vbeln = gwa_zvnd_h-vbeln.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZVND_H'.
  ENDIF.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_ZVND_H.

      MESSAGE s013(zpedro).

    CATCH cx_salv_msg.
      MESSAGE e001(zpedro).

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
