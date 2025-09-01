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
FORM check_stock  CHANGING ls_itab_zstock TYPE zstock.

  SELECT SINGLE *
   FROM zstock
   INTO ls_itab_zstock
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
                  CHANGING lv_qty         TYPE ze_qty3
                           ls_itab_zstock TYPE zstock.

  IF ls_itab_zstock IS NOT INITIAL.

    lv_data = sy-datum.
    lv_qty = ls_itab_zstock-qty + p_QTY.

    UPDATE zstock
    SET qty = @lv_qty,
    dt_atualiz = @lv_DATA
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
FORM create_zmov USING    p_qty        TYPE ze_qty3
                          lv_qty       TYPE ze_qty3
                 CHANGING lv_idmov     TYPE ze_guid32
                          ls_itab_zmov TYPE zmov.

  SELECT MAX( idmov )
     FROM zmov
     INTO lv_idmov.

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer select!' TYPE 'E'.
    ENDIF.

    lv_hora = sy-uzeit.
    lv_data = sy-datum.
    lv_idmov = lv_idmov + 1.

    MOVE lv_idmov TO ls_itab_zmov-idmov.
    MOVE p_MATNR  TO ls_itab_zmov-matnr.
    MOVE p_LOCID  TO ls_itab_zmov-locid.
    MOVE c_TPMOV TO ls_itab_zmov-tpmov.
    MOVE lv_data  TO ls_itab_zmov-data.
    MOVE lv_HORA  TO ls_itab_zmov-hora.
    MOVE p_OBS    TO ls_itab_zmov-obs.

    IF ls_itab_zstock IS NOT INITIAL.

      MOVE lv_qty TO ls_itab_zmov-qty.

    ELSE.

      MOVE p_qty TO ls_itab_zmov-qty.

    ENDIF.

    ls_itab_zmov-idmov = |{ ls_itab_zmov-idmov ALPHA = IN }|.
    ls_itab_zmov-matnr = CONV char18( |{ ls_itab_zmov-matnr ALPHA = IN }| ).
    ls_itab_zmov-locid = |{ ls_itab_zmov-locid ALPHA = IN }|.

    INSERT zmov FROM ls_itab_zmov.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_matnr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_MATNR
*&      <-- LS_ITAB_ZSTOCK
*&---------------------------------------------------------------------*
FORM create_stock  USING    lv_matnr       TYPE ze_matnr
                   CHANGING ls_itab_zstock TYPE zstock.

  IF ls_itab_zstock IS INITIAL.

    lv_data = sy-datum.

    MOVE p_MATNR TO ls_itab_zstock-matnr.
    MOVE p_LOCID TO ls_itab_zstock-locid.
    MOVE p_QTY TO ls_itab_zstock-qty.
    MOVE lv_data TO ls_itab_zstock-dt_atualiz.

    ls_itab_zstock-matnr = CONV char18( |{ ls_itab_zstock-matnr ALPHA = IN }| ).
    ls_itab_zstock-locid = |{ ls_itab_zstock-locid ALPHA = IN }|.

    INSERT zstock FROM ls_itab_zstock.

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
       INTO TABLE lt_tab_zstock
       WHERE matnr = ls_itab_zstock-matnr
       AND locid = ls_itab_zstock-locid.

    IF sy-subrc NE 0.
      MESSAGE 'Erro ao fazer select!' TYPE 'E'.
    ENDIF.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            list_display = if_salv_c_bool_sap=>false
          IMPORTING
            r_salv_table = lr_alv
          CHANGING
            t_table      = lt_tab_zstock.

      CATCH cx_salv_msg.
        MESSAGE 'Erro ao fazer try!' TYPE 'E'.

    ENDTRY.

    CALL METHOD lr_alv->display.

ENDFORM.
