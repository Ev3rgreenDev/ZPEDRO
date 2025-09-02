*&---------------------------------------------------------------------*
*& Include          ZSTK_ENT_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form check_stock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LS_ITAB_ZSTOCK
*&---------------------------------------------------------------------*
FORM check_stock  CHANGING p_gs_itab_zstock TYPE zstock.

  SELECT SINGLE *
   FROM zstock
   INTO p_gs_itab_zstock
   WHERE matnr = p_MATNR
   AND locid = p_LOCID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_stock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LS_ITAB_ZSTOCK
*&      --> P_QTY
*&      <-- LV_QTY
*&---------------------------------------------------------------------*
FORM update_stock USING    p_qty          TYPE ze_qty3
                  CHANGING p_gv_qty         TYPE ze_qty3
                           p_gs_itab_zstock TYPE zstock.

  IF p_gs_itab_zstock IS NOT INITIAL.

    gv_data = sy-datum.
    p_gv_qty = gs_itab_zstock-qty + p_QTY.

    UPDATE zstock
    SET qty = @gv_qty,
    dt_atualiz = @gv_DATA
    WHERE matnr = @p_MATNR
    AND locid = @p_LOCID.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zmov
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_IDMOV
*&      <-- LS_ITAB_ZMOV
*&---------------------------------------------------------------------*
FORM create_zmov USING    p_qty          TYPE ze_qty3
                          p_gv_qty       TYPE ze_qty3
                 CHANGING i_gv_idmov     TYPE ze_guid32
                          p_gs_itab_zmov TYPE zmov.

  SELECT MAX( idmov )
     FROM zmov
     INTO i_gv_idmov.

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer select!' TYPE 'E'.
    ENDIF.

    gv_hora = sy-uzeit.
    gv_data = sy-datum.
    i_gv_idmov = gv_idmov + 1.

    MOVE gv_idmov TO p_gs_itab_zmov-idmov.
    MOVE p_MATNR  TO p_gs_itab_zmov-matnr.
    MOVE p_LOCID  TO p_gs_itab_zmov-locid.
    MOVE gc_TPMOV TO p_gs_itab_zmov-tpmov.
    MOVE gv_data  TO p_gs_itab_zmov-data.
    MOVE gv_HORA  TO p_gs_itab_zmov-hora.
    MOVE p_OBS    TO p_gs_itab_zmov-obs.

    IF gs_itab_zstock IS NOT INITIAL.

      MOVE p_gv_qty TO p_gs_itab_zmov-qty.

    ELSE.

      MOVE p_qty TO p_gs_itab_zmov-qty.

    ENDIF.

    p_gs_itab_zmov-idmov = |{ p_gs_itab_zmov-idmov ALPHA = IN }|.
    p_gs_itab_zmov-locid = |{ p_gs_itab_zmov-locid ALPHA = IN }|.

    INSERT zmov FROM p_gs_itab_zmov.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_matnr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_MATNR
*&      <-- LS_ITAB_ZSTOCK
*&---------------------------------------------------------------------*
FORM create_stock  USING    p_gv_matnr       TYPE ze_matnr
                   CHANGING p_gs_itab_zstock TYPE zstock.

  IF p_gs_itab_zstock IS INITIAL.

    gv_data = sy-datum.

    MOVE p_MATNR TO p_gs_itab_zstock-matnr.
    MOVE p_LOCID TO p_gs_itab_zstock-locid.
    MOVE p_QTY   TO p_gs_itab_zstock-qty.
    MOVE gv_data TO p_gs_itab_zstock-dt_atualiz.

    p_gs_itab_zstock-locid = |{ p_gs_itab_zstock-locid ALPHA = IN }|.

    INSERT zstock FROM p_gs_itab_zstock.

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer insert!' TYPE 'E'.
    ENDIF.

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
       FROM zstock
       INTO TABLE gt_tab_zstock
       WHERE matnr = gs_itab_zstock-matnr
       AND locid = gs_itab_zstock-locid.

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer select!' TYPE 'E'.
    ENDIF.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = gr_alv
          CHANGING
            t_table      = gt_tab_zstock.

      CATCH cx_salv_msg.
        MESSAGE 'Erro ao fazer try!' TYPE 'E'.

    ENDTRY.

    CALL METHOD gr_alv->display.

ENDFORM.
