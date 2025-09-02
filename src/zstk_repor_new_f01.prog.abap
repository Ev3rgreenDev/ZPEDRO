*&---------------------------------------------------------------------*
*& Include          ZSTK_REPOR_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_campos
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- p_gv_campos
*&---------------------------------------------------------------------*
FORM set_campos  CHANGING p_gv_campos TYPE string.

  p_gv_campos = 'QTY LE p_QTY_M'.

  IF p_MATNR IS NOT INITIAL.

    CONCATENATE p_gv_campos ' AND MATNR = p_MATNR' INTO p_gv_campos RESPECTING BLANKS.

  ENDIF.

  IF p_LOCID IS NOT INITIAL AND p_gv_campos IS INITIAL.

    CONCATENATE p_gv_campos ' AND LOCID = p_LOCID' INTO p_gv_campos RESPECTING BLANKS.

  ELSEIF p_LOCID IS NOT INITIAL AND p_gv_campos IS NOT INITIAL.

    CONCATENATE p_gv_campos ' AND LOCID = p_LOCID'  INTO p_gv_campos RESPECTING BLANKS.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form get_zstock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LT_TAB_ZSTOCK
*&---------------------------------------------------------------------*
FORM get_zstock.

  SELECT *
  FROM zstock
  INTO TABLE gt_tab_zstock
  WHERE (gv_campos).

  IF sy-subrc NE 0.
    MESSAGE 'Erro ao fazer select!' TYPE 'E'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_zstock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_SUG
*&      <-- LS_ITAB_ZSTOCK_AUX
*&---------------------------------------------------------------------*
FORM set_zstock  CHANGING p_gv_qty_sug         TYPE ze_qty3
                          p_gs_itab_zstock_aux TYPE zstock_aux.

  LOOP AT gt_tab_zstock INTO p_gs_itab_zstock_aux.

    p_gv_qty_sug = p_QTY_A - p_gs_itab_zstock_aux-qty.

    MOVE p_gv_qty_sug TO p_gs_itab_zstock_aux-qty_sug.

    APPEND p_gs_itab_zstock_aux TO gt_tab_zstock_aux.

  ENDLOOP.

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

  TRY.
      CALL METHOD cl_salv_table=>factory
        EXPORTING
          list_display = if_salv_c_bool_sap=>false
        IMPORTING
          r_salv_table = gr_alv
        CHANGING
          t_table      = gt_tab_zstock_aux.

    CATCH cx_salv_msg.
      MESSAGE 'Erro ao fazer try!' TYPE 'E'.

  ENDTRY.

  CALL METHOD gr_alv->display.

ENDFORM.
