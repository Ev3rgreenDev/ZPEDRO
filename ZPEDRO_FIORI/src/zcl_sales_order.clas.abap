class ZCL_SALES_ORDER definition
  public
  final
  create public .

public section.

  methods GET_SO
    importing
      !IV_FIELDS type STRING
    returning
      value(RT_SD_ORDER) type ZTT_SD_ORDER .
  methods GET_SINGLE_SO
    importing
      !IV_VBELN type VBELN
      !IV_POSNR type POSNR
      !IV_MATNR type ZE_MATNR
      !IV_CUSTID type ZE_CUSTID
    exporting
      !ET_MESSAGE type ZTT_MESSAGE
    returning
      value(RT_SD_ORDER) type ZST_SD_ORDER .
  methods CREATE_DEEP_ENTITY_HEADER
    changing
      !CS_HEADER type ZVND_H
      !CT_ITEMS type ZTT_ZVND_I
      !CT_CUST type ZTT_ZCUST
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods CREATE_DEEP_ENTITY_ITEMS
    changing
      !CS_ITEMS type ZVND_I
      !CS_HEADER type ZVND_H
      !CS_MAT type ZMAT
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods CREATE_DEEP_ENTITY_CUST
    changing
      !CT_HEADER type ZTT_ZVND_H
      !CS_CUST type ZCUST
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods CREATE_DEEP_ENTITY_MAT
    changing
      !CS_ITEMS type ZVND_I
      !CS_MAT type ZMAT
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
protected section.
private section.

  constants GC_ZPEDRO type SY-MSGID value 'ZPEDRO' ##NO_TEXT.

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
  methods VALIDATE_CREATE_HEADER
    importing
      !IT_CUST type ZTT_ZCUST optional
    changing
      !CT_HEADER type ZTT_ZVND_H
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods VALIDATE_CREATE_ITEMS
    changing
      !CT_HEADER type ZTT_ZVND_H optional
      !CT_MAT type ZTT_ZMAT optional
      !CT_ITEMS type ZTT_ZVND_I
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods VALIDATE_CREATE_CUST
    changing
      !CT_HEADER type ZTT_ZVND_H
      !CT_CUST type ZTT_ZCUST
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
  methods VALIDATE_CREATE_MAT
    changing
      !CT_MAT type ZTT_ZMAT
    returning
      value(RT_MESSAGE) type ZTT_MESSAGE .
ENDCLASS.



CLASS ZCL_SALES_ORDER IMPLEMENTATION.


  METHOD create_deep_entity_cust.

    DATA: lt_cust   TYPE ztt_zcust.

    APPEND cs_cust   TO lt_cust.

    rt_message = validate_create_cust(
                   CHANGING
                     ct_header = ct_header
                     ct_cust   = lt_cust
                 ).

    IF rt_message IS INITIAL.

      rt_message = validate_create_header(
                     EXPORTING
                       it_cust   = lt_cust
                     CHANGING
                       ct_header = ct_header
                   ).
    ENDIF.

    IF rt_message IS INITIAL.

      INSERT zvnd_h FROM TABLE ct_header.

      IF sy-subrc NE 0.

        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 000
            iv_msgv1    = 'ZVND_H'
          CHANGING
            ct_messages = rt_message
        ).

      ELSE.

        READ TABLE lt_cust INTO cs_cust INDEX 1.

        IF sy-subrc NE 0.
          zcl_message_builder=>message_builder(
            EXPORTING
              iv_msgid    = gc_zpedro
              iv_msgno    = 027
              iv_msgv1    = 'lt_header'
            CHANGING
              ct_messages = rt_message
          ).
        ELSE.

          INSERT zcust FROM cs_cust.

          IF sy-subrc NE 0.

            zcl_message_builder=>message_builder(
              EXPORTING
                iv_msgid    = gc_zpedro
                iv_msgno    = 000
                iv_msgv1    = 'ZCUST'
              CHANGING
                ct_messages = rt_message
            ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD create_deep_entity_header.

    DATA: lt_header TYPE ztt_zvnd_h.

*---------------------------- HEADER ---------------------------------

    APPEND cs_header TO lt_header.

    rt_message = validate_create_header(
                   EXPORTING
                     it_cust   = ct_cust
                   CHANGING
                     ct_header = lt_header
                 ).

*---------------------------- ITENS ---------------------------------

    IF ct_items IS NOT INITIAL AND rt_message IS INITIAL.

      rt_message = validate_create_items(
                     CHANGING
                      ct_header = lt_header
                      ct_items  = ct_items
                   ).
    ENDIF.

*---------------------------- CLIENTE ---------------------------------

    IF ct_cust IS NOT INITIAL AND rt_message IS INITIAL.

      rt_message = validate_create_cust(
                     CHANGING
                       ct_header = lt_header
                       ct_cust   = ct_cust
                   ).
    ENDIF.

*---------------------------- INSERÇÃO HEADER ---------------------------------

    IF rt_message IS INITIAL.

      CLEAR cs_header.

      READ TABLE lt_header INTO cs_header INDEX 1.

      IF sy-subrc NE 0.
        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 027
            iv_msgv1    = 'lt_header'
          CHANGING
            ct_messages = rt_message
        ).
      ELSE.

        INSERT zvnd_h FROM cs_header.

        IF sy-subrc NE 0.
          zcl_message_builder=>message_builder(
            EXPORTING
              iv_msgid    = gc_zpedro
              iv_msgno    = 000
              iv_msgv1    = 'ZVND_H'
            CHANGING
              ct_messages = rt_message
          ).
        ENDIF.
      ENDIF.

