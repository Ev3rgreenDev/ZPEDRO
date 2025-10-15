*&---------------------------------------------------------------------*
*& Include          ZLOC_CAD_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form check_locid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_LOCID
*&---------------------------------------------------------------------*
FORM check_locid  CHANGING p_gv_locid TYPE ze_locid.

  SELECT SINGLE locid
    FROM zloc
    INTO p_gv_locid
    WHERE locid = p_LOCID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zloc
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_LOCID
*&---------------------------------------------------------------------*
FORM update_zloc  USING p_gv_locid TYPE ze_locid.

  IF p_gv_locid IS NOT INITIAL.

    UPDATE zloc
     SET descr = @p_DESCR,
     ativo = @p_ATIVO
     WHERE locid = @p_LOCID.

    IF sy-subrc NE 0.
      MESSAGE e003(zpedro)
       WITH 'ZLOC'.
    ENDIF.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form create_zloc
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_LOCID
*&---------------------------------------------------------------------*
FORM create_zloc  USING p_gv_locid TYPE ze_locid.

  IF p_gv_locid IS INITIAL.

    MOVE p_LOCID TO gs_itab_zloc-locid.
    MOVE p_DESCR TO gs_itab_zloc-descr.
    MOVE p_ATIVO TO gs_itab_zloc-ativo.

    gs_itab_zloc-locid = |{ gs_itab_zloc-locid ALPHA = IN }|.

    INSERT zloc FROM gs_itab_zloc.

    IF sy-subrc NE 0.
      MESSAGE e000(zpedro)
       WITH 'ZLOC'.
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
FORM alv_event .

  SELECT *
  FROM zloc
  INTO TABLE gt_tab_ZLOC
  WHERE locid = p_LOCID.

  IF sy-subrc NE 0.
    MESSAGE e002(zpedro)
     WITH 'ZLOC'.
  ENDIF.

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_tab_zloc.

    CATCH cx_salv_msg.
      MESSAGE e001(zpedro).

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
