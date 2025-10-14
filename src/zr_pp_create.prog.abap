*&---------------------------------------------------------------------*
*& Report ZR_PP_CREATE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zr_pp_create.

INCLUDE zr_pp_create_top.

AT SELECTION-SCREEN.

  SELECT *
      FROM zmat
      INTO TABLE gt_zmat
      WHERE matnr = p_matnr.

  DATA(lo_validate_matnr) = NEW zcl_validate_matnr( ).

  lo_validate_matnr->validate(
    EXPORTING
      iv_table = 'zmat'
      iv_campo = 'matnr'
      iv_matnr = p_matnr
      iv_exist = 's'
    IMPORTING
      et_table = gt_zmat
  ).

  START-OF-SELECTION.
