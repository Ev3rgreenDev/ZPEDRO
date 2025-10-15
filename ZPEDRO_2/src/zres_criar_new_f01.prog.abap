*&---------------------------------------------------------------------*
*& Include          ZRES_CRIAR_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form valida_matnr_locid
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM valida_matnr_locid .

  SELECT SINGLE matnr
    FROM zstock
    INTO p_MATNR
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.

  IF sy-subrc NE 0.
    MESSAGE 'Material e/ou local inválido.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form valida_qty
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*& -->  p1        text
*& <--  p2        text
*&---------------------------------------------------------------------*
FORM valida_qty .

  SELECT SINGLE *
   FROM zstock
   INTO @DATA(ls_itab_zres_c)
   WHERE matnr = @p_MATNR
   AND qty GE @p_QTY.

  IF sy-subrc NE 0.
    MESSAGE 'Valor a ser reservado é maior do que o valor em estoque.' TYPE 'E'.
  ENDIF.

  SELECT SINGLE qty_res
    FROM zres
    INTO gv_qty_res
    WHERE matnr = p_MATNR
    AND locid = p_LOCID.

  IF sy-subrc = 0.
    IF p_QTY + gv_qty_res GT ls_itab_zres_c-qty.
      MESSAGE 'Valor a ser reservado é maior do que o valor em estoque.' TYPE 'E'.
    ENDIF.
  ELSE.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
  ENDIF.


  IF p_QTY LE 0.
    MESSAGE 'Quantidade precisa ser maior do que 0.' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_data
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_DATA
*&---------------------------------------------------------------------*
FORM set_data  CHANGING i_gv_data TYPE dats.

  i_gv_data = sy-datum.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form mov
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_IDRES
*&      <-- LV_STATUS
*&      <-- LS_ITAB_ZRES
*&---------------------------------------------------------------------*
FORM mov CHANGING i_gv_idres     TYPE ze_guid32
                  p_gs_itab_zres TYPE zres.

  SELECT MAX( idres )
    FROM zres
    INTO i_gv_IDRES.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
  ENDIF.

  i_gv_IDRES = i_gv_IDRES + 1.

  MOVE i_gv_IDRES TO p_gs_itab_zres-idres.
  MOVE p_MATNR    TO p_gs_itab_zres-matnr.
  MOVE p_LOCID    TO p_gs_itab_zres-locid.
  MOVE p_QTY      TO p_gs_itab_zres-qty_res.
  MOVE gv_data    TO p_gs_itab_zres-data.
  MOVE gc_status  TO p_gs_itab_zres-status.

  p_gs_itab_zres-idres = |{ p_gs_itab_zres-idres ALPHA = IN }|.
  p_gs_itab_zres-locid = |{ p_gs_itab_zres-locid ALPHA = IN }|.

  INSERT zres FROM p_gs_itab_zres.

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer insert!' TYPE 'E'.
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
  FROM zres
  INTO TABLE gt_tab_zres
  WHERE idres = gs_itab_zres-idres.

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
          t_table      = gt_tab_zres.

    CATCH cx_salv_msg.
      MESSAGE 'Erro ao fazer try!' TYPE 'E'.

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
