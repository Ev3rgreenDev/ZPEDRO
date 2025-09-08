*&---------------------------------------------------------------------*
*& Report ZVND_C_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvnd_c_new.

INCLUDE: zvnd_c_new_top,
         zvnd_c_new_f01,
         zvnd_c_new_o01.

AT SELECTION-SCREEN.
  CREATE OBJECT go_report.
  go_report->valida(
    CHANGING
      p_data_f = p_data_f ).

START-OF-SELECTION.
  CREATE OBJECT go_report.
  go_report->set_fields(
    CHANGING
      gv_campos = gv_campos ).

  go_report->get_data( ).

END-OF-SELECTION.

  go_report->display_output( ).
  CALL SCREEN 100.

INCLUDE zvnd_c_new_user_command_010i01.
