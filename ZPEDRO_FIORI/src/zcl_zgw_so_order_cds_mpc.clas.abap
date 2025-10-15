class ZCL_ZGW_SO_ORDER_CDS_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  interfaces IF_SADL_GW_MODEL_EXPOSURE_DATA .

  types:
    begin of TS_ZI_MM_STOCK_SH_LOCTYPE.
      include type ZI_MM_STOCK_SH_LOC.
  types:
    end of TS_ZI_MM_STOCK_SH_LOCTYPE .
  types:
   TT_ZI_MM_STOCK_SH_LOCTYPE type standard table of TS_ZI_MM_STOCK_SH_LOCTYPE .
  types:
    begin of TS_ZI_MM_STOCK_SH_MATTYPE.
      include type ZI_MM_STOCK_SH_MAT.
  types:
    end of TS_ZI_MM_STOCK_SH_MATTYPE .
  types:
   TT_ZI_MM_STOCK_SH_MATTYPE type standard table of TS_ZI_MM_STOCK_SH_MATTYPE .
  types:
    begin of TS_ZI_MM_STOCK_SH_STATUSTYPE.
      include type ZI_MM_STOCK_SH_STATUS.
  types:
    end of TS_ZI_MM_STOCK_SH_STATUSTYPE .
  types:
   TT_ZI_MM_STOCK_SH_STATUSTYPE type standard table of TS_ZI_MM_STOCK_SH_STATUSTYPE .
  types:
    begin of TS_ZI_MM_UNID_SEARCH_HELPTYPE.
      include type ZI_MM_UNID_SEARCH_HELP.
  types:
    end of TS_ZI_MM_UNID_SEARCH_HELPTYPE .
  types:
   TT_ZI_MM_UNID_SEARCH_HELPTYPE type standard table of TS_ZI_MM_UNID_SEARCH_HELPTYPE .
  types:
    begin of TS_ZI_MOEDATYPE.
      include type ZI_MOEDA.
  types:
    end of TS_ZI_MOEDATYPE .
  types:
   TT_ZI_MOEDATYPE type standard table of TS_ZI_MOEDATYPE .
  types:
    begin of TS_ZI_SD_CUSTTYPE.
      include type ZI_SD_CUST.
  types:
    end of TS_ZI_SD_CUSTTYPE .
  types:
   TT_ZI_SD_CUSTTYPE type standard table of TS_ZI_SD_CUSTTYPE .
  types:
    begin of TS_ZI_SD_CUST_NEWTYPE.
      include type ZI_SD_CUST_NEW.
  types:
    end of TS_ZI_SD_CUST_NEWTYPE .
  types:
   TT_ZI_SD_CUST_NEWTYPE type standard table of TS_ZI_SD_CUST_NEWTYPE .
  types:
    begin of TS_ZI_SD_CUST_SHTYPE.
      include type ZI_SD_CUST_SH.
  types:
    end of TS_ZI_SD_CUST_SHTYPE .
  types:
   TT_ZI_SD_CUST_SHTYPE type standard table of TS_ZI_SD_CUST_SHTYPE .
  types:
    begin of TS_ZI_SD_HEADER_NEWTYPE.
      include type ZI_SD_HEADER_NEW.
  types:
    end of TS_ZI_SD_HEADER_NEWTYPE .
  types:
   TT_ZI_SD_HEADER_NEWTYPE type standard table of TS_ZI_SD_HEADER_NEWTYPE .
  types:
    begin of TS_ZI_SD_ITEMSTYPE.
      include type ZI_SD_ITEMS.
  types:
    end of TS_ZI_SD_ITEMSTYPE .
  types:
   TT_ZI_SD_ITEMSTYPE type standard table of TS_ZI_SD_ITEMSTYPE .
  types:
    begin of TS_ZI_SD_ITEMS_NEWTYPE.
      include type ZI_SD_ITEMS_NEW.
  types:
    end of TS_ZI_SD_ITEMS_NEWTYPE .
  types:
   TT_ZI_SD_ITEMS_NEWTYPE type standard table of TS_ZI_SD_ITEMS_NEWTYPE .
  types:
    begin of TS_ZI_SD_MATERIALTYPE.
      include type ZI_SD_MATERIAL.
  types:
    end of TS_ZI_SD_MATERIALTYPE .
  types:
   TT_ZI_SD_MATERIALTYPE type standard table of TS_ZI_SD_MATERIALTYPE .
  types:
    begin of TS_ZI_SD_MATERIAL_NEWTYPE.
      include type ZI_SD_MATERIAL_NEW.
  types:
    end of TS_ZI_SD_MATERIAL_NEWTYPE .
  types:
   TT_ZI_SD_MATERIAL_NEWTYPE type standard table of TS_ZI_SD_MATERIAL_NEWTYPE .
  types:
    begin of TS_ZI_SD_SALES_ORDERTYPE.
      include type ZI_SD_SALES_ORDER.
  types:
    end of TS_ZI_SD_SALES_ORDERTYPE .
  types:
   TT_ZI_SD_SALES_ORDERTYPE type standard table of TS_ZI_SD_SALES_ORDERTYPE .
  types:
    begin of TS_ZI_SD_SALES_ORDER_CALCTYPE.
      include type ZI_SD_SALES_ORDER_CALC.
  types:
    end of TS_ZI_SD_SALES_ORDER_CALCTYPE .
  types:
   TT_ZI_SD_SALES_ORDER_CALCTYPE type standard table of TS_ZI_SD_SALES_ORDER_CALCTYPE .
  types:
    begin of TS_ZI_SD_SALES_ORDER_NEWTYPE.
      include type ZI_SD_SALES_ORDER_NEW.
  types:
    end of TS_ZI_SD_SALES_ORDER_NEWTYPE .
  types:
   TT_ZI_SD_SALES_ORDER_NEWTYPE type standard table of TS_ZI_SD_SALES_ORDER_NEWTYPE .
  types:
    begin of TS_ZI_STATUSTYPE.
      include type ZI_STATUS.
  types:
    end of TS_ZI_STATUSTYPE .
  types:
   TT_ZI_STATUSTYPE type standard table of TS_ZI_STATUSTYPE .

  constants GC_ZI_MM_STOCK_SH_LOCTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_STOCK_SH_LOCType' ##NO_TEXT.
  constants GC_ZI_MM_STOCK_SH_MATTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_STOCK_SH_MATType' ##NO_TEXT.
  constants GC_ZI_MM_STOCK_SH_STATUSTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_STOCK_SH_STATUSType' ##NO_TEXT.
  constants GC_ZI_MM_UNID_SEARCH_HELPTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_UNID_SEARCH_HELPType' ##NO_TEXT.
  constants GC_ZI_MOEDATYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MOEDAType' ##NO_TEXT.
  constants GC_ZI_SD_CUSTTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_SD_CUSTType' ##NO_TEXT.
  constants GC_ZI_SD_CUST_NEWTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_SD_CUST_NEWType' ##NO_TEXT.
  constants GC_ZI_SD_CUST_SHTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_SD_CUST_SHType' ##NO_TEXT.
  constants GC_ZI_SD_HEADER_NEWTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_SD_HEADER_NEWType' ##NO_TEXT.
  constants GC_ZI_SD_ITEMSTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_SD_ITEMSType' ##NO_TEXT.
  constants GC_ZI_SD_ITEMS_NEWTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_SD_ITEMS_NEWType' ##NO_TEXT.
  constants GC_ZI_SD_MATERIALTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_SD_MATERIALType' ##NO_TEXT.
  constants GC_ZI_SD_MATERIAL_NEWTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_SD_MATERIAL_NEWType' ##NO_TEXT.
  constants GC_ZI_SD_SALES_ORDERTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_SD_SALES_ORDERType' ##NO_TEXT.
  constants GC_ZI_SD_SALES_ORDER_CALCTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_SD_SALES_ORDER_CALCType' ##NO_TEXT.
  constants GC_ZI_SD_SALES_ORDER_NEWTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_SD_SALES_ORDER_NEWType' ##NO_TEXT.
  constants GC_ZI_STATUSTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_STATUSType' ##NO_TEXT.

  methods DEFINE
    redefinition .
  methods GET_LAST_MODIFIED
    redefinition .
