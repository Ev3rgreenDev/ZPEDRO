*&---------------------------------------------------------------------*
*& Include          ZSTK_REPOR_NEW_F01
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Form set_campos
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_CAMPOS
*&---------------------------------------------------------------------*
FORM set_campos  CHANGING p_lv_campos TYPE string.

  lv_campos = 'QTY LE p_QTY_M'.

  IF p_MATNR IS NOT INITIAL.

    CONCATENATE lv_campos ' AND MATNR = p_MATNR' INTO lv_campos RESPECTING BLANKS.

  ENDIF.

  IF p_LOCID IS NOT INITIAL AND lv_campos IS INITIAL.

    CONCATENATE lv_campos ' AND LOCID = p_LOCID' INTO lv_campos RESPECTING BLANKS.

  ELSEIF p_LOCID IS NOT INITIAL AND lv_campos IS NOT INITIAL.

    CONCATENATE lv_campos ' AND LOCID = p_LOCID'  INTO lv_campos RESPECTING BLANKS.

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
  INTO TABLE lt_tab_zstock
  WHERE (lv_campos).

ENDFORM.
*&---------------------------------------------------------------------*
*& Form set_zstock
*&---------------------------------------------------------------------*
*& text
*&---------------------------------------------------------------------*
*&      <-- LV_QTY_SUG
*&      <-- LS_ITAB_ZSTOCK_AUX
*&---------------------------------------------------------------------*
FORM set_zstock  CHANGING p_lv_qty_sug TYPE ze_qty3
                          p_ls_itab_zstock_aux TYPE zstock_aux.

  LOOP AT lt_tab_zstock INTO ls_itab_zstock_aux.

    lv_qty_sug = p_QTY_A - ls_itab_zstock_aux-qty.

    MOVE lv_qty_sug TO ls_itab_zstock_aux-qty_sug.

    APPEND ls_itab_zstock_aux TO lt_tab_zstock_aux.

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
          r_salv_table = lr_alv
        CHANGING
          t_table      = lt_tab_zstock_aux.

    CATCH cx_salv_msg.

  ENDTRY.

  CALL METHOD lr_alv->display.

  CLEAR lt_tab_zstock_aux.

ENDFORM.
