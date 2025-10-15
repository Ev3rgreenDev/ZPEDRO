class ZCL_ZGW_PP_MAINT_01_DPC_EXT definition
  public
  inheriting from ZCL_ZGW_PP_MAINT_01_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods BOMITEMSMAINTENA_CREATE_ENTITY
    redefinition .
  methods BOMITEMSMAINTENA_DELETE_ENTITY
    redefinition .
  methods BOMITEMSMAINTENA_GET_ENTITY
    redefinition .
  methods BOMITEMSMAINTENA_GET_ENTITYSET
    redefinition .
  methods BOMITEMSMAINTENA_UPDATE_ENTITY
    redefinition .
  methods BOMMAINTANCESET_CREATE_ENTITY
    redefinition .
  methods BOMMAINTANCESET_DELETE_ENTITY
    redefinition .
  methods BOMMAINTANCESET_GET_ENTITY
    redefinition .
  methods BOMMAINTANCESET_GET_ENTITYSET
    redefinition .
  methods BOMMAINTANCESET_UPDATE_ENTITY
    redefinition .
private section.

  methods EXCEPTION_MESSAGE_LOCAL
    importing
      !IT_MESSAGE type ZTT_MESSAGE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
ENDCLASS.



CLASS ZCL_ZGW_PP_MAINT_01_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

    DATA: lt_itens TYPE zttt_zbom_i.

    DATA: ls_bom   TYPE zbom_h.

    DATA: BEGIN OF ls_de_bom.
            INCLUDE TYPE zcl_zgw_pp_maint_01_mpc=>ts_bommaintance.
    DATA to_items TYPE zcl_zgw_pp_maint_01_mpc=>tt_bomitemsmaintenance.
    DATA: END OF ls_de_bom.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_de_bom
    ).

    MOVE-CORRESPONDING ls_de_bom          TO ls_bom.
    MOVE-CORRESPONDING ls_de_bom-to_items TO lt_itens.

    DATA(lo_cad_bom) = NEW zcl_cad_bom( ).

    lo_cad_bom->create_deep_entity(
      CHANGING
        cs_bom   = ls_bom
        ct_itens = lt_itens
    ).

    MOVE-CORRESPONDING ls_bom   TO ls_de_bom.
    MOVE-CORRESPONDING lt_itens TO ls_de_bom-to_items.

    copy_data_to_ref(
      EXPORTING
        is_data = ls_de_bom
      CHANGING
        cr_data = er_deep_entity
    ).

  ENDMETHOD.


  METHOD bomitemsmaintena_create_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: ls_items TYPE zbom_i.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_items
    ).

    DATA(lo_cad_itens) = NEW zcl_cad_itens( ).

    lt_message = lo_cad_itens->set_items(
                   EXPORTING
                     iv_bom_id     = ls_items-bom_id
                     iv_qtd_comp   = ls_items-qtd_comp
                     iv_unid       = ls_items-unid
                   IMPORTING
                     es_zbom_i     = er_entity
                 ).

    IF lt_message IS NOT INITIAL.
      me->exception_message_local( it_message = lt_message ).
    ENDIF.

  ENDMETHOD.


  METHOD bomitemsmaintena_delete_entity.

    DATA: lt_itens   TYPE zbom_i,
          lt_message TYPE ztt_message.

    lt_itens-bom_id = it_key_tab[ name = 'BomId' ]-value.
    lt_itens-pos    = it_key_tab[ name = 'Pos' ]-value.

    DATA(lo_cad_itens) = NEW zcl_cad_itens( ).

    lt_message = lo_cad_itens->delete_itens(
                   iv_bom_id = lt_itens-bom_id
                   iv_pos    = lt_itens-pos
                 ).

    IF lt_message is NOT INITIAL.
      me->exception_message_local( it_message = lt_message ).
    ENDIF.

  endmethod.


  METHOD bomitemsmaintena_get_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: ls_itens   TYPE zbom_i.

    ls_itens-bom_id = it_key_tab[ name = 'BomId' ]-value.
    ls_itens-pos    = it_key_tab[ name = 'Pos' ]-value.

    DATA(lo_cad_itens) = NEW zcl_cad_itens( ).

    er_entity = lo_cad_itens->get_itens_single(
                  EXPORTING
                    iv_bom_id  = ls_itens-bom_id
                    iv_pos     = ls_itens-pos
                  IMPORTING
                    et_message = lt_message
                ).

    IF lt_message IS NOT INITIAL.
      me->exception_message_local( it_message = lt_message ).
    ENDIF.

  ENDMETHOD.


  METHOD bomitemsmaintena_get_entityset.

    DATA(lo_cad_itens) = NEW zcl_cad_itens( ).

    ET_ENTITYSET = lo_cad_itens->get_itens_with_string( iv_fields = IV_FILTER_STRING ).

  ENDMETHOD.


  METHOD bomitemsmaintena_update_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: ls_itens TYPE zst_zbom_i.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_itens
    ).

    ls_itens-bom_id = it_key_tab[ name = 'BomId' ]-value.
    ls_itens-pos    = it_key_tab[ name = 'Pos' ]-value.

    DATA(lo_cad_itens) = NEW zcl_cad_itens( ).

    lo_cad_itens->update_itens(
      EXPORTING
        iv_bom_id   = ls_itens-bom_id
        iv_pos      = ls_itens-pos
        iv_qtd_comp = ls_itens-qtd_comp
        iv_unid     = ls_itens-unid
        is_fields   = ls_itens
      RECEIVING
        rt_message  = lt_message
    ).

    IF lt_message IS NOT INITIAL.
      me->exception_message_local( it_message = lt_message ).
    ENDIF.

  ENDMETHOD.


  METHOD bommaintanceset_create_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: ls_bom     TYPE zbom_h.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_bom
    ).

    DATA(lo_CAD_BOM) = NEW zcl_cad_bom( ).

    lt_message = lo_cad_bom->validate_data(
        iv_matnr    = ls_bom-matnr_fim
        iv_qtd_base = ls_bom-qtd_base
    ).

    IF lt_message IS INITIAL.

      lo_CAD_BOM->set_bom(
      EXPORTING
        iv_matnr    = ls_bom-matnr_fim
        iv_qtd_base = ls_bom-qtd_base
        iv_ativo    = ls_bom-ativo
      IMPORTING
        es_wabom    = er_entity
    ).

    ELSE.

      me->exception_message_local( it_message = lt_message ).

    ENDIF.

  ENDMETHOD.


  METHOD bommaintanceset_delete_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: lv_bom_id  TYPE ze_bom_id.

    lv_bom_id = it_key_tab[ name = 'BomId' ]-value.

    DATA(lo_cad_bom) = NEW zcl_cad_bom( ).

    lo_CAD_BOM->delete_bom(
      EXPORTING
        iv_bom_id  = lv_bom_id
      RECEIVING
        rt_message = lt_message
    ).

    IF lt_message IS NOT INITIAL.
      me->exception_message_local( it_message = lt_message ).
    ENDIF.

  ENDMETHOD.


  METHOD bommaintanceset_get_entity.

    DATA: ls_zbom_h  TYPE zbom_h,
          lt_message TYPE ztt_message.

    ls_zbom_h-bom_id = it_key_tab[ name = 'BomId' ]-value.

    DATA(lo_cad_bom) =  NEW zcl_cad_bom( ).

    ls_zbom_h = lo_cad_bom->get_bom_single(
                   EXPORTING
                     iv_bom_id  = ls_zbom_h-bom_id
                   IMPORTING
                     et_message = lt_message
                 ).

    IF lt_message IS NOT INITIAL.
      me->exception_message_local( it_message = lt_message ).
    ENDIF.

    MOVE-CORRESPONDING ls_zbom_h TO er_entity.

  ENDMETHOD.


  METHOD bommaintanceset_get_entityset.

    DATA: lt_bom_id    TYPE /iwbep/t_cod_select_options,
          lt_matnr_fim TYPE /iwbep/t_cod_select_options,
          lt_qtd_base  TYPE /iwbep/t_cod_select_options,
          lt_ativo     TYPE /iwbep/t_cod_select_options,
          lt_zbom_h    TYPE TABLE OF zbom_h.


    DATA(lo_cad_bom) =  NEW zcl_cad_bom( ).

