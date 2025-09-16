class ZCL_DISPLAY_ALV definition
  public
  create public .

public section.

  data GO_CONTAINER type ref to CL_GUI_CUSTOM_CONTAINER .
  data GO_ALV type ref to CL_SALV_TABLE .
  data CV_MESSAGE type ref to CX_SALV_MSG .
  data GV_CONTAINER_NAME type C .

  methods GET_DATA
    importing
      !IV_TABLE_NAME type STRING
      !IV_PARAMETERS type ZE_BOM_ID
    exporting
      !ET_ITAB type ANY TABLE .
  methods DISPLAY_ALV
    importing
      !IO_CONTAINER type ref to CL_GUI_CUSTOM_CONTAINER
    changing
      !CT_DATA type STANDARD TABLE
    returning
      value(RV_MESSAGE) type STRING .
  methods DISPLAY_OUTPUT
    importing
      !IV_CONTAINER_NAME type C
    changing
      !CT_ITAB type ANY TABLE .
  methods GET_DATA2
    importing
      !IV_TABLE_NAME type STRING
    exporting
      value(ET_ITAB) type ANY TABLE .
protected section.
private section.

  methods GET_CONTAINER
    importing
      !IV_CONTAINER_NAME type C
    returning
      value(RO_CONTAINER) type ref to CL_GUI_CUSTOM_CONTAINER .
ENDCLASS.



CLASS ZCL_DISPLAY_ALV IMPLEMENTATION.


  METHOD display_alv.

    TRY.
        CALL METHOD cl_salv_table=>factory
          EXPORTING
            r_container  = go_container
          IMPORTING
            r_salv_table = go_alv
          CHANGING
            t_table      = ct_data.
      CATCH cx_salv_msg.
        MESSAGE e001(zpedro).
    ENDTRY.

* Display the ALV
    go_alv->display( ).

  ENDMETHOD.


  METHOD display_output.

    display_alv(
    EXPORTING
      io_container = me->get_container( iv_container_name = iv_container_name )
      CHANGING
        ct_data = ct_itab
    ).

  ENDMETHOD.


  METHOD get_container.

    CREATE OBJECT go_container
      EXPORTING
        container_name              = iv_container_name
      EXCEPTIONS
        cntl_error                  = 1
        cntl_system_error           = 2
        create_error                = 3
        lifetime_error              = 4
        lifetime_dynpro_dynpro_link = 5
        OTHERS                      = 6.
    IF sy-subrc <> 0.
      MESSAGE e021(zpedro)
        WITH 'container'.
    ENDIF.

  ENDMETHOD.


  METHOD get_data.

    SELECT *
      FROM (iv_table_name)
      INTO TABLE et_itab
      WHERE BOM_ID = iv_parameters.

  ENDMETHOD.


  METHOD get_data2.

    SELECT *
      FROM (iv_table_name)
      INTO TABLE et_itab.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'BOM'.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
