class ZCL_ZGW_MM_STOCK_CDS_MPC definition
  public
  inheriting from /IWBEP/CL_MGW_PUSH_ABS_MODEL
  create public .

public section.

  interfaces IF_SADL_GW_MODEL_EXPOSURE_DATA .

  types:
    begin of TS_ZI_MM_INVTYPE.
      include type ZI_MM_INV.
  types:
    end of TS_ZI_MM_INVTYPE .
  types:
   TT_ZI_MM_INVTYPE type standard table of TS_ZI_MM_INVTYPE .
  types:
    begin of TS_ZI_MM_LOCTYPE.
      include type ZI_MM_LOC.
  types:
    end of TS_ZI_MM_LOCTYPE .
  types:
   TT_ZI_MM_LOCTYPE type standard table of TS_ZI_MM_LOCTYPE .
  types:
    begin of TS_ZI_MM_MATTYPE.
      include type ZI_MM_MAT.
  types:
    end of TS_ZI_MM_MATTYPE .
  types:
   TT_ZI_MM_MATTYPE type standard table of TS_ZI_MM_MATTYPE .
  types:
    begin of TS_ZI_MM_MOVTYPE.
      include type ZI_MM_MOV.
  types:
    end of TS_ZI_MM_MOVTYPE .
  types:
   TT_ZI_MM_MOVTYPE type standard table of TS_ZI_MM_MOVTYPE .
  types:
    begin of TS_ZI_MM_RESTYPE.
      include type ZI_MM_RES.
  types:
    end of TS_ZI_MM_RESTYPE .
  types:
   TT_ZI_MM_RESTYPE type standard table of TS_ZI_MM_RESTYPE .
  types:
    begin of TS_ZI_MM_STOCKTYPE.
      include type ZI_MM_STOCK.
  types:
    end of TS_ZI_MM_STOCKTYPE .
  types:
   TT_ZI_MM_STOCKTYPE type standard table of TS_ZI_MM_STOCKTYPE .
  types:
    begin of TS_ZI_MM_STOCK_NAVTYPE.
      include type ZI_MM_STOCK_NAV.
  types:
    end of TS_ZI_MM_STOCK_NAVTYPE .
  types:
   TT_ZI_MM_STOCK_NAVTYPE type standard table of TS_ZI_MM_STOCK_NAVTYPE .
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

  constants GC_ZI_MM_INVTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_INVType' ##NO_TEXT.
  constants GC_ZI_MM_LOCTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_LOCType' ##NO_TEXT.
  constants GC_ZI_MM_MATTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_MATType' ##NO_TEXT.
  constants GC_ZI_MM_MOVTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_MOVType' ##NO_TEXT.
  constants GC_ZI_MM_RESTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_RESType' ##NO_TEXT.
  constants GC_ZI_MM_STOCKTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_STOCKType' ##NO_TEXT.
  constants GC_ZI_MM_STOCK_NAVTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_STOCK_NAVType' ##NO_TEXT.
  constants GC_ZI_MM_STOCK_SH_LOCTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_STOCK_SH_LOCType' ##NO_TEXT.
  constants GC_ZI_MM_STOCK_SH_MATTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_STOCK_SH_MATType' ##NO_TEXT.
  constants GC_ZI_MM_STOCK_SH_STATUSTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_STOCK_SH_STATUSType' ##NO_TEXT.
  constants GC_ZI_MM_UNID_SEARCH_HELPTYPE type /IWBEP/IF_MGW_MED_ODATA_TYPES=>TY_E_MED_ENTITY_NAME value 'ZI_MM_UNID_SEARCH_HELPType' ##NO_TEXT.

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



CLASS ZCL_ZGW_MM_STOCK_CDS_MPC IMPLEMENTATION.


  method DEFINE.
*&---------------------------------------------------------------------*
*&           Generated code for the MODEL PROVIDER BASE CLASS         &*
*&                                                                     &*
*&  !!!NEVER MODIFY THIS CLASS. IN CASE YOU WANT TO CHANGE THE MODEL  &*
*&        DO THIS IN THE MODEL PROVIDER SUBCLASS!!!                   &*
*&                                                                     &*
*&---------------------------------------------------------------------*

