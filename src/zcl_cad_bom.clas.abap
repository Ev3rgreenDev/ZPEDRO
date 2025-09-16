class ZCL_CAD_BOM definition
  public
  final
  create public .

public section.

  class-data WA_ZBOM_H type ZBOM_H .
  data IV_MATNR type ZE_MATNR .
  data IV_QTD_BASE type ZE_QTY3 .

  methods GET_BOM
    changing
      value(EV_BOM_ID) type ZE_BOM_ID .
  methods VALIDATE_BOM
    importing
      !IV_MATNR type ZE_MATNR
      !IV_QTD_BASE type ZE_QTY3 .
  methods SET_BOM
    importing
      !IV_MATNR type ZE_MATNR
      !IV_QTD_BASE type ZE_QTY3
      !IV_ATIVO type ZE_FLAG
      !EV_BOM_ID type ZE_BOM_ID
    exporting
      !WA_ZBOM_H type ZBOM_H .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CAD_BOM IMPLEMENTATION.


  METHOD get_bom.

    SELECT MAX( bom_id )
      FROM zbom_h
      INTO @DATA(lv_bom_id).

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'MAX BOM_ID'.
    ENDIF.

    ev_bom_id   = lv_bom_id + 1.

  ENDMETHOD.


  METHOD set_bom.

    MOVE ev_bom_id   TO wa_zbom_h-bom_id.
    MOVE iv_matnr    TO wa_zbom_h-matnr_fim.
    MOVE iv_qtd_base TO wa_zbom_h-qtd_base.
    MOVE iv_ativo    TO wa_zbom_h-ativo.

    wa_zbom_h-bom_id = |{ wa_zbom_h-bom_id alpha = in }|.

    INSERT zbom_h FROM wa_zbom_h.

  ENDMETHOD.


  METHOD validate_bom.

    SELECT SINGLE matnr
      FROM zmat
      INTO @DATA(lv_matnr_check)
      WHERE matnr = @iv_matnr.

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'de materiais'.
    ENDIF.

    SELECT SINGLE matnr_fim
      FROM zbom_h
      INTO @DATA(lv_matnr_fim)
      WHERE matnr_fim = @iv_matnr.

    IF sy-subrc EQ 0.
      MESSAGE e021(zpedro).

    ENDIF.

    IF iv_qtd_base LE 0.
      MESSAGE e014(zpedro).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