*---------------------------- INSERÇÃO ITEMS ---------------------------------

      IF ct_items IS NOT INITIAL AND rt_message IS INITIAL.

        INSERT zvnd_i FROM TABLE ct_items.

        IF sy-subrc NE 0.
          zcl_message_builder=>message_builder(
            EXPORTING
              iv_msgid    =  gc_zpedro
              iv_msgno    =  000
              iv_msgv1    = 'de Itens'
            CHANGING
              ct_messages = rt_message
          ).
        ENDIF.
      ENDIF.

*---------------------------- INSERÇÃO CUST ---------------------------------

      IF ct_cust IS NOT INITIAL AND rt_message IS INITIAL.

        INSERT zcust FROM TABLE ct_cust.

        IF sy-subrc NE 0.
          zcl_message_builder=>message_builder(
            EXPORTING
              iv_msgid    =  gc_zpedro
              iv_msgno    =  000
              iv_msgv1    = 'de Itens'
            CHANGING
              ct_messages = rt_message
          ).
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD create_deep_entity_items.

    DATA: lt_items  TYPE ztt_zvnd_i,
          lt_header TYPE ztt_zvnd_h,
          lt_mat    TYPE ztt_zmat.

    DATA: lv_header_status TYPE boolean.

    APPEND cs_items  TO lt_items.

    APPEND cs_header TO lt_header.

    APPEND cs_mat    TO lt_mat.

*------------------------------------- HEADER --------------------------------------------

    IF lt_header IS NOT INITIAL.

      rt_message = validate_create_header(
                     CHANGING
                       ct_header = lt_header
                   ).

      IF rt_message IS INITIAL.

        lv_header_status = 'X'.

      ENDIF.
    ENDIF.

*------------------------------------- MATERIAL --------------------------------------------

    IF lt_mat IS NOT INITIAL AND rt_message IS INITIAL.

      rt_message = validate_create_mat(
                     CHANGING
                       ct_mat = lt_mat
                   ).
    ENDIF.

*------------------------------------- ITENS --------------------------------------------

    IF rt_message IS INITIAL.

      rt_message = validate_create_items(
                 CHANGING
                   ct_header = lt_header
                   ct_mat    = lt_mat
                   ct_items  = lt_items
               ).

      IF rt_message IS INITIAL.

        CLEAR cs_items.

        READ TABLE lt_items INTO cs_items INDEX 1.

        INSERT zvnd_i FROM cs_items.

        IF sy-subrc NE 0.
          zcl_message_builder=>message_builder(
            EXPORTING
              iv_msgid    = gc_zpedro
              iv_msgno    = 000
              iv_msgv1    = 'ZVND_I'
            CHANGING
              ct_messages = rt_message
          ).
        ENDIF.
      ENDIF.

