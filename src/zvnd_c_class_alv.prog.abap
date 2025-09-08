*&---------------------------------------------------------------------*
*& Include          ZVND_C_CLASS_ALV
*&---------------------------------------------------------------------*
CALL SCREEN 100.
*&---------------------------------------------------------------------*
*& Module STATUS_0100 OUTPUT
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
MODULE status_0100 OUTPUT.
* SET PF-STATUS 'xxxxxxxx'.
* SET TITLEBAR 'xxx'.

  CREATE OBJECT go_cont
    EXPORTING
*     parent         =
      container_name = 'CUST_CTRL'.


  CREATE OBJECT go_alv
    EXPORTING
      i_parent = go_cont.

  PERFORM valida USING p_vbeln p_CUSTID p_data_i p_status CHANGING p_data_f.
  PERFORM get_fields USING p_CUSTID p_data_i p_data_f p_status CHANGING gv_campos.

ENDMODULE.
*&---------------------------------------------------------------------*
*&      Module  USER_COMMAND_0100  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE user_command_0100 INPUT.

ENDMODULE.
