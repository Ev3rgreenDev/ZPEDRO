class ZCL_ZGW_SO_ORDER_DPC_EXT definition
  public
  inheriting from ZCL_ZGW_SO_ORDER_DPC
  create public .

public section.

  methods /IWBEP/IF_MGW_APPL_SRV_RUNTIME~CREATE_DEEP_ENTITY
    redefinition .
protected section.

  methods SALESORDERSET_GET_ENTITY
    redefinition .
  methods SALESORDERSET_GET_ENTITYSET
    redefinition .
private section.

  methods EXCEPTION_MESSAGE_LOCAL
    importing
      !IT_MESSAGE type ZTT_MESSAGE
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
ENDCLASS.



CLASS ZCL_ZGW_SO_ORDER_DPC_EXT IMPLEMENTATION.


  METHOD /iwbep/if_mgw_appl_srv_runtime~create_deep_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: lo_msg TYPE REF TO /iwbep/if_message_container.

    DATA(lo_sales_order) = NEW zcl_sales_order( ).

    me->/iwbep/if_mgw_conv_srv_runtime~get_message_container(
           RECEIVING
             ro_message_container = lo_msg
          ).

    CASE iv_entity_set_name.
      WHEN 'SalesOrderHeaderSet'.

        DATA: ls_header TYPE zvnd_h.

        DATA BEGIN OF ls_de_header.
        INCLUDE       TYPE zcl_zgw_so_order_mpc=>ts_salesorderheader.
        DATA to_items TYPE zcl_zgw_so_order_mpc=>tt_salesorderitems.
        DATA to_cust  TYPE zcl_zgw_so_order_mpc=>tt_salesordercustomer.
        DATA END OF ls_de_header.

        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_de_header
        ).

        MOVE-CORRESPONDING ls_de_header TO ls_header.

        lt_message = lo_sales_order->create_deep_entity_header(
                       CHANGING
                         cs_header = ls_header
                         ct_items  = ls_de_header-to_items
                         ct_cust   = ls_de_header-to_cust
                     ).

        IF lt_message IS NOT INITIAL.

          zcl_message_builder=>exception_message(
            it_message = lt_message
            io_msg     = lo_msg
          ).

        ELSE.

          MOVE-CORRESPONDING ls_header TO ls_de_header.

          copy_data_to_ref(
            EXPORTING
              is_data = ls_de_header
            CHANGING
              cr_data = er_deep_entity
          ).

        ENDIF.

      WHEN 'SalesOrderItemsSet'.

        DATA: ls_items TYPE zvnd_i.

        DATA BEGIN OF ls_de_items.
        INCLUDE          TYPE zcl_zgw_so_order_mpc=>ts_salesorderitems.
        DATA to_header   TYPE zcl_zgw_so_order_mpc=>ts_salesorderheader.
        DATA to_material TYPE zcl_zgw_so_order_mpc=>ts_salesordermaterial.
        DATA END OF ls_de_items.

        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_de_items
        ).

        MOVE-CORRESPONDING ls_de_items TO ls_items.

        lt_message = lo_sales_order->create_deep_entity_items(
                       CHANGING
                         cs_items  = ls_items
                         cs_header = ls_de_items-to_header
                         cs_mat    = ls_de_items-to_material
                     ).

        IF lt_message IS NOT INITIAL.

          zcl_message_builder=>exception_message(
            it_message = lt_message
            io_msg     = lo_msg
          ).

        ELSE.

          MOVE-CORRESPONDING ls_items TO ls_de_items.

          copy_data_to_ref(
            EXPORTING
              is_data = ls_de_items
            CHANGING
              cr_data = er_deep_entity
          ).
        ENDIF.

      WHEN 'SalesOrderMaterialSet'.

        DATA: ls_mat TYPE zmat.

        DATA BEGIN OF ls_de_material.
        INCLUDE       TYPE zcl_zgw_so_order_mpc=>ts_salesordermaterial.
        DATA to_items TYPE zcl_zgw_so_order_mpc=>ts_salesorderitems.
        DATA END OF ls_de_material.

        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_de_material
        ).

        MOVE-CORRESPONDING ls_de_material TO ls_mat.

        lt_message = lo_sales_order->create_deep_entity_mat(
                       CHANGING
                         cs_items = ls_de_material-to_items
                         cs_mat   = ls_mat
                     ).

        IF lt_message IS NOT INITIAL.

          zcl_message_builder=>exception_message(
            it_message = lt_message
            io_msg     = lo_msg
          ).

        ELSE.

          MOVE-CORRESPONDING ls_mat TO ls_de_material.

          copy_data_to_ref(
            EXPORTING
              is_data = ls_de_material
            CHANGING
              cr_data = er_deep_entity
          ).
        ENDIF.

      WHEN 'SalesOrderCustomerSet'.

        DATA: ls_cust TYPE zcust.

        DATA BEGIN OF ls_de_cust.
        INCLUDE        TYPE zcl_zgw_so_order_mpc=>ts_salesordercustomer.
        DATA to_header TYPE zcl_zgw_so_order_mpc=>tt_salesorderheader.
        DATA END OF ls_de_cust.

        io_data_provider->read_entry_data(
          IMPORTING
            es_data = ls_de_cust
        ).

        MOVE-CORRESPONDING ls_de_cust TO ls_cust.

        lt_message = lo_sales_order->create_deep_entity_cust(
                       CHANGING
                         ct_header = ls_de_cust-to_header
                         cs_cust   = ls_cust
                     ).

        IF lt_message IS NOT INITIAL.

          zcl_message_builder=>exception_message(
            it_message = lt_message
            io_msg     = lo_msg
          ).

        ELSE.

          MOVE-CORRESPONDING ls_cust TO ls_de_cust.

          copy_data_to_ref(
            EXPORTING
              is_data = ls_de_cust
            CHANGING
              cr_data = er_deep_entity
          ).
        ENDIF.

    ENDCASE.

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


  METHOD salesorderset_get_entity.

    DATA: lt_message TYPE ztt_message.

    DATA: ls_sales_order TYPE zst_sd_order.

    ls_sales_order-vbeln  = it_key_tab[ name = 'Vbeln' ]-value.
    ls_sales_order-posnr  = it_key_tab[ name = 'Posnr' ]-value.
    ls_sales_order-matnr  = it_key_tab[ name = 'Matnr' ]-value.
    ls_sales_order-Custid = it_key_tab[ name = 'Custid' ]-value.

    DATA(lo_sd_order) = NEW zcl_sales_order( ).

    er_entity = lo_sd_order->get_single_so(
                  EXPORTING
                    iv_vbeln   = ls_sales_order-vbeln
                    iv_posnr   = ls_sales_order-posnr
                    iv_matnr   = ls_sales_order-matnr
                    iv_custid  = ls_sales_order-Custid
                  IMPORTING
                    et_message = lt_message
                ).

    IF lt_message IS NOT INITIAL.
      me->exception_message_local( it_message = lt_message ).
    ENDIF.



  ENDMETHOD.


  METHOD salesorderset_get_entityset.

    DATA(lo_sales_order) = NEW zcl_sales_order( ).

    et_entityset = lo_sales_order->get_so( iv_fields = iv_filter_string ).

  ENDMETHOD.
ENDCLASS.
