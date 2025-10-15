class ZCL_ZGW_SO_ORDER_CDS_DPC_EXT definition
  public
  inheriting from ZCL_ZGW_SO_ORDER_CDS_DPC
  create public .

public section.
protected section.

  methods ZI_SD_SALES_ORDE_GET_ENTITYSET
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZGW_SO_ORDER_CDS_DPC_EXT IMPLEMENTATION.


  METHOD zi_sd_sales_orde_get_entityset.

    super->zi_sd_sales_orde_get_entityset(
      EXPORTING
        iv_entity_name           = iv_entity_name
        iv_entity_set_name       = iv_entity_set_name
        iv_source_name           = iv_source_name
        it_filter_select_options = it_filter_select_options
        is_paging                = is_paging
        it_key_tab               = it_key_tab
        it_navigation_path       = it_navigation_path
        it_order                 = it_order
        iv_filter_string         = iv_filter_string
        iv_search_string         = iv_search_string
        io_tech_request_context  = io_tech_request_context
      IMPORTING
        et_entityset             = et_entityset
        es_response_context      = es_response_context
    ).
*    CATCH /iwbep/cx_mgw_busi_exception. " business exception in mgw
*    CATCH /iwbep/cx_mgw_tech_exception. " mgw technical exception

    LOOP AT et_entityset ASSIGNING FIELD-SYMBOL(<fs_cds>).

      IF <fs_cds>-moeda EQ 'BRL'.

        <fs_cds>-moeda = 'USD'.

      ENDIF.
    ENDLOOP.

  ENDMETHOD.
ENDCLASS.
