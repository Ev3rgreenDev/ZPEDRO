class ZCL_STOCK definition
  public
  final
  create public .

public section.

  methods GET_MATERIAL
    importing
      !IV_FIELDS type STRING
    returning
      value(RT_ITAB_ZMAT) type ZTT_ZMAT .
  methods CREATE_MATERIAL
    importing
      !IV_MATNR type ZE_MATNR
      !IV_DESCR type ZE_DESCR
      !IV_UNID type ZE_UNID
      !IV_ATIVO type ZE_FLAG
    exporting
      !ET_MESSAGE type ZTT_MESSAGE
    returning
      value(RS_ITAB_ZMAT) type ZMAT .
  methods UPDATE_MATERIAL
    importing
      !IS_FIELDS type ZMAT
    exporting
      !ET_MESSAGE type ZTT_MESSAGE
    returning
      value(RS_ZMAT) type ZMAT .
  methods DELETE_MATERIAL
    importing
      !IV_MATNR type ZE_MATNR
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods GET_SINGLE_MATERIAL
    importing
      !IV_MATNR type ZE_MATNR
    changing
      !CT_MESSAGE type ZTT_MESSAGE
    returning
      value(RS_ITAB_ZMAT) type ZMAT .
protected section.
private section.

  constants GC_ZPEDRO type SY-MSGID value 'ZPEDRO' ##NO_TEXT.
  data GV_FIELDS type STRING .

  methods GET_FIELDS_UPDATE
    importing
      !IS_FIELDS type ZMAT
    returning
      value(RV_FIELDS) type STRING .
  methods VALIDATE_MATERIAL
    importing
      !IV_MATNR type ZE_MATNR
      !IV_MATNR_EQ type BOOLEAN
      !IV_UNID type ZE_UNID optional
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
ENDCLASS.



CLASS ZCL_STOCK IMPLEMENTATION.


  METHOD create_material.

    me->validate_material(
      EXPORTING
        iv_matnr    = iv_matnr
        iv_unid     = iv_unid
        iv_matnr_eq = abap_true
      RECEIVING
        rt_message  = et_message
    ).

    IF et_message IS INITIAL.

      MOVE iv_matnr TO rs_itab_zmat-matnr.
      MOVE iv_descr TO rs_itab_zmat-descr.
      MOVE iv_unid  TO rs_itab_zmat-unid.
      MOVE iv_ativo TO rs_itab_zmat-ativo.

      INSERT zmat FROM rs_itab_zmat.

      IF sy-subrc NE 0.

        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 000
            iv_msgv1    ='de Materiais'
          CHANGING
            ct_messages = et_message
        ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD delete_material.

    me->validate_material(
      EXPORTING
        iv_matnr    = iv_matnr
        iv_matnr_eq = abap_false
      RECEIVING
        rt_message  = rt_message
    ).

    IF rt_message IS INITIAL.

      DELETE FROM zmat WHERE matnr = iv_matnr.

      IF sy-subrc NE 0.

        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 024
            iv_msgv1    = 'de Materiais'
          CHANGING
            ct_messages = rt_message
        ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_fields_update.

    DATA: lv_separator TYPE string.

    IF is_fields-descr IS NOT INITIAL.
      rv_fields = |descr = | && |'| && is_fields-descr && |'|.
      lv_separator = |, |.
    ENDIF.

    IF is_fields-unid IS NOT INITIAL.
      rv_fields = rv_fields && lv_separator && |unid = | && |'| && is_fields-unid && |'|.
      lv_separator = |, |.
    ENDIF.

    IF is_fields-ativo IS NOT INITIAL.
      rv_fields = rv_fields && lv_separator && |ativo = | && |'| && is_fields-ativo && |'|.
    ENDIF.

  ENDMETHOD.


  METHOD get_material.

    gv_fields = iv_fields.

    SELECT *
      FROM zmat
      INTO TABLE rt_itab_zmat
      WHERE (gv_fields).

  ENDMETHOD.


  METHOD get_single_material.

    me->validate_material(
      EXPORTING
        iv_matnr    = iv_matnr
        iv_matnr_eq = abap_false
      RECEIVING
        rt_message  = ct_message
    ).

    IF ct_message IS INITIAL.

      SELECT SINGLE *
        FROM zmat
        INTO rs_itab_zmat
        WHERE matnr = iv_matnr.

      IF sy-subrc NE 0.

        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 002
            iv_msgv1    = 'de Materiais'
          CHANGING
            ct_messages = ct_message
        ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD update_material.

    me->validate_material(
      EXPORTING
        iv_matnr    = is_fields-matnr
        iv_matnr_eq = abap_false
        iv_unid     = is_fields-unid
      RECEIVING
        rt_message  = et_message
    ).

    IF et_message IS INITIAL.

      gv_fields = get_fields_update( is_fields = is_fields ).

      UPDATE zmat
      SET (gv_fields)
      WHERE matnr = @is_fields-matnr.

      IF sy-subrc NE 0.

        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 003
            iv_msgv1    = 'de Materiais'
          CHANGING
            ct_messages = et_message
        ).
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD validate_material.

    SELECT SINGLE matnr
      FROM zmat
      INTO @DATA(lv_matnr)
      WHERE matnr = @iv_matnr.

    IF iv_matnr_eq = abap_true.

      IF sy-subrc EQ 0.
        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 023
          CHANGING
            ct_messages = rt_message
        ).
      ENDIF.

    ELSEIF iv_matnr_eq = abap_false.

      IF sy-subrc NE 0.
        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 002
            iv_msgv1    = 'de Materiais'
          CHANGING
            ct_messages = rt_message
        ).
      ENDIF.

    ENDIF.

    IF iv_unid IS NOT INITIAL.

      SELECT SINGLE msehi
        FROM t006
        INTO @DATA(lv_unid)
        WHERE msehi = @iv_unid.

      IF sy-subrc NE 0.
        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 002
            iv_msgv1    = 'de Unidade'
          CHANGING
            ct_messages = rt_message
        ).
      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
