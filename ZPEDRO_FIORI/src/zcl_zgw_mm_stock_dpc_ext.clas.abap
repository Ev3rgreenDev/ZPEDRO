class ZCL_ZGW_MM_STOCK_DPC_EXT definition
  public
  inheriting from ZCL_ZGW_MM_STOCK_DPC
  create public .

public section.
protected section.

  methods MATCADSET_CREATE_ENTITY
    redefinition .
  methods MATCADSET_DELETE_ENTITY
    redefinition .
  methods MATCADSET_GET_ENTITYSET
    redefinition .
  methods MATCADSET_UPDATE_ENTITY
    redefinition .
  methods MATCADSET_GET_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGW_MM_STOCK_DPC_EXT IMPLEMENTATION.


  METHOD matcadset_create_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: ls_zmat    TYPE zmat.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_zmat
    ).

    DATA(lo_stock) = NEW zcl_stock( ).

    er_entity = lo_stock->create_material(
                  EXPORTING
                    iv_matnr   = ls_zmat-matnr
                    iv_descr   = ls_zmat-descr
                    iv_unid    = ls_zmat-unid
                    iv_ativo   = ls_zmat-ativo
                  IMPORTING
                    et_message = lt_message
                ).

    IF lt_message IS NOT INITIAL.

      DATA: lo_msg     TYPE REF TO /iwbep/if_message_container.

      me->/iwbep/if_mgw_conv_srv_runtime~get_message_container(
       RECEIVING
         ro_message_container = lo_msg
      ).

      zcl_message_builder=>exception_message(
        it_message = lt_message
        io_msg     = lo_msg
      ).
    ENDIF.

  ENDMETHOD.


  METHOD matcadset_delete_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: lv_matnr TYPE ze_matnr.

    lv_matnr = it_key_tab[ name = 'Matnr' ]-value.

    DATA(lo_stock) = NEW zcl_stock( ).

    lt_message = lo_stock->delete_material( iv_matnr = lv_matnr ).

    IF lt_message IS NOT INITIAL.

      DATA: lo_msg     TYPE REF TO /iwbep/if_message_container.

      me->/iwbep/if_mgw_conv_srv_runtime~get_message_container(
       RECEIVING
         ro_message_container = lo_msg
      ).

      zcl_message_builder=>exception_message(
        it_message = lt_message
        io_msg     = lo_msg
      ).

    ENDIF.

  ENDMETHOD.


  METHOD matcadset_get_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: lv_matnr TYPE ze_matnr.

    lv_matnr = it_key_tab[ name = 'Matnr' ]-value.

    DATA(lo_stock) = NEW zcl_stock( ).

    er_entity = lo_stock->get_single_material(
                  EXPORTING
                    iv_matnr   = lv_matnr
                  CHANGING
                    ct_message = lt_message
                ).

    IF lt_message IS NOT INITIAL.

      DATA: lo_msg TYPE REF TO /iwbep/if_message_container.

      me->/iwbep/if_mgw_conv_srv_runtime~get_message_container(
       RECEIVING
         ro_message_container = lo_msg
      ).

      zcl_message_builder=>exception_message(
        it_message = lt_message
        io_msg     = lo_msg
      ).
    ENDIF.

  ENDMETHOD.


  METHOD matcadset_get_entityset.

    DATA(lo_stock) = NEW zcl_stock( ).

    et_entityset = lo_stock->get_material( iv_fields = iv_filter_string ).

  ENDMETHOD.


  METHOD matcadset_update_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: ls_zmat    TYPE zmat.

    io_data_provider->read_entry_data(
      IMPORTING
        es_data = ls_zmat
    ).

    ls_zmat-matnr = it_key_tab[ name = 'Matnr' ]-value.

    DATA(lo_stock) = NEW zcl_stock( ).

    er_entity = lo_stock->update_material(
                  EXPORTING
                    is_fields  = ls_zmat
                  IMPORTING
                    et_message = lt_message
                ).

    IF lt_message IS NOT INITIAL.

      DATA: lo_msg TYPE REF TO /iwbep/if_message_container.

      me->/iwbep/if_mgw_conv_srv_runtime~get_message_container(
       RECEIVING
         ro_message_container = lo_msg
      ).

      zcl_message_builder=>exception_message(
        it_message = lt_message
        io_msg     = lo_msg
      ).
    ENDIF.
  ENDMETHOD.
ENDCLASS.
