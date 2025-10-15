class ZCL_CAD_BOM definition
  public
  final
  create public .

public section.

  class-data WA_ZBOM_H type ZBOM_H .
  data IV_MATNR type ZE_MATNR .
  data IV_QTD_BASE type ZE_QTY3 .

  methods VALIDATE_DATA
    importing
      !IV_MATNR type ZE_MATNR
      !IV_QTD_BASE type ZE_QTY3
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods SET_BOM
    importing
      !IV_MATNR type ZE_MATNR
      !IV_QTD_BASE type ZE_QTY3
      !IV_ATIVO type ZE_FLAG
    exporting
      !ES_WABOM type ZBOM_H .
  methods UPDATE_BOM
    importing
      !IV_BOM_ID type ZE_BOM_ID
      !IV_MATNR type ZE_MATNR
      !IV_QTD_BASE type ZE_QTY3
      !IV_ATIVO type ZE_FLAG
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods DELETE_BOM
    importing
      !IV_BOM_ID type ZE_BOM_ID
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods GET_BOM
    importing
      !IT_BOM_ID type /IWBEP/T_COD_SELECT_OPTIONS
      !IT_MATNR_FIM type /IWBEP/T_COD_SELECT_OPTIONS
      !IT_QTD_BASE type /IWBEP/T_COD_SELECT_OPTIONS
      !IT_ATIVO type /IWBEP/T_COD_SELECT_OPTIONS
    returning
      value(RT_ZBOM_H) type ZTT_ZBOM_H .
  methods GET_BOM_WITH_STRING
    importing
      !IV_FIELDS type STRING
    returning
      value(RT_ZBOM_H) type ZTT_ZBOM_H .
  methods GET_BOM_SINGLE
    importing
      !IV_BOM_ID type ZE_BOM_ID
    exporting
      !ET_MESSAGE type ZTT_MESSAGE
    returning
      value(RS_ZBOM_H) type ZBOM_H .
  methods CREATE_DEEP_ENTITY
    changing
      !CS_BOM type ZBOM_H
      !CT_ITENS type ZTTT_ZBOM_I
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
protected section.
private section.

  constants GC_ZPEDRO type SY-MSGID value 'ZPEDRO' ##NO_TEXT.

  methods GET_BOM_ID
    returning
      value(RV_BOM_ID) type ZE_BOM_ID .
  methods MESSAGE_BUILDER
    importing
      !IV_MSGID type SYST_MSGID
      !IV_MSGNO type SYST_MSGNO
      !IV_MSGV1 type SYST_MSGV optional
      !IV_MSGV2 type SYST_MSGV optional
      !IV_MSGV3 type SYST_MSGV optional
      !IV_MSGV4 type SYST_MSGV optional
    changing
      !CT_MESSAGES type ZTT_MESSAGE .
  methods VALIDATE_BOM_UPDATE
    importing
      !IV_BOM_ID type ZE_BOM_ID
      !IV_MATNR type ZE_MATNR
      !IV_QTD_BASE type ZE_QTY3
    changing
      value(CT_MESSAGE) type ZTT_MESSAGE .
  methods VALIDATE_BOM
    importing
      !IV_BOM_ID type ZE_BOM_ID
    changing
      value(CT_MESSAGE) type ZTT_MESSAGE .
  methods VALIDATE_DEEP_ENTITY
    importing
      !IS_BOM type ZBOM_H
      !IT_ITENS type ZTTT_ZBOM_I
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods GET_POS_ITENS
    exporting
      !ET_MESSAGE type ZTT_MESSAGE
    returning
      value(RV_POS) type ZE_POS .
ENDCLASS.



