*&---------------------------------------------------------------------*
*& Report ZLOC_CAD_NEW
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZLOC_CAD_NEW.

INCLUDE ZLOC_CAD_NEW_TOP.

INCLUDE ZLOC_CAD_NEW_F01.


START-OF-SELECTION.

PERFORM check_locid CHANGING gv_locid.

PERFORM update_zloc USING gv_locid.

PERFORM create_zloc USING gv_locid.

PERFORM alv_event.
