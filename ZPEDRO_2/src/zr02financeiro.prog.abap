*&---------------------------------------------------------------------*
*& Report ZR02FINANCEIRO
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr02financeiro.

SELECTION-SCREEN BEGIN OF BLOCK b01 WITH FRAME TITLE TEXT-001.
  PARAMETERS: p_file TYPE rlgrap-filename.
SELECTION-SCREEN END OF BLOCK b01.

DATA: LS_estruturaFinanceiro TYPE ZS02_financeiro,
      LT_tableFinanceiro     TYPE ZTT02_financeiro,
      lv_filename            TYPE string,
      LT_teste               TYPE STANDARD TABLE OF string,
      ls_estFinanceiro_tab   TYPE zt02_financeiro,
      ls_teste               TYPE string.

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

          SPLIT ls_teste AT ';' INTO ls_estruturafinanceiro-reg
                                     ls_estruturafinanceiro-ind_oper
                                     ls_estruturafinanceiro-ind_emit
                                     ls_estruturafinanceiro-cod_part
                                     ls_estruturafinanceiro-cod_mod
                                     ls_estruturafinanceiro-cod_sit
                                     ls_estruturafinanceiro-num_doc
                                     ls_estruturafinanceiro-dt_doc
                                     ls_estruturafinanceiro-dt_e_s
                                     ls_estruturafinanceiro-vl_doc
                                     ls_estruturafinanceiro-ind_pgto
                                     ls_estruturafinanceiro-ind_frt
                                     ls_estruturafinanceiro-chv_nfe
                                     ls_estruturafinanceiro-ser
                                     ls_estruturafinanceiro-vl_desc
                                     ls_estruturafinanceiro-vl_abat_nt
                                     ls_estruturafinanceiro-vl_merc
                                     ls_estruturafinanceiro-vl_frt
                                     ls_estruturafinanceiro-vl_seg
                                     ls_estruturafinanceiro-vl_out_da
                                     ls_estruturafinanceiro-vl_bc_icms
                                     ls_estruturafinanceiro-vl_icms
                                     ls_estruturafinanceiro-vl_bc_icms_st
                                     ls_estruturafinanceiro-vl_icms_st
                                     ls_estruturafinanceiro-vl_ipi
                                     ls_estruturafinanceiro-vl_pis
                                     ls_estruturafinanceiro-vl_cofins
                                     ls_estruturafinanceiro-vl_pis_st
                                     ls_estruturafinanceiro-vl_cofins_st.

          APPEND ls_estruturafinanceiro TO lt_tablefinanceiro.
          CLEAR ls_estruturafinanceiro.

        ENDIF.
      ENDLOOP.

      LOOP AT lt_tablefinanceiro INTO ls_estruturafinanceiro.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = ls_estruturafinanceiro-num_doc
          IMPORTING
            output = ls_estruturafinanceiro-num_doc.

        WRITE: ls_estruturafinanceiro, sy-uline.
        ls_estfinanceiro_tab = CORRESPONDING #( ls_estruturafinanceiro ).
        MODIFY zt02_financeiro FROM ls_estfinanceiro_tab.
      ENDLOOP.
    ENDIF.

    MESSAGE 'Arquivo carregado com sucesso!' TYPE 'S'.

  ELSE.
    MESSAGE 'A entrada de um arquivo é obrigatória.' TYPE 'S'.
  ENDIF.
