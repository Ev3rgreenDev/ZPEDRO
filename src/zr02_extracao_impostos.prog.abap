*&---------------------------------------------------------------------*
*& Report ZR02_EXTRACAO_IMPOSTOS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr02_extracao_impostos.


SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: num_doc TYPE ze02_num_doc.
SELECTION-SCREEN END OF BLOCK b01.


DATA:
  "Tabela Financeiro 1
  lt_financeiro_tab      TYPE TABLE OF zt02_financeiro,
  ls_financeiro_est      TYPE zs02_financeiro,
  ls_est_financeiro_tab  TYPE zt02_financeiro,
  "Tabela Financeiro 2 - Itens
  lt_financeiro2_tab     TYPE TABLE OF zt02_financeiro2,
  ls_financeiro2_est     TYPE zs02_financeiro2,
  ls_est_financeiro2_tab TYPE zt02_financeiro2,
  "Extras
  lt_financeiro_itab     TYPE STANDARD TABLE OF string,
  ls_financeiro_itab     TYPE string,
  LS_tratamento          TYPE zs02_tratamento,
  LV_filename            TYPE string,
  ls_financeiro_itab2    TYPE string.


START-OF-SELECTION.

  IF num_doc = ' '.
    MESSAGE 'Todos arquivos serão selecionados.' TYPE 'S'.

    SELECT *
    FROM zt02_financeiro
    INTO TABLE lt_financeiro_tab.

    SELECT *
      FROM zt02_financeiro2
      INTO TABLE lt_financeiro2_tab.

  ELSE.

    SELECT *
      FROM zt02_financeiro
      INTO TABLE lt_financeiro_tab
      WHERE num_doc = num_doc.


    IF sy-subrc = 4.
      MESSAGE 'Favor insira um número de docu válido.' TYPE 'E'.
    ENDIF.

    SELECT *
      FROM zt02_financeiro2
      INTO TABLE lt_financeiro2_tab
      WHERE num_doc = num_doc.


    IF sy-subrc = 4.
      MESSAGE 'Favor insira um número de docu válido.' TYPE 'E'.
    ENDIF.

  ENDIF.


  LOOP AT lt_financeiro_tab INTO ls_est_financeiro_tab.

    "ls_financeiro_est = CORRESPONDING #( ls_financeiro_est ).

    CONCATENATE ls_est_financeiro_tab-num_doc
                ls_est_financeiro_tab-reg
                ls_est_financeiro_tab-ind_oper
                ls_est_financeiro_tab-ind_emit
                ls_est_financeiro_tab-cod_part
                ls_est_financeiro_tab-cod_mod
                ls_est_financeiro_tab-cod_sit
                ls_est_financeiro_tab-dt_doc
                ls_est_financeiro_tab-dt_e_s
                ls_est_financeiro_tab-vl_doc
                ls_est_financeiro_tab-ind_pgto
                ls_est_financeiro_tab-ind_frt
                ls_est_financeiro_tab-chv_nfe
                ls_est_financeiro_tab-ser
                ls_est_financeiro_tab-vl_desc
                ls_est_financeiro_tab-vl_abat_nt
                ls_est_financeiro_tab-vl_merc
                ls_est_financeiro_tab-vl_frt
                ls_est_financeiro_tab-vl_seg
                ls_est_financeiro_tab-vl_out_da
                ls_est_financeiro_tab-vl_bc_icms
                ls_est_financeiro_tab-vl_icms
                ls_est_financeiro_tab-vl_bc_icms_st
                ls_est_financeiro_tab-vl_icms_st
                ls_est_financeiro_tab-vl_ipi
                ls_est_financeiro_tab-vl_pis
                ls_est_financeiro_tab-vl_cofins
                ls_est_financeiro_tab-vl_pis_st
                ls_est_financeiro_tab-vl_cofins_st

               INTO ls_financeiro_itab SEPARATED BY '|'.


    CONCATENATE '|'
                ls_financeiro_itab
                '|'
           INTO ls_financeiro_itab2.

    APPEND ls_financeiro_itab2 TO lt_financeiro_itab.

    CLEAR ls_financeiro_itab.
    CLEAR ls_financeiro_itab2.



    LOOP AT lt_financeiro2_tab INTO ls_est_financeiro2_tab WHERE num_doc = ls_est_financeiro_tab-num_doc.

      LS_tratamento-reg               = ls_est_financeiro2_tab-reg.
      LS_tratamento-num_item          = ls_est_financeiro2_tab-num_item.
      LS_tratamento-cod_item          = ls_est_financeiro2_tab-cod_item.
      LS_tratamento-vl_item           = ls_est_financeiro2_tab-vl_item.
      LS_tratamento-cfop              = ls_est_financeiro2_tab-cfop.
      LS_tratamento-cst_pis           = ls_est_financeiro2_tab-cst_pis.
      LS_tratamento-cst_cofins        = ls_est_financeiro2_tab-cst_cofins.
      LS_tratamento-num_doc           = ls_est_financeiro2_tab-num_doc.
      LS_tratamento-descr_compl       = ls_est_financeiro2_tab-descr_compl.
      LS_tratamento-qtd               = ls_est_financeiro2_tab-qtd.
      LS_tratamento-unid              = ls_est_financeiro2_tab-unid.
      LS_tratamento-vl_desc           = ls_est_financeiro2_tab-vl_desc.
      LS_tratamento-ind_mov           = ls_est_financeiro2_tab-ind_mov.
      LS_tratamento-cst_icms          = ls_est_financeiro2_tab-cst_icms.
      LS_tratamento-cod_nat           = ls_est_financeiro2_tab-cod_nat.
      LS_tratamento-vl_bc_icms        = ls_est_financeiro2_tab-vl_bc_icms.
      LS_tratamento-aliq_icms         = ls_est_financeiro2_tab-aliq_icms.
      LS_tratamento-vl_icms           = ls_est_financeiro2_tab-vl_icms.
      LS_tratamento-vl_bc_icms_st     = ls_est_financeiro2_tab-vl_bc_icms_st.
      LS_tratamento-aliq_st           = ls_est_financeiro2_tab-aliq_st.
      LS_tratamento-vl_icms_st        = ls_est_financeiro2_tab-vl_icms_st.
      LS_tratamento-ind_apur          = ls_est_financeiro2_tab-ind_apur.
      LS_tratamento-cst_ipi           = ls_est_financeiro2_tab-cst_ipi.
      LS_tratamento-cod_enq           = ls_est_financeiro2_tab-cod_enq.
      LS_tratamento-vl_bc_ipi         = ls_est_financeiro2_tab-vl_bc_ipi.
      LS_tratamento-aliq_ipi          = ls_est_financeiro2_tab-aliq_ipi.
      LS_tratamento-vl_ipi            = ls_est_financeiro2_tab-vl_ipi.
      LS_tratamento-vl_bc_pis         = ls_est_financeiro2_tab-vl_bc_pis.
      LS_tratamento-aliq_pis          = ls_est_financeiro2_tab-aliq_pis.
      LS_tratamento-quant_bc_pis      = ls_est_financeiro2_tab-quant_bc_pis.
      LS_tratamento-aliq_pis_quant    = ls_est_financeiro2_tab-aliq_pis_quant.
      LS_tratamento-vl_pis            = ls_est_financeiro2_tab-vl_pis.
      LS_tratamento-vl_bc_cofins      = ls_est_financeiro2_tab-vl_bc_cofins.
      LS_tratamento-aliq_cofins       = ls_est_financeiro2_tab-aliq_cofins.
      LS_tratamento-quant_bc_cofins   = ls_est_financeiro2_tab-quant_bc_cofins.
      LS_tratamento-aliq_cofins_quant = ls_est_financeiro2_tab-aliq_cofins_quant.
      LS_tratamento-vl_cofins         = ls_est_financeiro2_tab-vl_cofins.
      LS_tratamento-cod_cta           = ls_est_financeiro2_tab-cod_cta.


      CONCATENATE num_doc
                  LS_tratamento-reg
                  LS_tratamento-num_item
                  LS_tratamento-cod_item
                  LS_tratamento-vl_item
                  LS_tratamento-cfop
                  LS_tratamento-cst_pis
                  LS_tratamento-cst_cofins
                  LS_tratamento-num_doc
                  LS_tratamento-descr_compl
                  LS_tratamento-qtd
                  LS_tratamento-unid
                  LS_tratamento-vl_desc
                  LS_tratamento-ind_mov
                  LS_tratamento-cst_icms
                  LS_tratamento-cod_nat
                  LS_tratamento-vl_bc_icms
                  LS_tratamento-aliq_icms
                  LS_tratamento-vl_icms
                  LS_tratamento-vl_bc_icms_st
                  LS_tratamento-aliq_st
                  LS_tratamento-vl_icms_st
                  LS_tratamento-ind_apur
                  LS_tratamento-cst_ipi
                  LS_tratamento-cod_enq
                  LS_tratamento-vl_bc_ipi
                  LS_tratamento-aliq_ipi
                  LS_tratamento-vl_ipi
                  LS_tratamento-vl_bc_pis
                  LS_tratamento-aliq_pis
                  LS_tratamento-quant_bc_pis
                  LS_tratamento-aliq_pis_quant
                  LS_tratamento-vl_pis
                  LS_tratamento-vl_bc_cofins
                  LS_tratamento-aliq_cofins
                  LS_tratamento-quant_bc_cofins
                  LS_tratamento-aliq_cofins_quant
                  LS_tratamento-vl_cofins
                  LS_tratamento-cod_cta

                  INTO ls_financeiro_itab SEPARATED BY '|'.

      CONCATENATE ls_financeiro_itab
                  '|'
           INTO ls_financeiro_itab2.

      APPEND ls_financeiro_itab2 TO lt_financeiro_itab.

    ENDLOOP.
  ENDLOOP.

  CALL FUNCTION 'GUI_DOWNLOAD'
    EXPORTING
