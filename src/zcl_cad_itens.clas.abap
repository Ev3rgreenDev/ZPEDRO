class ZCL_CAD_ITENS definition
  public
  create public .

public section.

  methods VALIDATE_MATNR
    importing
      !IV_MATNR_FIM type ZE_MATNR
      !IV_QTD_COMP type ZE_QTY3 .
  methods GET_ITENS
    changing
      !EV_POS type ZE_POS .
  methods SET_ITENS
    importing
      !IV_BOM_ID type ZE_BOM_ID
      !EV_POS type ZE_POS
      !IV_MATNR_COMP type ZE_MATNR
      !IV_QTD_COMP type ZE_QTY3
      !IV_UNID type ZE_UNID
    exporting
      !WA_ZBOM_I type ZBOM_I .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CAD_ITENS IMPLEMENTATION.


  METHOD get_itens.

    SELECT MAX( pos )
      FROM zbom_i
      INTO @DATA(lv_pos).

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'MAX POS'.
    ENDIF.

    ev_pos = lv_pos + 1.

  ENDMETHOD.


  METHOD set_itens.

    MOVE iv_bom_id     TO wa_zbom_i-bom_id.
    MOVE ev_pos        TO wa_zbom_i-pos.
    MOVE iv_matnr_comp TO wa_zbom_i-matnr_comp.
    MOVE iv_qtd_comp   TO wa_zbom_i-qtd_comp.
    MOVE iv_unid       TO wa_zbom_i-unid.

    wa_zbom_i-pos = |{ wa_zbom_i-pos ALPHA = IN }|.

    INSERT zbom_i FROM wa_zbom_i.

  ENDMETHOD.


  method VALIDATE_MATNR.

    SELECT SINGLE matnr_fim
      FROM zbom_h
      INTO @data(lv_matnr)
      WHERE matnr_fim = @iv_matnr_fim.

      IF sy-subrc ne 0.
        MESSAGE e002(zpedro)
          WITH 'de materiais'.
      ENDIF.

      IF iv_qtd_comp LE 0.
        MESSAGE e014(zpedro).
      ENDIF.

  endmethod.
ENDCLASS.
