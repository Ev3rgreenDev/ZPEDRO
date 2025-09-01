*&---------------------------------------------------------------------*
*& Report ZSTK_MOV_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zstk_mov_new.

INCLUDE zstk_mov_new_top.

INCLUDE zstk_mov_new_f01.


AT SELECTION-SCREEN.

PERFORM valida CHANGING p_DATA_F.


START-OF-SELECTION.

PERFORM get_selection CHANGING lv_campos.

PERFORM get_zmov USING lv_campos.

PERFORM tpmov_processing CHANGING ls_itab_zmov.

PERFORM alv_event.
