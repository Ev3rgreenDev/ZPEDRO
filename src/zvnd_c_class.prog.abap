*&---------------------------------------------------------------------*
*& Report ZVND_C_CLASS
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvnd_c_class.

INCLUDE: zvnd_c_class_top,
         zvnd_c_f01.

START-OF-SELECTION.

  CALL SCREEN 100.

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
  PERFORM super_alv USING gv_campos.

ENDMODULE.

MODULE user_command_0100 INPUT.

ENDMODULE.