*------------------------------------ CREATE / UPDATE HEADER --------------------------------

      IF rt_message IS INITIAL AND lv_header_status = 'X'.

        CLEAR cs_header.

        READ TABLE lt_header INTO cs_header INDEX 1.

        IF sy-subrc NE 0.
          zcl_message_builder=>message_builder(
            EXPORTING
              iv_msgid    = gc_zpedro
              iv_msgno    = 027
              iv_msgv1    = 'lt_header'
            CHANGING
              ct_messages = rt_message
          ).
        ELSE.

          INSERT zvnd_h FROM cs_header.

          IF sy-subrc NE 0.
            zcl_message_builder=>message_builder(
              EXPORTING
                iv_msgid    = gc_zpedro
                iv_msgno    = 000
                iv_msgv1    = 'ZVND_H'
              CHANGING
                ct_messages = rt_message
            ).
          ENDIF.
        ENDIF.

      ELSE.

        IF rt_message IS INITIAL.

          READ TABLE lt_header INTO cs_header INDEX 1.

          IF sy-subrc NE 0.
            zcl_message_builder=>message_builder(
              EXPORTING
                iv_msgid    = gc_zpedro
                iv_msgno    = 027
                iv_msgv1    = 'lt_header'
              CHANGING
                ct_messages = rt_message
            ).
          ELSE.

            SELECT SINGLE vbeln, val_bruto, val_desc, val_liq
              FROM zvnd_h
              INTO @DATA(ls_header)
              WHERE vbeln = @cs_header-vbeln.

            IF sy-subrc NE 0.
              zcl_message_builder=>message_builder(
                EXPORTING
                  iv_msgid    = gc_zpedro
                  iv_msgno    = 027
                  iv_msgv1    = 'lt_header'
                CHANGING
                  ct_messages = rt_message
              ).
            ELSE.

              READ TABLE lt_header ASSIGNING FIELD-SYMBOL(<fs_header>) INDEX 1.

              IF sy-subrc NE 0.
                zcl_message_builder=>message_builder(
                  EXPORTING
                    iv_msgid    = gc_zpedro
                    iv_msgno    = 027
                    iv_msgv1    = 'lt_header'
                  CHANGING
                    ct_messages = rt_message
                ).
              ELSE.

                cs_header-val_bruto = <fs_header>-val_bruto + ls_header-val_bruto.
                cs_header-val_desc  = <fs_header>-val_desc  + ls_header-val_desc.
                cs_header-val_liq   = <fs_header>-val_liq   + ls_header-val_liq.

                UPDATE zvnd_h
                SET val_bruto = @cs_header-val_bruto,
                    val_desc  = @cs_header-val_desc,
                    val_liq   = @cs_header-val_liq
                WHERE vbeln   = @cs_header-vbeln.

                IF sy-subrc NE 0.
                  zcl_message_builder=>message_builder(
                    EXPORTING
                      iv_msgid    = gc_zpedro
                      iv_msgno    = 003
                      iv_msgv1    = 'ZVND_H'
                    CHANGING
                      ct_messages = rt_message
                  ).
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.

