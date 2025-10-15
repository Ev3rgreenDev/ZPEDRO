*&---------------------------------------------------------------------*
*& Report ZVND_C
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvnd_c.

INCLUDE: zvnd_c_top,
         zvnd_c_f01.

AT SELECTION-SCREEN.
  PERFORM valida USING p_vbeln p_CUSTID p_data_i p_status CHANGING p_data_f.

START-OF-SELECTION.

  PERFORM get_fields USING p_CUSTID p_data_i p_data_f p_status CHANGING gv_campos.

  PERFORM super_alv USING gv_campos.
