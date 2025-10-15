*&---------------------------------------------------------------------*
*& Include          ZVND_I_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida_parameters
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_VBELN
*&      --> P_MATNR
*&      --> P_QTY
*&      --> P_DESC
*&---------------------------------------------------------------------*
FORM valida_parameters  USING i_p_vbeln TYPE vbeln
                              i_p_matnr TYPE ze_MATNR
                              i_p_qty   TYPE ze_QTY3
                              i_p_desc  TYPE ze_price.

  IF i_p_vbeln IS NOT INITIAL.

    SELECT SINGLE vbeln
      FROM zvnd_h
      INTO i_p_vbeln
      WHERE vbeln = i_p_vbeln.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'de VBELN'.
    ENDIF.
  ENDIF.

  IF i_p_matnr IS NOT INITIAL.

    SELECT SINGLE matnr
      FROM zprice
      INTO i_p_matnr
      WHERE matnr = i_p_matnr.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'de MATNR'.
    ENDIF.
  ENDIF.

  IF i_p_qty LE 0.
    MESSAGE e014(zpedro).
  ENDIF.

  IF i_p_desc LT 0.
    MESSAGE e015(zpedro).
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_date
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_DATA
*&---------------------------------------------------------------------*
FORM set_date  USING    p_gv_data TYPE dats.

  gv_data = sy-datum.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_VBELN
*&      --> P_MATNR
*&---------------------------------------------------------------------*
FORM get_data USING i_p_vbeln    TYPE vbeln
                    i_p_matnr    TYPE ze_MATNR

           CHANGING gwa_zprice   TYPE zprice.

* GET PRICE AND CURRENCY----------------------------------------------------------
  SELECT SINGLE price currency
    FROM zprice
    INTO CORRESPONDING FIELDS OF gwa_zprice
    WHERE matnr = i_p_matnr.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZPRICE'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_currency
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_VBELN
*&      --> P_MATNR
*&      <-- GWA_ZVND_I
*&---------------------------------------------------------------------*
FORM check_currency  USING    i_p_vbeln    TYPE vbeln
                              i_p_matnr    TYPE ze_MATNR

                     CHANGING gwa_zstock   TYPE zstock.

  SELECT SINGLE moeda
    FROM zvnd_h
    INTO @DATA(lv_curr)
    WHERE vbeln = @i_p_vbeln.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZVND_H'.

  ELSEIF gwa_zprice-currency NE lv_curr.
    MESSAGE e016(zpedro).
  ENDIF.

  SELECT SINGLE *
    FROM zstock
    INTO gwa_zstock
    WHERE matnr = i_p_matnr
    AND qty GE p_qty.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'de estoque'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_values
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_QTY
*&      --> P_DESC
*&      <-- GWA_ZVND_I
*&---------------------------------------------------------------------*
FORM get_values  USING    i_p_qty      TYPE ze_QTY3
                          i_p_desc     TYPE ze_price
                          p_gwa_zprice   TYPE zprice

                 CHANGING p_gwa_zvnd_i TYPE zvnd_i
                          p_gv_val_bruto TYPE ze_price
                          p_gv_val_desc  TYPE ze_price
                          p_gv_val_liq   TYPE ze_price.


  p_gv_val_bruto = i_p_qty * p_gwa_zprice-price.
  p_gv_val_desc  = i_p_qty * i_p_desc.
  p_gv_val_liq   = p_gv_val_bruto - p_gv_val_desc.

  IF p_gv_val_liq LE 0.
    MESSAGE e017(zpedro)
      WITH 'Valor liquido' 'se o Valor de desconto não é maior do que o valor do item.'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zstock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATNR
