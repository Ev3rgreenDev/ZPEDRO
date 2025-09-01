*&---------------------------------------------------------------------*
*& Include          ZMAT_CAD_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form verify_unid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_UNID
*&---------------------------------------------------------------------*
FORM verify_unid CHANGING i_p_unid TYPE ze_UNID.

  SELECT SINGLE msehi
    FROM t006
    INTO i_p_unid
    WHERE msehi = p_UNID.

  IF sy-subrc NE 0.
    MESSAGE 'Unidade de medida inexistente, favor inserir uma unidade existente.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_matnr
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATNR
*&---------------------------------------------------------------------*
FORM check_matnr CHANGING lv_matnr TYPE ze_matnr.

  SELECT SINGLE matnr
    FROM zmat
    INTO lv_matnr
    WHERE matnr = p_MATNR.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zmat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_zmat USING lv_matnr TYPE ze_matnr.

  IF lv_matnr IS NOT INITIAL.

    UPDATE zmat
      SET descr = p_DESCR
      WHERE matnr = p_MATNR.

    UPDATE zmat
    SET unid = p_UNID
    WHERE matnr = p_MATNR.

    UPDATE zmat
    SET ativo = p_ATIVO
    WHERE matnr = p_MATNR.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zmat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- P_MATNR
*&---------------------------------------------------------------------*
FORM create_zmat USING lv_matnr TYPE ze_matnr.

  IF lv_matnr IS INITIAL.

    MOVE p_MATNR TO ls_itab_zmat-matnr.
    MOVE p_DESCR TO ls_itab_zmat-descr.
    MOVE p_UNID  TO ls_itab_zmat-unid.
    MOVE p_ATIVO TO ls_itab_zmat-ativo.

    ls_itab_zmat-matnr = CONV char18( |{ ls_itab_zmat-matnr ALPHA = IN }| ).

    INSERT zmat FROM ls_itab_zmat.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form alv_event
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> P_MATNR
*&---------------------------------------------------------------------*
FORM alv_event.

  SELECT *
      FROM zmat
      INTO TABLE lt_tab_zmat
      WHERE matnr = ls_itab_zmat-matnr.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = lr_alv
        CHANGING
          t_table      = lt_tab_zmat.

    CATCH cx_salv_msg.

  ENDTRY.

  CALL METHOD lr_alv->display.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form check_f_positive
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM check_f_positive .

  IF p_MATNR IS INITIAL AND p_MATNR IS NOT INITIAL.
    MESSAGE 'Algo deu errado!' TYPE 'E'.
  ENDIF.

ENDFORM.
