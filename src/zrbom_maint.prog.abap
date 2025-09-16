*&---------------------------------------------------------------------*
*& Report ZRBOM_MAINT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zrbom_maint.

INCLUDE zrbom_maint_top.

IF rb1 = 'X'.
  CALL SELECTION-SCREEN 100.

  DATA(lo_CAD_BOM) = NEW zcl_cad_bom( ).

  lo_CAD_BOM->validate_bom(
    EXPORTING
       iv_matnr = p_matnr
       iv_qtd_base = p_qtd_b
   ).


ELSE.

  CALL SELECTION-SCREEN 200.

  DATA(lo_CAD_ITENS) = NEW zcl_cad_itens( ).

  lo_CAD_ITENS->validate_matnr(
    iv_matnr_fim = p_matnrI
    iv_qtd_comp  = p_qtd_c
  ).

ENDIF.


START-OF-SELECTION.


*  DATA(lo_CAD_BOM)     = NEW zcl_cad_bom( ).
*  DATA(lo_CAD_ITENS)   = NEW zcl_cad_itens( ).
  DATA(lo_DISPLAY_ALV) = NEW zcl_display_alv( ).


  IF rb1 = 'X'.


******************************************************** CADASTRO DE BOM ******************************************

    lo_CAD_BOM->get_bom(
      CHANGING
        ev_bom_id   = lv_bom_id
    ).

    lo_CAD_BOM->set_bom(
      EXPORTING
        iv_matnr    = p_matnr
        iv_qtd_base = p_qtd_b
        iv_ativo    = p_ativo
        ev_bom_id   = lv_bom_id
*    IMPORTING
*      wa_zbom_h   =
    ).

  ELSE.

******************************************************** CADASTRO DE ITENS ******************************************

    lo_cad_itens->get_itens(
      CHANGING
        ev_pos        = lv_pos
    ).

    lo_cad_itens->set_itens(
      EXPORTING
        iv_bom_id     = p_bom_id
        ev_pos        = lv_pos
        iv_matnr_comp = p_matnri
        iv_qtd_comp   = p_qtd_c
        iv_unid       = p_unid
*    IMPORTING
*      wa_zbom_i     =
    ).

    lv_bom_id = p_bom_id.

  ENDIF.

******************************************************** RELATÓRIO ALV ******************************************

  lv_bom_id = |{ lv_bom_id ALPHA = IN }|.

  lo_DISPLAY_ALV->get_data(
  EXPORTING
    iv_table_name = 'ZBOM_H'
    iv_parameters = lv_bom_id
  IMPORTING
    et_itab       = gt_zbom_h
).

  lo_DISPLAY_ALV->get_data(
    EXPORTING
      iv_table_name = 'ZBOM_I'
      iv_parameters = lv_bom_id
    IMPORTING
      et_itab       = gt_zbom_i
  ).

  lo_DISPLAY_ALV->display_output(
    EXPORTING
      iv_container_name = 'CONTAINER1'
    CHANGING
      ct_itab           = gt_zbom_h
  ).

  lo_DISPLAY_ALV->display_output(
  EXPORTING
    iv_container_name = 'CONTAINER2'
  CHANGING
    ct_itab           = gt_zbom_i
).

  CALL SCREEN 300.

  INCLUDE zrbom_maint_status_0300.

  INCLUDE zrbom_maint_user_command_0300.
