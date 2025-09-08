*&---------------------------------------------------------------------*
*& Include          ZPRICE_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida_parameters
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATNR
*&      --> P_VLD_FR
*&      --> P_VLD_TO
*&      --> P_PRICE
*&      --> P_WAERS
*&      --> P_ATIVO
*&---------------------------------------------------------------------*
FORM valida_parameters  USING    i_p_matnr  TYPE ze_matnr
                                 i_p_vld_fr TYPE dats
                                 i_p_vld_to TYPE dats
                                 i_p_price  TYPE ze_PRICE
                                 i_p_waers  TYPE tcurc-waers.

  SELECT SINGLE matnr
    FROM zstock
    INTO i_p_matnr
    WHERE matnr = p_matnr.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'de materiais'.
  ENDIF.

  IF i_p_vld_fr GE i_p_vld_to.
    MESSAGE e008(zpedro).
  ENDIF.

  IF i_p_price LE 0.
    MESSAGE e009(zpedro).
  ENDIF.

  IF i_p_waers IS NOT INITIAL.

    SELECT SINGLE waers
      FROM tcurc
      INTO p_waers
      WHERE waers = p_waers.

    IF sy-subrc NE 0.
      MESSAGE e010(zpedro).
    ENDIF.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_zprice
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATNR
*&      <-- GV_MATNR
*&---------------------------------------------------------------------*
FORM check_zprice  USING    i_p_matnr  TYPE ze_matnr
                   CHANGING e_gv_matnr TYPE ze_matnr.

  SELECT SINGLE matnr
    FROM zprice
    INTO e_gv_matnr
    WHERE matnr = i_p_matnr.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_price
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATNR
*&      --> P_VLD_FR
*&      --> P_VLD_TO
*&      --> P_PRICE
*&      --> P_WAERS
*&      --> P_ATIVO
*&---------------------------------------------------------------------*
FORM update_price  USING    i_p_matnr  TYPE ze_matnr
                            i_p_vld_fr TYPE dats
                            i_p_vld_to TYPE dats
                            i_p_price  TYPE ze_PRICE
                            i_p_waers  TYPE tcurc-waers
                            i_p_ativo  TYPE ze_FLAG
                            i_gv_matnr TYPE ze_matnr.

  IF i_gv_matnr IS NOT INITIAL.

    UPDATE zprice
    SET matnr      = @i_p_matnr,
        valid_from = @i_p_vld_fr,
        valid_to   = @i_p_vld_to,
        price      = @i_p_price,
        currency   = @i_p_waers,
        ativo      = @i_p_ativo
    WHERE matnr    = @i_p_matnr.

    IF sy-subrc NE 0.
      MESSAGE e003(zpedro)
        WITH 'ZPRICE'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_price
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATNR
*&      --> P_VLD_FR
*&      --> P_VLD_TO
*&      --> P_PRICE
*&      --> P_WAERS
*&      --> P_ATIVO
*&---------------------------------------------------------------------*
FORM create_price  USING    i_p_matnr  TYPE ze_matnr
                            i_p_vld_fr TYPE dats
                            i_p_vld_to TYPE dats
                            i_p_price  TYPE ze_PRICE
                            i_p_waers  TYPE tcurc-waers
                            i_p_ativo  TYPE ze_FLAG
                            i_gv_matnr TYPE ze_matnr

                   CHANGING p_gwa_zprice TYPE zprice.

  IF i_gv_matnr IS INITIAL.

    MOVE i_p_matnr  TO p_gwa_zprice-matnr.
    MOVE i_p_vld_fr TO p_gwa_zprice-valid_from.
    MOVE i_p_vld_to TO p_gwa_zprice-valid_to.
    MOVE i_p_price  TO p_gwa_zprice-price.
    MOVE i_p_waers  TO p_gwa_zprice-currency.
    MOVE i_p_ativo  TO p_gwa_zprice-ativo.

    INSERT zprice FROM p_gwa_zprice.

    IF sy-subrc NE 0.
      MESSAGE e001(zpedro)
        WITH 'ZPRICE'.
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
     FROM zprice
     INTO TABLE gt_zprice
     WHERE matnr = p_MATNR.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZPRICE'.
  ENDIF.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_zprice.

      IF gv_matnr IS INITIAL.
        MESSAGE s011(zpedro).
      ELSEIF gv_matnr IS NOT INITIAL.
        MESSAGE s012(zpedro).
      ENDIF.


    CATCH cx_salv_msg.
      MESSAGE e001(zpedro).

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
