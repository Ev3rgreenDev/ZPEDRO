*&---------------------------------------------------------------------*
*& Report ZMAT_CAD_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zmat_cad_new.

INCLUDE zmat_cad_new_top.

INCLUDE zmat_cad_new_f01.

AT SELECTION-SCREEN.

  PERFORM verify_unid USING p_UNID.


START-OF-SELECTION.

  PERFORM check_matnr CHANGING gv_MATNR.

  PERFORM update_zmat USING gv_matnr.

  PERFORM create_zmat USING gv_matnr.

  PERFORM alv_event.
