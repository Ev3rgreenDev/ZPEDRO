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
FORM check_locid  CHANGING lv_locid TYPE ze_locid.

  SELECT SINGLE locid
    FROM zloc
    INTO lv_locid
    WHERE locid = p_LOCID.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form update_zloc
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      --> LV_LOCID
*&---------------------------------------------------------------------*
FORM update_zloc  USING lv_locid TYPE ze_locid.

  IF lv_locid IS NOT INITIAL.

    UPDATE zloc
     SET descr = @p_DESCR,
     ativo = @p_ATIVO
     WHERE locid = @p_LOCID.

    IF sy-subrc NE 0.
     MESSAGE 'Erro ao fazer update!' TYPE 'E'.
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
FORM create_zloc  USING lv_locid TYPE ze_locid.

  IF lv_locid IS INITIAL.

    MOVE p_LOCID TO ls_itab_zloc-locid.
    MOVE p_DESCR TO ls_itab_zloc-descr.
    MOVE p_ATIVO TO ls_itab_zloc-ativo.

    ls_itab_zloc-locid = |{ ls_itab_zloc-locid ALPHA = IN }|.

    INSERT zloc FROM ls_itab_zloc.

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
FORM alv_event .

  SELECT *
  FROM zloc
  INTO TABLE lt_tab_ZLOC
  WHERE locid = p_LOCID.

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
          t_table      = lt_tab_zloc.

    CATCH cx_salv_msg.
     MESSAGE 'Erro ao fazer try!' TYPE 'E'.

  ENDTRY.

  CALL METHOD lr_alv->display.

ENDFORM.
