class ZCL_CAD_ITENS definition
  public
  create public .

public section.

  methods SET_ITEMS
    importing
      !IV_BOM_ID type ZE_BOM_ID
      !IV_QTD_COMP type ZE_QTY3
      !IV_UNID type ZE_UNID
    exporting
      !ES_ZBOM_I type ZBOM_I
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods UPDATE_ITENS
    importing
      !IV_BOM_ID type ZE_BOM_ID optional
      !IV_POS type ZE_POS optional
      !IV_QTD_COMP type ZE_QTY3 optional
      !IV_UNID type ZE_UNID optional
      !IS_FIELDS type ZST_ZBOM_I
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods DELETE_ITENS
    importing
      !IV_BOM_ID type ZE_BOM_ID
      !IV_POS type ZE_POS
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods GET_ITENS_WITH_STRING
    importing
      !IV_FIELDS type STRING
    returning
      value(RT_ZBOM_I) type ZTTT_ZBOM_I .
  methods GET_ITENS_SINGLE
    importing
      !IV_BOM_ID type ZE_BOM_ID
      !IV_POS type ZE_POS
    exporting
      value(ET_MESSAGE) type ZTT_MESSAGE
    returning
      value(RS_ZBOM_I) type ZBOM_I .
protected section.
private section.

  constants GC_ZPEDRO type SY-MSGID value 'ZPEDRO' ##NO_TEXT.

  methods VALIDATE_DATA
    importing
      !IV_BOM_ID type ZE_BOM_ID
      !IV_QTD_COMP type ZE_QTY3
      !IV_UNID type ZE_UNID
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods GET_ITEMS
    importing
      !IV_BOM_ID type ZE_BOM_ID
    exporting
      !EV_POS type ZE_POS
      !ET_MESSAGE type ZTT_MESSAGE
      !EV_MATNR_FIM type ZE_MATNR .
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
  methods GET_FIELDS_UPDATE
    importing
      !IS_FIELDS type ZST_ZBOM_I
    returning
      value(RV_FIELDS) type STRING .
  methods VALIDATE_ITENS_UPDATE
    importing
      !IV_BOM_ID type ZE_BOM_ID
      !IV_POS type ZE_POS
      !IV_QTD_COMP type ZE_QTY3
      !IV_UNID type ZE_UNID
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods VALIDATE_ITENS
    importing
      !IV_BOM_ID type ZE_BOM_ID
      !IV_POS type ZE_POS
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
ENDCLASS.



CLASS ZCL_CAD_ITENS IMPLEMENTATION.


  METHOD delete_itens.

    rt_message = me->validate_itens(
      EXPORTING
        iv_bom_id  = iv_bom_id
        iv_pos     = iv_pos
     ).

    IF rt_message IS INITIAL.

