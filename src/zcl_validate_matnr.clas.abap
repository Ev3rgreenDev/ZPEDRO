class ZCL_VALIDATE_MATNR definition
  public
  final
  create public .

public section.

  methods VALIDATE
    importing
      !IV_TABLE type STRING
      !IV_CAMPO type STRING
      !IV_MATNR type ZE_MATNR
      !IV_EXIST type STRING
    exporting
      !ET_TABLE type ANY TABLE .
protected section.
private section.
ENDCLASS.



CLASS ZCL_VALIDATE_MATNR IMPLEMENTATION.


  METHOD validate.

    data(lt_where) = iv_campo && | = | && 'p_matnr'.

    SELECT *
      FROM (iv_table)
      INTO TABLE et_table
      WHERE (lt_where).

    IF iv_exist = 's'.
      IF sy-subrc NE 0.
        MESSAGE e002(zpedro)
          WITH 'de material'.
      ENDIF.

    ELSEIF iv_exist = 'n'.
      IF sy-subrc EQ 0.
        MESSAGE e023(zpedro).
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
