*&---------------------------------------------------------------------*
*& Report ZR02FINANCEIRO2
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr02financeiro2.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_file TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK b01.

DATA: LS_estruturaFinanceiro2 TYPE ZS02_financeiro2,
      LT_tableFinanceiro2     TYPE ztt02_financeiro2,
      LV_filename             TYPE string,
      LS_estFinanceiro_tab2   TYPE zt02_financeiro2,
      LT_teste                TYPE STANDARD TABLE OF string,
      LS_teste                TYPE string,
      LS_tratamento           TYPE zs02_tratamento.

AT SELECTION-SCREEN ON p_file.
  IF p_file = ' '.
    CALL FUNCTION 'WS_FILENAME_GET'
      IMPORTING
        filename         = p_file
      EXCEPTIONS
        inv_winsys       = 1
        no_batch         = 2
        selection_cancel = 3
        selection_error  = 4
        OTHERS           = 5.
  ENDIF.

START-OF-SELECTION.
  IF p_file IS NOT INITIAL.
    lv_filename = p_file.
    CALL FUNCTION 'GUI_UPLOAD'
      EXPORTING
        filename                = lv_filename
        filetype                = 'ASC'
        has_field_separator     = ';'
      TABLES
        data_tab                = lt_teste
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        OTHERS                  = 17.
    IF sy-subrc <> 0.
* Implement suitable error handling here
    ENDIF.

    IF lt_teste IS NOT INITIAL.
      LOOP AT lt_teste INTO ls_teste.
        IF sy-tabix <> 1.

          SPLIT ls_teste AT ';' INTO ls_estruturafinanceiro2-reg
                                     ls_estruturafinanceiro2-num_item
                                     ls_estruturafinanceiro2-cod_item
                                     LS_tratamento-vl_item
                                     ls_estruturafinanceiro2-cfop
                                     ls_estruturafinanceiro2-cst_pis
                                     ls_estruturafinanceiro2-cst_cofins
                                     ls_estruturafinanceiro2-NUM_doc
                                     ls_estruturafinanceiro2-descr_compl
                                     LS_tratamento-qtd
                                     ls_estruturafinanceiro2-unid
                                     LS_tratamento-vl_desc
                                     ls_estruturafinanceiro2-ind_mov
                                     ls_estruturafinanceiro2-cst_icms
                                     ls_estruturafinanceiro2-cod_nat
                                     LS_tratamento-vl_bc_icms
                                     LS_tratamento-aliq_icms
                                     LS_tratamento-vl_icms
                                     LS_tratamento-vl_bc_icms_st
                                     LS_tratamento-aliq_st
                                     LS_tratamento-vl_icms_st
                                     ls_estruturafinanceiro2-ind_apur
                                     ls_estruturafinanceiro2-cst_ipi
                                     ls_estruturafinanceiro2-cod_enq
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
                                     ls_estruturafinanceiro2-cod_cta.

          MOVE LS_tratamento-aliq_icms TO ls_estruturafinanceiro2-aliq_icms.
          MOVE LS_tratamento-aliq_st TO ls_estruturafinanceiro2-aliq_st.
          MOVE LS_tratamento-aliq_ipi TO ls_estruturafinanceiro2-aliq_ipi.
          MOVE LS_tratamento-aliq_pis TO ls_estruturafinanceiro2-aliq_pis.
          MOVE LS_tratamento-aliq_cofins TO ls_estruturafinanceiro2-aliq_cofins.
          ADD LS_tratamento-vl_item TO ls_estruturafinanceiro2-vl_item.
          MOVE LS_tratamento-qtd TO ls_estruturafinanceiro2-qtd.
          MOVE LS_tratamento-vl_desc TO ls_estruturafinanceiro2-vl_desc.
          MOVE LS_tratamento-vl_bc_icms TO ls_estruturafinanceiro2-vl_bc_icms.
          ADD LS_tratamento-vl_icms TO ls_estruturafinanceiro2-vl_icms.
          MOVE LS_tratamento-vl_bc_icms_st TO ls_estruturafinanceiro2-vl_bc_icms_st.
          MOVE LS_tratamento-vl_icms_st TO ls_estruturafinanceiro2-vl_icms_st.
          MOVE LS_tratamento-vl_bc_ipi TO ls_estruturafinanceiro2-vl_bc_ipi.
          MOVE LS_tratamento-vl_ipi TO ls_estruturafinanceiro2-vl_ipi.
          MOVE LS_tratamento-vl_bc_pis TO ls_estruturafinanceiro2-vl_bc_pis.
          MOVE LS_tratamento-quant_bc_pis TO ls_estruturafinanceiro2-quant_bc_pis.
          MOVE LS_tratamento-aliq_pis_quant TO ls_estruturafinanceiro2-aliq_pis_quant.
          MOVE LS_tratamento-vl_pis TO ls_estruturafinanceiro2-vl_pis.
          MOVE LS_tratamento-vl_bc_cofins TO ls_estruturafinanceiro2-vl_bc_cofins.
          MOVE LS_tratamento-quant_bc_cofins TO ls_estruturafinanceiro2-quant_bc_cofins.
          MOVE LS_tratamento-aliq_cofins_quant TO ls_estruturafinanceiro2-aliq_cofins_quant.
          MOVE LS_tratamento-vl_cofins TO ls_estruturafinanceiro2-vl_cofins.


          APPEND ls_estruturafinanceiro2 TO lt_tablefinanceiro2.
          CLEAR ls_estruturafinanceiro2.

        ENDIF.
      ENDLOOP.

      SELECT SINGLE num_doc
        FROM zt02_financeiro2
        INTO LS_estFinanceiro_tab2
        WHERE num_doc = LS_estFinanceiro_tab2-num_doc.


      LOOP AT lt_tablefinanceiro2 INTO ls_estruturafinanceiro2.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_estruturafinanceiro2-num_doc
          IMPORTING
            output = ls_estruturafinanceiro2-num_doc.

        ls_estfinanceiro_tab2 = CORRESPONDING #( ls_estruturafinanceiro2 ).

        READ TABLE lt_tablefinanceiro2 INTO ls_estruturafinanceiro2 WITH KEY ls_estruturafinanceiro2-num_doc.

        IF sy-subrc = 4.
          INSERT zt02_financeiro2 FROM ls_estfinanceiro_tab2.

        ELSEIF sy-subrc = 0.
          MESSAGE 'Há linhas duplicadas!!!' TYPE 'S'.

        ENDIF.
      ENDLOOP.
    ENDIF.

    MESSAGE 'Arquivo carregado com sucesso!' TYPE 'S'.

  ELSE.
    MESSAGE 'A entrada de um arquivo é obrigatória.' TYPE 'S'.
  ENDIF.