*      DELETE zbom_i FROM @( VALUE #( bom_id = iv_bom_id pos = iv_pos ) ).

      DELETE FROM zbom_i WHERE bom_id = iv_bom_id AND pos = iv_pos.

      IF sy-subrc NE 0.

        me->message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 024
            iv_msgv1    = 'de Itens'
          CHANGING
            ct_messages = rt_message
        ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_fields_update.

    DATA: lv_separator TYPE string.

      IF is_fields-matnr_comp IS NOT INITIAL.

        rv_fields = |matnr_comp = | && |'| && is_fields-matnr_comp && |'|.
        lv_separator = |, |.

      ENDIF.

      IF is_fields-qtd_comp IS NOT INITIAL.
        rv_fields = rv_fields && lv_separator && |qtd_comp = | && |'| && is_fields-qtd_comp && |'|.
        lv_separator = |, |.
      ENDIF.

      IF is_fields-unid IS NOT INITIAL.

        rv_fields = rv_fields && lv_separator && |unid = | && |'| && is_fields-unid && |'|.

      ENDIF.

  ENDMETHOD.


  METHOD get_items.

    SELECT MAX( pos )
      FROM zbom_i
      INTO @DATA(lv_pos).

    IF sy-subrc NE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'MAX POS'
        CHANGING
          ct_messages = et_message
      ).
    ENDIF.

    lv_pos = lv_pos + 1.
    ev_pos = |{ lv_pos ALPHA = IN }|.


    SELECT SINGLE matnr_fim
      FROM zbom_h
      INTO @DATA(lv_matnr_fim)
      WHERE bom_id = @iv_bom_id.

    IF sy-subrc EQ 0.
      ev_matnr_fim = lv_matnr_fim.

    ELSE.

      me->message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de materiais'
        CHANGING
          ct_messages = et_message
  ).
    ENDIF.

  ENDMETHOD.


  METHOD get_itens_single.

    SELECT SINGLE *
      FROM zbom_i
      INTO rs_zbom_i
      WHERE bom_id = iv_bom_id
      AND   pos    = iv_pos.

    IF sy-subrc NE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de Itens'
        CHANGING
          ct_messages = et_message
      ).
    ENDIF.

  ENDMETHOD.


  METHOD get_itens_with_string.

    DATA: lv_fields TYPE string.

    lv_fields = iv_fields.

    REPLACE 'BomId'     IN lv_fields WITH 'bom_id'.
    REPLACE 'MatnrComp' IN lv_fields WITH 'matnr_comp'.
    REPLACE 'QtdComp'   IN lv_fields WITH 'qtd_comp'.

    SELECT *
      FROM zbom_i
      INTO TABLE rt_zbom_i
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


  METHOD set_items.

    DATA: ls_itens TYPE zbom_i.

    me->validate_data(
      EXPORTING
        iv_bom_id   = iv_bom_id
        iv_qtd_comp = iv_qtd_comp
        iv_unid     = iv_unid
      RECEIVING
        rt_message  = rt_message
    ).

    IF rt_message IS INITIAL.

      me->get_items(
        EXPORTING
          iv_bom_id    = iv_bom_id
        IMPORTING
          ev_pos       = ls_itens-pos
          et_message   = rt_message
          ev_matnr_fim = ls_itens-matnr_comp
      ).

      IF rt_message IS INITIAL.

        MOVE iv_bom_id     TO ls_itens-bom_id.
        MOVE iv_qtd_comp   TO ls_itens-qtd_comp.
        MOVE iv_unid       TO ls_itens-unid.

        INSERT zbom_i FROM ls_itens.

        IF sy-subrc EQ 0.

          es_zbom_i = ls_itens.

        ELSE.

          me->message_builder(
            EXPORTING
              iv_msgid    = gc_zpedro
              iv_msgno    = 002
              iv_msgv1    = 'de BOM_ID'
            CHANGING
              ct_messages = rt_message
          ).

        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD update_itens.

    DATA: lv_fields TYPE string.

    me->validate_itens_update(
      EXPORTING
        iv_bom_id   = iv_bom_id
        iv_pos      = iv_pos
        iv_qtd_comp = iv_qtd_comp
        iv_unid     = iv_unid
      RECEIVING
        rt_message  = rt_message
    ).

    IF rt_message IS INITIAL.

      lv_fields = me->get_fields_update( is_fields = is_fields ).

      UPDATE zbom_i
      SET (lv_fields)
      WHERE bom_id = @iv_bom_id
      AND   pos    = @iv_pos.

      IF sy-subrc NE 0.

        me->message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 003
            iv_msgv1    = 'de Itens'
          CHANGING
            ct_messages = rt_message
        ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD validate_data.

    SELECT SINGLE bom_id
      FROM zbom_h
      INTO @DATA(lv_bom_id_h)
      WHERE bom_id = @iv_bom_id.

    IF sy-subrc NE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de BOM_ID'
        CHANGING
          ct_messages = rt_message
      ).

    ENDIF.

    SELECT SINGLE bom_id
      FROM zbom_i
      INTO @DATA(lv_bom_id_i)
      WHERE bom_id = @iv_bom_id.

    IF sy-subrc EQ 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 022
          iv_msgv1    = 'BOM_ID'
          iv_msgv2    = 'de Itens'
        CHANGING
          ct_messages = rt_message
      ).

    ENDIF.


    IF iv_qtd_comp IS INITIAL OR iv_qtd_comp LE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 014
        CHANGING
          ct_messages = rt_message
      ).

    ENDIF.

    IF iv_unid IS INITIAL.

      me->message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 025
          iv_msgv1    = 'de Unidade'
        CHANGING
          ct_messages = rt_message
      ).

    ELSEIF iv_unid IS NOT INITIAL.

      SELECT SINGLE msehi
       FROM t006
       INTO @DATA(lv_unid)
       WHERE msehi = @iv_unid.

      IF sy-subrc NE 0.

        me->message_builder(
      EXPORTING
        iv_msgid    = gc_zpedro
        iv_msgno    = 026
        iv_msgv1    = 'campo de unid'
        iv_msgv2    = 'T006'
      CHANGING
        ct_messages = rt_message
    ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD validate_itens.

    SELECT SINGLE bom_id
      FROM zbom_i
      INTO @DATA(lv_check)
      WHERE bom_id = @iv_bom_id
      AND   pos    = @iv_pos.

      IF sy-subrc NE 0.
        me->message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 002
            iv_msgv1    = 'de Itens'
          CHANGING
            ct_messages = rt_message
        ).
      ENDIF.

  ENDMETHOD.


  METHOD validate_itens_update.

    SELECT SINGLE bom_id
      FROM zbom_i
      INTO @DATA(lv_bom_id_i)
      WHERE bom_id = @iv_bom_id
        AND pos    = @iv_pos.

    IF sy-subrc NE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de BOM_ID'
        CHANGING
          ct_messages = rt_message
      ).
    ENDIF.

    IF iv_qtd_comp IS NOT INITIAL AND iv_qtd_comp LE 0.

      me->message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 014
        CHANGING
          ct_messages = rt_message
      ).
    ENDIF.

    IF iv_unid IS NOT INITIAL.

      SELECT SINGLE msehi
       FROM t006
       INTO @DATA(lv_unid)
       WHERE msehi = @iv_unid.

      IF sy-subrc NE 0.

        me->message_builder(
      EXPORTING
        iv_msgid    = gc_zpedro
        iv_msgno    = 026
        iv_msgv1    = 'campo de unid'
        iv_msgv2    = 'T006'
      CHANGING
        ct_messages = rt_message
    ).
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
