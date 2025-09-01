*&---------------------------------------------------------------------*
*& Report ZLOC_CAD_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLOC_CAD_NEW.

INCLUDE ZLOC_CAD_NEW_TOP.

INCLUDE ZLOC_CAD_NEW_F01.


START-OF-SELECTION.

PERFORM check_locid CHANGING lv_locid.

PERFORM update_zloc USING lv_locid.

PERFORM create_zloc USING lv_locid.

PERFORM alv_event.