*------------------------------------- CREATE MATERIAL --------------------------------------------

      IF rt_message IS INITIAL AND lt_mat IS NOT INITIAL.

        READ TABLE lt_mat INTO cs_mat INDEX 1.

        IF sy-subrc NE 0.
          zcl_message_builder=>message_builder(
            EXPORTING
              iv_msgid    = gc_zpedro
              iv_msgno    = 027
              iv_msgv1    = 'lt_header'
            CHANGING
              ct_messages = rt_message
          ).
        ELSE.

          INSERT zmat FROM cs_mat.

          IF sy-subrc NE 0.
            zcl_message_builder=>message_builder(
              EXPORTING
                iv_msgid    = gc_zpedro
                iv_msgno    = 000
                iv_msgv1    = 'de Materiais'
              CHANGING
                ct_messages = rt_message
            ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD create_deep_entity_mat.

    DATA: lt_items  TYPE ztt_zvnd_i,
          lt_mat    TYPE ztt_zmat,
          lt_header TYPE ztt_zvnd_h.

    APPEND cs_items TO lt_items.
    APPEND cs_mat   TO lt_mat.

    rt_message = validate_create_mat(
                   CHANGING
                     ct_mat = lt_mat
                 ).

    IF rt_message IS INITIAL.

      rt_message = validate_create_items(
                     CHANGING
                       ct_mat    = lt_mat
                       ct_items  = lt_items
                       ct_header = lt_header
                   ).
    ENDIF.

    IF rt_message IS INITIAL.

      READ TABLE lt_mat INTO cs_mat INDEX 1.

      IF sy-subrc NE 0.

        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 027
            iv_msgv1    = 'LT_MAT'
          CHANGING
            ct_messages = rt_message
        ).

      ELSE.

        INSERT zmat FROM cs_mat.

        IF sy-subrc NE 0.

          zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 000
            iv_msgv1    = 'ZMAT'
          CHANGING
            ct_messages = rt_message
        ).

        ELSE.

          READ TABLE lt_items INTO cs_items INDEX 1.

          IF sy-subrc NE 0.

            zcl_message_builder=>message_builder(
              EXPORTING
                iv_msgid    = gc_zpedro
                iv_msgno    = 027
                iv_msgv1    = 'LT_ITEMS'
              CHANGING
                ct_messages = rt_message
            ).

          ELSE.
            SELECT SINGLE vbeln, val_bruto, val_desc, val_liq
              FROM zvnd_h
              INTO @DATA(ls_header)
              WHERE vbeln = @cs_items-vbeln.

            IF sy-subrc NE 0.
              zcl_message_builder=>message_builder(
                EXPORTING
                  iv_msgid    = gc_zpedro
                  iv_msgno    = 027
                  iv_msgv1    = 'lt_header'
                CHANGING
                  ct_messages = rt_message
              ).
            ELSE.

              READ TABLE lt_header ASSIGNING FIELD-SYMBOL(<fs_header>) INDEX 1.

              IF sy-subrc NE 0.

                zcl_message_builder=>message_builder(
                  EXPORTING
                    iv_msgid    = gc_zpedro
                    iv_msgno    = 027
                    iv_msgv1    = 'LT_ITEMS'
                  CHANGING
                    ct_messages = rt_message
                ).

              ELSE.

                <fs_header>-val_bruto = <fs_header>-val_bruto + ls_header-val_bruto.
                <fs_header>-val_desc  = <fs_header>-val_desc  + ls_header-val_desc.
                <fs_header>-val_liq   = <fs_header>-val_liq   + ls_header-val_liq.

                UPDATE zvnd_h
                SET val_bruto = @<fs_header>-val_bruto,
                    val_desc  = @<fs_header>-val_desc,
                    val_liq   = @<fs_header>-val_liq
                WHERE vbeln   = @cs_items-vbeln.

                IF sy-subrc NE 0.
                  zcl_message_builder=>message_builder(
                    EXPORTING
                      iv_msgid    = gc_zpedro
                      iv_msgno    = 003
                      iv_msgv1    = 'ZVND_H'
                    CHANGING
                      ct_messages = rt_message
                  ).
                ELSE.

                  INSERT zvnd_i FROM cs_items.

                  IF sy-subrc NE 0.

                    zcl_message_builder=>message_builder(
                    EXPORTING
                      iv_msgid    = gc_zpedro
                      iv_msgno    = 000
                      iv_msgv1    = 'ZVND_I'
                    CHANGING
                      ct_messages = rt_message
                  ).

                  ENDIF.
                ENDIF.
              ENDIF.
            ENDIF.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD get_single_so.

    DATA: lc_zpedro TYPE sy-msgid VALUE 'ZPEDRO'.

    SELECT SINGLE Ordem~vbeln,
                  Ordem~data_doc,
                  Ordem~moeda,
                  Ordem~val_bruto,
                  Ordem~val_desc,
                  Ordem~val_liq,
                  Ordem~status,
                  Item~posnr,
                  Item~matnr,
                  Material~descr,
                  Item~locid,
                  Item~qty,
                  Item~price,
                  Item~val_item,
                  Item~desc_it,
                  Item~val_liq_item,
                  Ordem~custid,
                  Cliente~nome
     FROM zvnd_i       AS Item
     INNER JOIN zvnd_h AS Ordem    ON Ordem~vbeln    = Item~vbeln
     INNER JOIN zcust  AS Cliente  ON Cliente~custid = Ordem~custid
     INNER JOIN zmat   AS Material ON Material~matnr = Item~Matnr
     INTO @rt_sd_order
     WHERE Ordem~vbeln  = @iv_vbeln
       AND Item~posnr   = @iv_posnr
       AND Item~matnr   = @iv_matnr
       AND Ordem~custid = @iv_custid.

      IF sy-subrc NE 0.
        me->message_builder(
          EXPORTING
            iv_msgid    = lc_zpedro
            iv_msgno    = 002
            iv_msgv1    = 'de ordem de venda'
          CHANGING
            ct_messages = et_message
        ).
      ENDIF.

  ENDMETHOD.


  METHOD get_so.

    DATA: lv_fields TYPE string.

    lv_fields = iv_fields.

    REPLACE 'Vbeln'       IN lv_fields WITH 'Ordem~vbeln'.
    REPLACE 'DataDoc'     IN lv_fields WITH 'Ordem~data_doc'.
    REPLACE 'Moeda'       IN lv_fields WITH 'Ordem~moeda'.
    REPLACE 'ValBruto'    IN lv_fields WITH 'Ordem~val_bruto'.
    REPLACE 'ValLiqItem'  IN lv_fields WITH 'Item~val_liq_item'.
    REPLACE 'ValDesc'     IN lv_fields WITH 'Ordem~val_desc'.
    REPLACE 'ValLiq'      IN lv_fields WITH 'Ordem~val_liq'.
    REPLACE 'Status'      IN lv_fields WITH 'Ordem~status'.
    REPLACE 'Posnr'       IN lv_fields WITH 'Item~posnr'.
    REPLACE 'Matnr'       IN lv_fields WITH 'Item~matnr'.
    REPLACE 'Descr'       IN lv_fields WITH 'Material~descr'.
    REPLACE 'Locid'       IN lv_fields WITH 'Item~locid'.
    REPLACE 'Qty'         IN lv_fields WITH 'Item~qty'.
    REPLACE 'Price'       IN lv_fields WITH 'Item~price'.
    REPLACE 'ValItem'     IN lv_fields WITH 'Item~val_item'.
    REPLACE 'DescIt'      IN lv_fields WITH 'Item~desc_it'.
    REPLACE 'Custid'      IN lv_fields WITH 'Ordem~custid'.
    REPLACE 'Nome'        IN lv_fields WITH 'Cliente~nome'.



    SELECT Ordem~vbeln,
           Ordem~data_doc,
           Ordem~moeda,
           Ordem~val_bruto,
           Ordem~val_desc,
           Ordem~val_liq,
           Ordem~status,
           Item~posnr,
           Item~matnr,
           Material~descr,
           Item~locid,
           Item~qty,
           Item~price,
           Item~val_item,
           Item~desc_it,
           Item~val_liq_item,
           Ordem~custid,
           Cliente~nome
      FROM zvnd_i       AS Item
      INNER JOIN zvnd_h AS Ordem    ON Ordem~vbeln    = Item~vbeln
      INNER JOIN zcust  AS Cliente  ON Cliente~custid = Ordem~custid
      INNER JOIN zmat   AS Material ON Material~matnr = Item~Matnr
      INTO TABLE @rt_sd_order
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


  METHOD validate_create_cust.

    SELECT cpf
        FROM zcust
        INTO TABLE @DATA(lt_cpf)
        FOR ALL ENTRIES IN @ct_cust
        WHERE cpf = @ct_cust-cpf.

    IF sy-subrc EQ 0.
      zcl_message_builder=>message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de CPF, pois CPF já existe'
        CHANGING
          ct_messages = rt_message
      ).
    ELSE.

      SELECT MAX( custid )
        FROM zcust
        INTO @DATA(lv_custid).

      IF sy-subrc NE 0.
        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 002
            iv_msgv1    = 'de MAX CUSTID'
          CHANGING
            ct_messages = rt_message
        ).
      ENDIF.

      LOOP AT ct_cust ASSIGNING FIELD-SYMBOL(<fs_cust>).

        lv_custid = lv_custid + 1.
        <fs_cust>-custid = |{ lv_custid ALPHA = IN }|.
        <fs_cust>-ativo  = 'X'.

        LOOP AT ct_header ASSIGNING FIELD-SYMBOL(<fs_header>).

          <fs_header>-custid = <fs_cust>-custid.

        ENDLOOP.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD validate_create_header.

    SELECT waers
      FROM tcurc
      INTO TABLE @DATA(lt_moeda)
      FOR ALL ENTRIES IN @ct_header
      WHERE waers = @ct_header-moeda.

    IF sy-subrc NE 0.
      zcl_message_builder=>message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de Moeda'
        CHANGING
          ct_messages = rt_message
      ).
    ENDIF.

    IF it_cust IS INITIAL.

      SELECT custid
        FROM zcust
        INTO TABLE @DATA(lv_custid_check)
        FOR ALL ENTRIES IN @ct_header
        WHERE custid = @ct_header-custid.

      IF sy-subrc NE 0.
        zcl_message_builder=>message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de CUSTID'
        CHANGING
          ct_messages = rt_message
      ).
      ENDIF.
    ENDIF.

    IF rt_message IS INITIAL.

      SELECT MAX( vbeln )
        FROM zvnd_h
        INTO @DATA(lv_vbeln).

      IF sy-subrc NE 0.
        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 002
            iv_msgv1    = 'de MAX VBELN'
          CHANGING
            ct_messages = rt_message
        ).
      ENDIF.

      LOOP AT ct_header ASSIGNING FIELD-SYMBOL(<fs_header>).

        lv_vbeln = lv_vbeln + 1.

        <fs_header>-vbeln    = |{ lv_vbeln ALPHA = IN }|.
        <fs_header>-data_doc = sy-datum.
        <fs_header>-hora_doc = sy-uzeit.
        <fs_header>-status   = 'O'.

      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD validate_create_items.

    DATA: lv_vbruto TYPE ze_price,
          lv_vdesc  TYPE ze_price,
          lv_vliq   TYPE ze_price.

    IF ct_header IS INITIAL.

      SELECT vbeln
        FROM  zvnd_h
        INTO TABLE @DATA(lv_vbeln)
        FOR ALL ENTRIES IN @ct_items
        WHERE vbeln = @ct_items-vbeln.

      IF sy-subrc NE 0.
        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 002
            iv_msgv1    = 'de VBELN'
          CHANGING
            ct_messages = rt_message
        ).
      ENDIF.
    ENDIF.

    IF ct_mat IS INITIAL AND rt_message IS INITIAL.

      SELECT matnr
        FROM zmat
        INTO TABLE @DATA(lt_matnr)
        FOR ALL ENTRIES IN @ct_items
        WHERE matnr = @ct_items-matnr.

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

    IF rt_message IS INITIAL.

      SELECT locid
       FROM zloc
       INTO TABLE @DATA(lt_locid)
       FOR ALL ENTRIES IN @ct_items
       WHERE locid = @ct_items-locid.

      IF sy-subrc NE 0.
        zcl_message_builder=>message_builder(
          EXPORTING
            iv_msgid    = gc_zpedro
            iv_msgno    = 002
            iv_msgv1    = 'de Local'
          CHANGING
            ct_messages = rt_message
        ).

      ELSE.

        SELECT MAX( posnr )
          FROM zvnd_i
          INTO @DATA(lv_posnr).

        IF sy-subrc NE 0.
          zcl_message_builder=>message_builder(
            EXPORTING
              iv_msgid    = gc_zpedro
              iv_msgno    = 002
              iv_msgv1    = 'de MAX POSNR'
            CHANGING
              ct_messages = rt_message
          ).
        ELSE.

          LOOP AT ct_items ASSIGNING FIELD-SYMBOL(<fs_items>).

            IF <fs_items>-qty LE 0.
              zcl_message_builder=>message_builder(
                EXPORTING
                  iv_msgid    = gc_zpedro
                  iv_msgno    = 014
                CHANGING
                  ct_messages = rt_message
              ).
              EXIT.
            ENDIF.

            IF <fs_items>-vbeln IS INITIAL AND ct_header IS NOT INITIAL.

              READ TABLE ct_header ASSIGNING FIELD-SYMBOL(<fs_header2>) INDEX 1.

              IF sy-subrc NE 0.

                zcl_message_builder=>message_builder(
                  EXPORTING
                    iv_msgid    = gc_zpedro
                    iv_msgno    = 002
                    iv_msgv1    = 'de Header'
                  CHANGING
                    ct_messages = rt_message
                ).
                EXIT.

              ELSE.

                <fs_items>-vbeln    = <fs_header2>-vbeln.
                <fs_items>-currency = <fs_header2>-moeda.

              ENDIF.
            ENDIF.

            IF <fs_items>-vbeln IS NOT INITIAL AND ct_header IS INITIAL.

              ct_header = CORRESPONDING #( BASE ( ct_header ) ct_items ).

            ENDIF.

            IF ct_mat IS NOT INITIAL.

              READ TABLE ct_mat ASSIGNING FIELD-SYMBOL(<fs_mat>) INDEX 1.

              IF sy-subrc NE 0.

                zcl_message_builder=>message_builder(
                  EXPORTING
                    iv_msgid    = gc_zpedro
                    iv_msgno    = 002
                    iv_msgv1    = 'de Material'
                  CHANGING
                    ct_messages = rt_message
                ).
                EXIT.

              ELSE.

                <fs_items>-matnr    = <fs_mat>-matnr.

              ENDIF.
            ENDIF.


            lv_posnr = lv_posnr + 1.

            <fs_items>-posnr        = lv_posnr.
            <fs_items>-val_item     = <fs_items>-price * <fs_items>-qty.
            <fs_items>-val_liq_item = <fs_items>-val_item - <fs_items>-desc_it.

            IF <fs_items>-val_item LE <fs_items>-desc_it.
              zcl_message_builder=>message_builder(
              EXPORTING
                iv_msgid    = gc_zpedro
                iv_msgno    = 009
              CHANGING
                ct_messages = rt_message
            ).
              EXIT.
            ENDIF.

            lv_vbruto = lv_vbruto + <fs_items>-val_item.
            lv_vdesc  = lv_vdesc  + <fs_items>-desc_it.
            lv_vliq   = lv_vliq   + <fs_items>-val_liq_item.

          ENDLOOP.

          READ TABLE ct_header ASSIGNING FIELD-SYMBOL(<fs_header>) INDEX 1.

          IF sy-subrc NE 0.
            zcl_message_builder=>message_builder(
              EXPORTING
                iv_msgid    = gc_zpedro
                iv_msgno    = 027
                iv_msgv1    = 'ls_header'
              CHANGING
                ct_messages = rt_message
            ).
          ELSE.

            <fs_header>-val_bruto = lv_vbruto.
            <fs_header>-val_desc  = lv_vdesc.
            <fs_header>-val_liq   = lv_vliq.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD validate_create_mat.

    SELECT matnr
      FROM zmat
      INTO TABLE @DATA(lt_matnr)
      FOR ALL ENTRIES IN @ct_mat
      WHERE matnr = @ct_mat-matnr.

    IF sy-subrc EQ 0.
      zcl_message_builder=>message_builder(
        EXPORTING
          iv_msgid    = gc_zpedro
          iv_msgno    = 002
          iv_msgv1    = 'de Materiais'
        CHANGING
          ct_messages = rt_message
      ).
    ENDIF.

    IF rt_message IS INITIAL.

      SELECT msehi
        FROM t006
        INTO TABLE @DATA(lt_unid)
        FOR ALL ENTRIES IN @ct_mat
        WHERE msehi = @ct_mat-unid.

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