protected section.
private section.

  methods DEFINE_RDS_4
    raising
      /IWBEP/CX_MGW_MED_EXCEPTION .
  methods GET_LAST_MODIFIED_RDS_4
    returning
      value(RV_LAST_MODIFIED_RDS) type TIMESTAMP .
ENDCLASS.



CLASS ZCL_ZGW_SO_ORDER_CDS_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZGW_SO_ORDER_CDS_SRV' ).

define_rds_4( ).
get_last_modified_rds_4( ).
  endmethod.


  method DEFINE_RDS_4.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*
*   This code is generated for Reference Data Source
*   4
*&---------------------------------------------------------------------*
    TRY.
        if_sadl_gw_model_exposure_data~get_model_exposure( )->expose( model )->expose_vocabulary( vocab_anno_model ).
      CATCH cx_sadl_exposure_error INTO DATA(lx_sadl_exposure_error).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_med_exception
          EXPORTING
            previous = lx_sadl_exposure_error.
    ENDTRY.
  endmethod.


  method GET_LAST_MODIFIED.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20251014133855'.                  "#EC NOTEXT
 DATA: lv_rds_last_modified TYPE timestamp .
  rv_last_modified = super->get_last_modified( ).
  IF rv_last_modified LT lc_gen_date_time.
    rv_last_modified = lc_gen_date_time.
  ENDIF.
 lv_rds_last_modified =  GET_LAST_MODIFIED_RDS_4( ).
 IF rv_last_modified LT lv_rds_last_modified.
 rv_last_modified  = lv_rds_last_modified .
 ENDIF .
  endmethod.


  method GET_LAST_MODIFIED_RDS_4.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS          &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL   &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                    &*