model->set_schema_namespace( 'ZGW_MM_STOCK_CDS_SRV' ).

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


  CONSTANTS: lc_gen_date_time TYPE timestamp VALUE '20251014134438'.                  "#EC NOTEXT
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
    CONSTANTS: co_gen_date_time TYPE timestamp VALUE '20251014134438'.
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
    CONSTANTS: co_gen_timestamp TYPE timestamp VALUE '20251014134438'.
    DATA(lv_sadl_xml) =
               |<?xml version="1.0" encoding="utf-16"?>|  &
               |<sadl:definition xmlns:sadl="http://sap.com/sap.nw.f.sadl" syntaxVersion="" >|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_INV" binding="ZI_MM_INV" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_LOC" binding="ZI_MM_LOC" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_MAT" binding="ZI_MM_MAT" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_MOV" binding="ZI_MM_MOV" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_RES" binding="ZI_MM_RES" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_STOCK" binding="ZI_MM_STOCK" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_STOCK_NAV" binding="ZI_MM_STOCK_NAV" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_STOCK_SH_LOC" binding="ZI_MM_STOCK_SH_LOC" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_STOCK_SH_MAT" binding="ZI_MM_STOCK_SH_MAT" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_STOCK_SH_STATUS" binding="ZI_MM_STOCK_SH_STATUS" />|  &
               | <sadl:dataSource type="CDS" name="ZI_MM_UNID_SEARCH_HELP" binding="ZI_MM_UNID_SEARCH_HELP" />|  &
               |<sadl:resultSet>|  &
               |<sadl:structure name="ZI_MM_INV" dataSource="ZI_MM_INV" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_SEARCHLOC" binding="_SEARCHLOC" target="ZI_MM_STOCK_SH_LOC" cardinality="zeroToOne" />|  &
               | <sadl:association name="TO_SEARCHMAT" binding="_SEARCHMAT" target="ZI_MM_STOCK_SH_MAT" cardinality="zeroToOne" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_MM_LOC" dataSource="ZI_MM_LOC" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_MM_MAT" dataSource="ZI_MM_MAT" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_MM_MOV" dataSource="ZI_MM_MOV" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_LOC" binding="_LOC" target="ZI_MM_LOC" cardinality="one" />|  &
               | <sadl:association name="TO_MAT" binding="_MAT" target="ZI_MM_MAT" cardinality="one" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_MM_RES" dataSource="ZI_MM_RES" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_LOC" binding="_LOC" target="ZI_MM_LOC" cardinality="one" />|  &
               | <sadl:association name="TO_MAT" binding="_MAT" target="ZI_MM_MAT" cardinality="one" />|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_MM_STOCK" dataSource="ZI_MM_STOCK" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               |</sadl:structure>|  &
               |<sadl:structure name="ZI_MM_STOCK_NAV" dataSource="ZI_MM_STOCK_NAV" maxEditMode="RO" exposure="TRUE" >|  &
               | <sadl:query name="SADL_QUERY">|  &
               | </sadl:query>|  &
               | <sadl:association name="TO_INV" binding="_INV" target="ZI_MM_INV" cardinality="oneToMany" />|  &
               | <sadl:association name="TO_LOC" binding="_LOC" target="ZI_MM_LOC" cardinality="one" />|  &
               | <sadl:association name="TO_MAT" binding="_MAT" target="ZI_MM_MAT" cardinality="one" />| .
      lv_sadl_xml = |{ lv_sadl_xml }| &
               | <sadl:association name="TO_MOV" binding="_MOV" target="ZI_MM_MOV" cardinality="oneToMany" />|  &
               |</sadl:structure>|  &
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
               |</sadl:resultSet>|  &
               |</sadl:definition>| .

   ro_model_exposure = cl_sadl_gw_model_exposure=>get_exposure_xml( iv_uuid      = CONV #( 'ZGW_MM_STOCK_CDS' )
                                                                    iv_timestamp = co_gen_timestamp
                                                                    iv_sadl_xml  = lv_sadl_xml ).
  endmethod.
ENDCLASS.