*     BIN_FILESIZE            =
      filename                = 'C:\temp\file.txt'
*     FILETYPE                = 'ASC'
*     APPEND                  = ' '
*     WRITE_FIELD_SEPARATOR   = ' '
*     HEADER                  = '00'
*     TRUNC_TRAILING_BLANKS   = ' '
*     WRITE_LF                = 'X'
*     COL_SELECT              = ' '
*     COL_SELECT_MASK         = ' '
*     DAT_MODE                = ' '
*     CONFIRM_OVERWRITE       = ' '
*     NO_AUTH_CHECK           = ' '
*     CODEPAGE                = ' '
*     IGNORE_CERR             = ABAP_TRUE
*     REPLACEMENT             = '#'
*     WRITE_BOM               = ' '
*     TRUNC_TRAILING_BLANKS_EOL       = 'X'
*     WK1_N_FORMAT            = ' '
*     WK1_N_SIZE              = ' '
*     WK1_T_FORMAT            = ' '
*     WK1_T_SIZE              = ' '
*     WRITE_LF_AFTER_LAST_LINE        = ABAP_TRUE
*     SHOW_TRANSFER_STATUS    = ABAP_TRUE
*     VIRUS_SCAN_PROFILE      = '/SCET/GUI_DOWNLOAD'
*   IMPORTING
*     FILELENGTH              =
    TABLES
      data_tab                = lt_financeiro_itab
*     FIELDNAMES              =
    EXCEPTIONS
      file_write_error        = 1
      no_batch                = 2
      gui_refuse_filetransfer = 3
      invalid_type            = 4
      no_authority            = 5
      unknown_error           = 6
      header_not_allowed      = 7
      separator_not_allowed   = 8
      filesize_not_allowed    = 9
      header_too_long         = 10
      dp_error_create         = 11
      dp_error_send           = 12
      dp_error_write          = 13
      unknown_dp_error        = 14
      access_denied           = 15
      dp_out_of_memory        = 16
      disk_full               = 17
      dp_timeout              = 18
      file_not_found          = 19
      dataprovider_exception  = 20
      control_flush_error     = 21
      OTHERS                  = 22.

  IF sy-subrc <> 0.
* Implement suitable error handling here
  ENDIF.