*&                                                                     &*
*&---------------------------------------------------------------------*
*   This code is generated for Reference Data Source
*   4
*&---------------------------------------------------------------------*
*    @@TYPE_SWITCH:
    CONSTANTS: co_gen_date_time TYPE timestamp VALUE '20251014133856'.
    TRY.
        rv_last_modified_rds = CAST cl_sadl_gw_model_exposure( if_sadl_gw_model_exposure_data~get_model_exposure( ) )->get_last_modified( ).
      CATCH cx_root ##CATCH_ALL.
        rv_last_modified_rds = co_gen_date_time.
    ENDTRY.
    IF rv_last_modified_rds < co_gen_date_time.
      rv_last_modified_rds = co_gen_date_time.
    ENDIF.
  endmethod.


  method IF_SADL_GW_MODEL_EXPOSURE_DATA~GET_MODEL_EXPOSURE.
    CONSTANTS: co_gen_timestamp TYPE timestamp VALUE '20251014133856'.
    DATA(lv_sadl_xml) =
               |<?xml version="1.0" encoding="utf-16"?>|  &
               |<sadl:definition xmlns:sadl="http://sap.com/sap.nw.f.sadl" syntaxVersion="" >|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_STOCK_SH_LOC" binding="ZI_MM_STOCK_SH_LOC" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_STOCK_SH_MAT" binding="ZI_MM_STOCK_SH_MAT" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_STOCK_SH_STATUS" binding="ZI_MM_STOCK_SH_STATUS" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_UNID_SEARCH_HELP" binding="ZI_MM_UNID_SEARCH_HELP" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MOEDA" binding="ZI_MOEDA" />|  &
               | <sadl:dataSource type="CDS" name="ZI_SD_CUST" binding="ZI_SD_CUST" />|  &
               | <sadl:dataSource type="CDS" name="ZI_SD_CUST_NEW" binding="ZI_SD_CUST_NEW" />|  &
               | <sadl:dataSource type="CDS" name="ZI_SD_CUST_SH" binding="ZI_SD_CUST_SH" />|  &
               | <sadl:dataSource type="CDS" name="ZI_SD_HEADER_NEW" binding="ZI_SD_HEADER_NEW" />|  &
               | <sadl:dataSource type="CDS" name="ZI_SD_ITEMS" binding="ZI_SD_ITEMS" />|  &
               | <sadl:dataSource type="CDS" name="ZI_SD_ITEMS_NEW" binding="ZI_SD_ITEMS_NEW" />|  &
               | <sadl:dataSource type="CDS" name="ZI_SD_MATERIAL" binding="ZI_SD_MATERIAL" />|  &
               | <sadl:dataSource type="CDS" name="ZI_SD_MATERIAL_NEW" binding="ZI_SD_MATERIAL_NEW" />|  &
               | <sadl:dataSource type="CDS" name="ZI_SD_SALES_ORDER" binding="ZI_SD_SALES_ORDER" />|  &
               | <sadl:dataSource type="CDS" name="ZI_SD_SALES_ORDER_CALC" binding="ZI_SD_SALES_ORDER_CALC" />|  &
               | <sadl:dataSource type="CDS" name="ZI_SD_SALES_ORDER_NEW" binding="ZI_SD_SALES_ORDER_NEW" />|  &
               | <sadl:dataSource type="CDS" name="ZI_STATUS" binding="ZI_STATUS" />|  &
               |<sadl:resultSet>|  &
               |<sadl:structure name="ZI_MM_STOCK_SH_LOC" dataSource="ZI_MM_STOCK_SH_LOC" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_MM_STOCK_SH_MAT" dataSource="ZI_MM_STOCK_SH_MAT" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_MM_STOCK_SH_STATUS" dataSource="ZI_MM_STOCK_SH_STATUS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_MM_UNID_SEARCH_HELP" dataSource="ZI_MM_UNID_SEARCH_HELP" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_MOEDA" dataSource="ZI_MOEDA" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_SD_CUST" dataSource="ZI_SD_CUST" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_SD_CUST_NEW" dataSource="ZI_SD_CUST_NEW" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_SD_CUST_SH" dataSource="ZI_SD_CUST_SH" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">| .
      lv_sadl_xml = |{ lv_sadl_xml }| &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_SD_HEADER_NEW" dataSource="ZI_SD_HEADER_NEW" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_SD_ITEMS" dataSource="ZI_SD_ITEMS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_M" binding="_M" target="ZI_SD_MATERIAL" cardinality="zeroToOne" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_SD_ITEMS_NEW" dataSource="ZI_SD_ITEMS_NEW" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_M" binding="_M" target="ZI_SD_MATERIAL_NEW" cardinality="zeroToOne" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_SD_MATERIAL" dataSource="ZI_SD_MATERIAL" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_SD_MATERIAL_NEW" dataSource="ZI_SD_MATERIAL_NEW" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_SD_SALES_ORDER" dataSource="ZI_SD_SALES_ORDER" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_C" binding="_C" target="ZI_SD_CUST" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_I" binding="_I" target="ZI_SD_ITEMS" cardinality="zeroToMany" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_SD_SALES_ORDER_CALC" dataSource="ZI_SD_SALES_ORDER_CALC" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_C" binding="_C" target="ZI_SD_CUST" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_I" binding="_I" target="ZI_SD_ITEMS" cardinality="zeroToMany" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_SD_SALES_ORDER_NEW" dataSource="ZI_SD_SALES_ORDER_NEW" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_C" binding="_C" target="ZI_SD_CUST_NEW" cardinality="zeroToMany" />|  &
               | <sadl:association name="TO_I" binding="_I" target="ZI_SD_ITEMS_NEW" cardinality="oneToMany" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_STATUS" dataSource="ZI_STATUS" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |</sadl:resultSet>|  &
               |</sadl:definition>| .

   ro_model_exposure = cl_sadl_gw_model_exposure=>get_exposure_xml( iv_uuid      = CONV #( 'ZGW_SO_ORDER_CDS' )
                                                                    iv_timestamp = co_gen_timestamp
                                                                    iv_sadl_xml  = lv_sadl_xml ).
  endmethod.
ENDCLASS.
