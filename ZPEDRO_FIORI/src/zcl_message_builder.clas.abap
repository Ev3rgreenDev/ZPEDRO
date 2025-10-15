class ZCL_MESSAGE_BUILDER definition
  public
  create public .

public section.

  class-methods MESSAGE_BUILDER
    importing
      !IV_MSGID type SYST_MSGID
      !IV_MSGNO type SYST_MSGNO
      !IV_MSGV1 type SYST_MSGV optional
      !IV_MSGV2 type SYST_MSGV optional
      !IV_MSGV3 type SYST_MSGV optional
      !IV_MSGV4 type SYST_MSGV optional
    changing
      !CT_MESSAGES type ZTT_MESSAGE .
  class-methods EXCEPTION_MESSAGE
    importing
      !IT_MESSAGE type ZTT_MESSAGE
      !IO_MSG type ref to /IWBEP/IF_MESSAGE_CONTAINER
    raising
      /IWBEP/CX_MGW_BUSI_EXCEPTION .
protected section.
private section.
ENDCLASS.



CLASS ZCL_MESSAGE_BUILDER IMPLEMENTATION.


  METHOD exception_message.

    DATA: ls_message TYPE zst_message.

    LOOP AT it_message INTO ls_message.

      io_msg->add_message(
        EXPORTING
          iv_msg_type   = /iwbep/cl_cos_logger=>error
          iv_msg_id     = ls_message-message_id
          iv_msg_number = ls_message-message_number
          iv_msg_text   = ls_message-text
          iv_msg_v1     = ls_message-msgv1
          iv_msg_v2     = ls_message-msgv2
          iv_msg_v3     = ls_message-msgv3
          iv_msg_v4     = ls_message-msgv4
      ).

    ENDLOOP.

    RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
      EXPORTING
        message_container = io_msg
        http_status_code  = 400.

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
ENDCLASS.
