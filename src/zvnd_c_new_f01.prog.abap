*&---------------------------------------------------------------------*
*& Include          ZVND_C_NEW_F01
*&---------------------------------------------------------------------*

CLASS lcl_report DEFINITION.
  PUBLIC SECTION.
* Methods to Fetch Data and Display Output
    METHODS:
      valida
        CHANGING
          p_data_f TYPE dats,

      set_fields
        CHANGING
          gv_campos TYPE string,

      get_data,                             "Data Selection
      display_output,                       "Display Output
      display_alv                           "Display ALV
        IMPORTING
          container_name TYPE c
        CHANGING
          i_data         TYPE STANDARD TABLE.

* Method to Set PF-Status
    METHODS: set_pf_status
      CHANGING
        co_salv TYPE REF TO cl_salv_table. " Default Pf Status

ENDCLASS.

CLASS lcl_report IMPLEMENTATION.

  METHOD valida.

    IF p_vbeln IS NOT INITIAL.

      SELECT SINGLE vbeln
        FROM zvnd_h
        INTO @DATA(lv_p_vbeln)
        WHERE vbeln = @p_vbeln.

      IF sy-subrc NE 0.
        MESSAGE e002(zpedro)
          WITH 'do pedido'.
      ENDIF.
    ENDIF.

    IF p_custid IS NOT INITIAL.

      SELECT SINGLE custid
        FROM zvnd_h
        INTO @DATA(lv_custid)
        WHERE custid = @p_custid.

      IF sy-subrc NE 0.
        MESSAGE e002(zpedro)
          WITH 'de clientes do pedido'.
      ENDIF.
    ENDIF.

    IF p_data_f IS INITIAL.

      p_data_f = sy-datum.

    ENDIF.

    IF p_data_i GT p_data_f.
      MESSAGE e020(zpedro).
    ENDIF.

    IF p_status IS NOT INITIAL.

      SELECT SINGLE status
        FROM zvnd_h
        INTO @DATA(lv_status)
        WHERE status = @p_status.

      IF sy-subrc NE 0.
        MESSAGE e002(zpedro)
          WITH 'de status do pedido'.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD set_fields.

    IF p_vbeln IS NOT INITIAL.
      gv_campos = 'VBELN = p_vbeln'.
    ENDIF.

    IF p_custid IS NOT INITIAL.
      gv_campos = gv_campos && ' AND CUSTID = p_custid'.
    ENDIF.

    IF p_data_i IS NOT INITIAL OR p_data_f IS NOT INITIAL.
      gv_campos = gv_campos && ' AND DATA_DOC GE p_data_i AND DATA_DOC LE p_data_f'.
    ENDIF.

    IF p_status IS NOT INITIAL.
      gv_campos = gv_campos && ' AND STATUS = p_status'.
    ENDIF.
  ENDMETHOD.

* Data selection
  METHOD get_data.
    SELECT *
    FROM zvnd_h
    INTO TABLE gt_zvnd_h
    WHERE (gv_campos).

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'da tabela de pedidos'.
    ENDIF.

    SELECT *
      FROM zvnd_i
      INTO TABLE gt_zvnd_i
      FOR ALL ENTRIES IN gt_zvnd_h
      WHERE vbeln = gt_zvnd_h-vbeln.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'da tabela de itens'.
    ENDIF.
  ENDMETHOD.                    "get_data

* Display ALV
  METHOD display_alv.

*   Instantiate the container
    CREATE OBJECT go_container
      EXPORTING
        container_name              = container_name
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
*    Raise exception
    ENDIF.

* Call Factory method which will give back the ALV object reference.
    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            r_container  = go_container "****Pass container object to cl_salv_table***
          IMPORTING
            r_salv_table = go_alv
          CHANGING
            t_table      = i_data.
      CATCH cx_salv_msg INTO gv_message .
    ENDTRY.

*   Set PF status
    CALL METHOD set_pf_status
      CHANGING
        co_salv = go_alv.

* Display the ALV
    go_alv->display( ).
  ENDMETHOD.                    "display_ALV

* Display Output
  METHOD display_output.

*  Call ALV display method and pass the Container name and internal table
***Display ALV1***
    display_alv(
       EXPORTING
         container_name = 'CONTAINER1'
       CHANGING
         i_data           = gt_zvnd_h ).

**Display ALV2***
    display_alv(
       EXPORTING
         container_name = 'CONTAINER2'
       CHANGING
         i_data           = gt_zvnd_i ).

  ENDMETHOD.                    "display_ALV
************************************************************************
*    Method Implementation
************************************************************************
* Setting the PF-Status
  METHOD set_pf_status.
    DATA: lo_functions TYPE REF TO cl_salv_functions_list.
* Default functions
    lo_functions = co_salv->get_functions( ).
    lo_functions->set_all( abap_true ).
  ENDMETHOD.                    "set_pf_status
ENDCLASS.                    "lcl_report IMPLEMENTATION

MODULE status_100 OUTPUT.
  SET PF-STATUS 'ZSTATUS'.
  SET TITLEBAR 'TITLE'.
ENDMODULE.                 " STATUS_0100  OUTPUT