*    TRY.
*        lt_bom_id = it_filter_select_options[ property = 'BomId' ]-select_options.
*      CATCH cx_root.
*    ENDTRY.
*
*    TRY.
*        lt_matnr_fim = it_filter_select_options[ property = 'MatnrFim' ]-select_options.
*      CATCH cx_root.
*    ENDTRY.
*
*    TRY.
*        lt_qtd_base = it_filter_select_options[ property = 'QtdBase' ]-select_options.
*      CATCH cx_root.
*    ENDTRY.
*
*    TRY.
*        lt_ativo = it_filter_select_options[ property = 'Ativo' ]-select_options.
*      CATCH cx_root.
*    ENDTRY.
*
*    lt_zbom_h = lo_cad_bom->get_bom(
*      it_bom_id    = lt_bom_id
*      it_matnr_fim = lt_matnr_fim
*      it_qtd_base  = lt_qtd_base
*      it_ativo     = lt_ativo
*    ).

DATA(lv_string) = iv_filter_string.

    lt_zbom_h = lo_cad_bom->get_bom_with_string( iv_fields = iv_filter_string ).

    MOVE-CORRESPONDING lt_zbom_h TO et_entityset.

  ENDMETHOD.


  METHOD bommaintanceset_update_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: ls_bom     TYPE zbom_h.

    DATA: lv_bom_id  TYPE ze_bom_id.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_bom
    ).

    lv_bom_id = it_key_tab[ name = 'BomId' ]-value.

    DATA(lo_cad_bom) = NEW zcl_cad_bom( ).

    lo_CAD_BOM->update_bom(
    EXPORTING
      iv_bom_id   = lv_bom_id
      iv_matnr    = ls_bom-matnr_fim
      iv_qtd_base = ls_bom-qtd_base
      iv_ativo    = ls_bom-ativo
    RECEIVING
      rt_message = lt_message
    ).

    IF lt_message IS NOT INITIAL.
      me->exception_message_local( it_message = lt_message ).
    ENDIF.

  ENDMETHOD.


  METHOD exception_message_local.

    DATA: lo_msg     TYPE REF TO /iwbep/if_message_container.

    DATA: ls_message TYPE zst_message.

    me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( RECEIVING ro_message_container = lo_msg ).

    LOOP AT it_message INTO ls_message.

      lo_msg->add_message(
        EXPORTING
          iv_msg_type   = /iwbep/cl_cos_logger=>error
          iv_msg_id     = ls_message-message_id
          iv_msg_number = ls_message-message_number
          iv_msg_text   = ls_message-text
          iv_msg_v1     = ls_message-msgv1
          iv_msg_v2     = ls_message-msgv2
          iv_msg_v3     = ls_message-msgv3
          iv_msg_v4     = ls_message-msgv4
      ).

    ENDLOOP.

    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        message_container = lo_msg
        http_status_code  = 400.

  ENDMETHOD.
ENDCLASS.
