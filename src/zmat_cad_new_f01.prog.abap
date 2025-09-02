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
FORM check_matnr CHANGING p_gv_matnr TYPE ze_matnr.

  SELECT SINGLE matnr
    FROM zmat
    INTO p_gv_matnr
    WHERE matnr = p_MATNR.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
     WITH 'ZMAT'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zmat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM update_zmat USING p_gv_matnr TYPE ze_matnr.

  IF p_gv_matnr IS NOT INITIAL.

    UPDATE zmat
      SET descr = @p_DESCR,
      unid = @p_UNID,
      ativo = @p_ATIVO
      WHERE matnr = @p_MATNR.

    IF sy-subrc NE 0.
      MESSAGE e003(zpedro)
      WITH 'ZMAT'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zmat
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- P_MATNR
*&---------------------------------------------------------------------*
FORM create_zmat USING p_gv_matnr TYPE ze_matnr.

  IF p_gv_matnr IS INITIAL.

    MOVE p_MATNR TO gs_itab_zmat-matnr.
    MOVE p_DESCR TO gs_itab_zmat-descr.
    MOVE p_UNID  TO gs_itab_zmat-unid.
    MOVE p_ATIVO TO gs_itab_zmat-ativo.

    INSERT zmat FROM gs_itab_zmat.

    IF sy-subrc NE 0.
      MESSAGE e000(zpedro)
      WITH 'ZMAT'.
    ENDIF.

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
      INTO TABLE gt_tab_zmat
      WHERE matnr = gs_itab_zmat-matnr.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
      WITH 'ZMAT'.
  ENDIF.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_tab_zmat.

    CATCH cx_salv_msg.
      MESSAGE e001(zpedro).

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
