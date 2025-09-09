*&---------------------------------------------------------------------*
*& Include          ZVND_F_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida_pedido
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_VBELN
*&---------------------------------------------------------------------*
FORM valida_pedido USING i_p_vbeln TYPE vbeln.

  DATA(lc_status_o) = 'O'.

  IF i_p_vbeln IS NOT INITIAL.

    SELECT SINGLE vbeln
      FROM zvnd_h
      INTO i_p_vbeln
      WHERE vbeln = i_p_vbeln
      AND status  = lc_status_o.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'de pedidos'.
    ENDIF.

    SELECT SINGLE vbeln
      FROM zvnd_i
      INTO i_p_vbeln
      WHERE vbeln = i_p_vbeln.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'de itens'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form change_status
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_VBELN
*&---------------------------------------------------------------------*
FORM change_status USING i_p_vbeln.

  DATA(lc_status_f) = 'F'.

  UPDATE zvnd_h
  SET status = lc_status_f
  WHERE vbeln = i_p_vbeln.

  IF sy-subrc NE 0.
    MESSAGE e003(zpedro)
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
   WHERE vbeln = p_vbeln.

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

      MESSAGE s019(zpedro)
        WITH p_vbeln.

    CATCH cx_salv_msg.
      MESSAGE e001(zpedro).

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