CLASS ZCL_CAD_BOM IMPLEMENTATION.


  METHOD set_bom.

    DATA: ls_bom TYPE zbom_h.

    ls_bom-bom_id = get_bom_id( ).
    MOVE iv_matnr    TO ls_bom-matnr_fim.
    MOVE iv_qtd_base TO ls_bom-qtd_base.
    MOVE iv_ativo    TO ls_bom-ativo.

    INSERT zbom_h FROM ls_bom.

    IF sy-subrc EQ 0.
      SELECT SINGLE *
        FROM zbom_h
        INTO es_wabom
        WHERE bom_id = ls_bom-bom_id.
    ENDIF.

  ENDMETHOD.


  METHOD VALIDATE_BOM.

    DATA: lc_zpedro TYPE sy-msgid VALUE 'ZPEDRO'.

    SELECT SINGLE bom_id
      FROM zbom_h
      INTO @DATA(lv_matnr_fim)
      WHERE bom_id = @iv_bom_id.

    IF sy-subrc NE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = lc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de bom_id'
        CHANGING
          ct_messages = ct_message
      ).

    ENDIF.

  ENDMETHOD.


  METHOD delete_bom.

    me->validate_bom(
      EXPORTING
        iv_bom_id  = iv_bom_id
      CHANGING
        ct_message = rt_message
    ).

    DATA: lc_zpedro TYPE sy-msgid VALUE 'ZPEDRO'.

    DELETE zbom_h FROM @( VALUE #( bom_id = iv_bom_id ) ).

    IF sy-subrc NE 0.

      me->message_builder(
         EXPORTING
           iv_msgid    = lc_zpedro
           iv_msgno    = 024
           iv_msgv1    = 'ZBOM_H'
         CHANGING
           ct_messages = rt_message
      ).

    ENDIF.

  ENDMETHOD.


  METHOD get_bom.

    SELECT *
      FROM zbom_h
      INTO TABLE rt_zbom_h
      WHERE bom_id    IN it_bom_id
        AND matnr_fim IN it_matnr_fim
        AND qtd_base  IN it_qtd_base
        AND ativo     IN it_ativo.

  ENDMETHOD.


  METHOD get_bom_id.

    SELECT MAX( bom_id )
      FROM zbom_h
      INTO @DATA(lv_bom_id).

    IF sy-subrc NE 0.
      MESSAGE e002(zpedro)
        WITH 'MAX BOM_ID'.
    ENDIF.

    lv_bom_id = lv_bom_id + 1.
    rv_bom_id = |{ lv_bom_id ALPHA = IN }|.

  ENDMETHOD.


  METHOD get_bom_single.

    me->validate_bom(
      EXPORTING
        iv_bom_id  = iv_bom_id
      CHANGING
        ct_message = et_message
    ).

    SELECT SINGLE *
      FROM zbom_h
      INTO rs_zbom_h
      WHERE bom_id = iv_bom_id.

  ENDMETHOD.


  METHOD get_bom_with_string.

    DATA: lv_fields TYPE string.

    lv_fields = iv_fields.

    REPLACE 'BomId'    IN lv_fields WITH 'bom_id'.
    REPLACE 'MatnrFim' IN lv_fields WITH 'matnr_fim'.
    REPLACE 'QtdBase'  IN lv_fields WITH 'qtd_base'.


    SELECT *
      FROM zbom_h
      INTO TABLE rt_zbom_h
      WHERE (lv_fields).

  ENDMETHOD.


  METHOD message_builder.

    DATA: lv_message TYPE string.

    CALL FUNCTION 'FORMAT_MESSAGE'
      EXPORTING
        id        = iv_msgid
*       lang      = '-D'
        no        = iv_msgno
        v1        = iv_msgv1
        v2        = iv_msgv2
        v3        = iv_msgv3
        v4        = iv_msgv4
      IMPORTING
        msg       = lv_message
      EXCEPTIONS
        not_found = 1
        OTHERS    = 2.

    APPEND VALUE #(
      text           = lv_message
      message_id     = iv_msgid
      message_number = iv_msgno
      msgv1          = iv_msgv1
      msgv2          = iv_msgv2
      msgv3          = iv_msgv3
      msgv4          = iv_msgv4
    ) TO ct_messages.

  ENDMETHOD.


  METHOD update_bom.

    me->validate_bom_update(
      EXPORTING
        iv_bom_id   = iv_bom_id
        iv_matnr    = iv_matnr
        iv_qtd_base = iv_qtd_base
      CHANGING
        ct_message  = rt_message
    ).

    DATA: lc_zpedro TYPE sy-msgid VALUE 'ZPEDRO'.

    UPDATE zbom_h
    SET matnr_fim = @iv_matnr,
        qtd_base  = @iv_qtd_base,
        ativo     = @iv_ativo
    WHERE bom_id  = @iv_bom_id.

    IF sy-subrc NE 0.

      me->message_builder(
         EXPORTING
           iv_msgid    = lc_zpedro
           iv_msgno    = 003
           iv_msgv1    = 'ZBOM_H'
         CHANGING
           ct_messages = rt_message
      ).

    ENDIF.
  ENDMETHOD.


  METHOD VALIDATE_BOM_UPDATE.

    DATA: lc_zpedro TYPE sy-msgid VALUE 'ZPEDRO'.

    SELECT SINGLE bom_id
      FROM zbom_h
      INTO @DATA(lv_matnr_fim)
      WHERE bom_id = @iv_bom_id.

    IF sy-subrc NE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = lc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de bom_id'
        CHANGING
          ct_messages = ct_message
      ).

    ENDIF.

    SELECT SINGLE matnr
     FROM zmat
     INTO @DATA(lv_matnr_check)
     WHERE matnr = @iv_matnr.

    IF sy-subrc NE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = lc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de materiais'
        CHANGING
          ct_messages = ct_message
      ).

    ENDIF.

    IF iv_qtd_base LE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = lc_zpedro
          iv_msgno    = 014
        CHANGING
          ct_messages = ct_message
      ).

    ENDIF.

  ENDMETHOD.


  METHOD validate_data.

    DATA: lc_zpedro TYPE sy-msgid VALUE 'ZPEDRO'.

    SELECT SINGLE matnr
     FROM zmat
     INTO @DATA(lv_matnr_check)
     WHERE matnr = @iv_matnr.

    IF sy-subrc NE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = lc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de materiais'
        CHANGING
          ct_messages = rt_message
      ).

    ENDIF.

    IF iv_qtd_base LE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = lc_zpedro
          iv_msgno    = 014
        CHANGING
          ct_messages = rt_message
      ).

    ENDIF.

  ENDMETHOD.


  METHOD create_deep_entity.

    DATA: ls_itens TYPE zbom_i.

    rt_message = validate_deep_entity(
                   is_bom   = cs_bom
                   it_itens = ct_itens
                 ).

    IF rt_message IS INITIAL.

      cs_bom-bom_id = get_bom_id( ).

      INSERT zbom_h FROM cs_bom.

      IF sy-subrc NE 0.
        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 000
            iv_msgv1    = 'ZBOM_H'
          CHANGING
            ct_messages = rt_message
        ).
      ELSE.

        LOOP AT ct_itens ASSIGNING FIELD-SYMBOL(<fs_item>).

          <fs_item>-pos = get_pos_itens(
                         IMPORTING
                           et_message = rt_message
                       ).

          IF rt_message IS NOT INITIAL.
            EXIT.
          ELSE.

            MOVE cs_bom-bom_id    TO <fs_item>-bom_id.
            MOVE cs_bom-matnr_fim TO <fs_item>-matnr_comp.

          ENDIF.
        ENDLOOP.

        INSERT zbom_i FROM TABLE ct_itens.

        IF sy-subrc NE 0.
          zcl_message_builder=>message_builder(
            EXPORTING
              iv_msgid    = gc_zpedro
              iv_msgno    = 000
              iv_msgv1    = 'ZBOM_H'
            CHANGING
              ct_messages = rt_message
          ).
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_pos_itens.

    SELECT MAX( pos )
      FROM zbom_i
      INTO @DATA(lv_pos).

    IF sy-subrc NE 0.

      zcl_message_builder=>message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'MAX POS'
        CHANGING
          ct_messages = et_message
      ).
    ENDIF.

    lv_pos = lv_pos + 1.
    rv_pos = |{ lv_pos ALPHA = IN }|.

  ENDMETHOD.


  METHOD validate_deep_entity.

    DATA: ls_itens TYPE zbom_i.

    SELECT SINGLE matnr
      FROM zmat
      INTO @DATA(lv_matnr)
      WHERE matnr = @is_bom-matnr_fim.

    IF sy-subrc NE 0.

      zcl_message_builder=>message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de Materiais'
        CHANGING
          ct_messages = rt_message
      ).

    ELSEIF is_bom-qtd_base LE 0.

      zcl_message_builder=>message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 014
        CHANGING
          ct_messages = rt_message
      ).

    ELSE.

      LOOP AT it_itens INTO ls_itens.

        IF ls_itens-qtd_comp LE 0.

          zcl_message_builder=>message_builder(
            EXPORTING
              iv_msgid    = gc_zpedro
              iv_msgno    = 014
            CHANGING
              ct_messages = rt_message
          ).
        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