*&      --> GWA_ZSTOCK
*&---------------------------------------------------------------------*
FORM update_zstock  USING    i_p_matnr    TYPE ze_matnr
                             i_p_qty      TYPE ze_qty3
                             p_gwa_zstock TYPE zstock
                             gv_data      TYPE dats.

  DATA : lv_qty TYPE ze_qty3.

  lv_qty = p_gwa_zstock-qty - p_qty.

  IF lv_qty LT 0.
    MESSAGE e014(zpedro).
  ENDIF.

  UPDATE zstock
  SET qty = @lv_qty,
      dt_atualiz = @gv_data
  WHERE matnr = @p_matnr
  AND locid = @p_gwa_zstock-locid.

  IF sy-subrc NE 0.
    MESSAGE e003(zpedro)
      WITH 'ZSTOCK'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zmov
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_VBELN
*&      --> GV_POSNR
*&      --> P_QTY
*&      --> GV_DATA
*&---------------------------------------------------------------------*
FORM create_zmov  USING    i_p_vbeln  TYPE vbeln
                           p_gv_posnr TYPE posnr
                           i_p_qty    TYPE ze_qty3
                           p_gv_data  TYPE dats

                  CHANGING p_gwa_zmov TYPE zmov.

  SELECT MAX( idmov )
     FROM zmov
     INTO @DATA(lv_idmov).

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
    WITH 'IDMOV MAX'.
  ENDIF.

  lv_idmov = lv_idmov + 1.
  DATA(lv_hora) = sy-uzeit.
  DATA(lc_TPMOV) = 'SA'.
  DATA(lv_obs) = 'VBELN = ' && p_vbeln && 'POSNR = ' && gv_posnr.

  MOVE lv_idmov          TO p_gwa_zmov-idmov.
  MOVE p_MATNR           TO p_gwa_zmov-matnr.
  MOVE gwa_zstock-locid  TO p_gwa_zmov-locid.
  MOVE lc_TPMOV          TO p_gwa_zmov-tpmov.
  MOVE gv_data           TO p_gwa_zmov-data.
  MOVE lv_HORA           TO p_gwa_zmov-hora.
  MOVE lv_OBS            TO p_gwa_zmov-obs.
  MOVE p_qty             TO p_gwa_zmov-qty.

  p_gwa_zmov-idmov = |{ p_gwa_zmov-idmov ALPHA = IN }|.

  INSERT zmov FROM p_gwa_zmov.

  IF sy-subrc NE 0.
    MESSAGE e000(zpedro)
    WITH 'ZMOV'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_posnr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> GV_POSNR
*&---------------------------------------------------------------------*
FORM set_posnr CHANGING p_gv_posnr TYPE posnr.

  SELECT MAX( posnr )
    FROM zvnd_i
    INTO p_gv_posnr.

  p_gv_posnr = p_gv_posnr + 1.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_ZVND_I
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_VBELN
*&      --> GV_POSNR
*&      --> P_MATNR
*&      --> GWA_ZSTOCK
*&      --> P_QTY
*&      --> GWA_ZPRICE
*&      --> P_DESC
*&      <-- GWA_ZVND_I
*&----------------------------------------  -----------------------------*
FORM create_ZVND_I  USING    i_p_vbeln      TYPE vbeln
                             p_gv_posnr     TYPE posnr
                             i_p_matnr      TYPE ze_matnr
                             p_gwa_zstock   TYPE zstock
                             i_p_qty        TYPE ze_qty3
                             p_gwa_zprice   TYPE zprice
                             i_p_desc       TYPE ze_price
                             p_gv_val_bruto TYPE ze_price

                    CHANGING p_gwa_zvnd_i   TYPE zvnd_i.


  MOVE i_p_vbeln             TO p_gwa_zvnd_i-vbeln.
  MOVE p_gv_posnr            TO p_gwa_zvnd_i-posnr.
  MOVE i_p_matnr             TO p_gwa_zvnd_i-matnr.
  MOVE p_gwa_zstock-locid    TO p_gwa_zvnd_i-locid.
  MOVE i_p_qty               TO p_gwa_zvnd_i-qty.
  MOVE p_gwa_zprice-price    TO p_gwa_zvnd_i-price.
  MOVE p_gwa_zprice-currency TO p_gwa_zvnd_i-currency.
  MOVE p_gv_val_bruto        TO p_gwa_zvnd_i-val_item.
  MOVE i_p_desc              TO p_gwa_zvnd_i-desc_it.
  MOVE gv_val_liq            TO p_gwa_zvnd_i-val_liq_item.

  INSERT zvnd_i FROM p_gwa_zvnd_i.

  IF sy-subrc ne 0.
    MESSAGE e000(zpedro)
      WITH 'ZVND_I'.
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
     FROM zvnd_i
     INTO TABLE gt_ZVND_I
     WHERE vbeln = p_vbeln
     AND posnr = gv_posnr.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZVND_I'.
  ENDIF.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_ZVND_I.

      MESSAGE s018(zpedro)
        WITH gv_posnr p_vbeln.

    CATCH cx_salv_msg.
      MESSAGE e001(zpedro).

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
