*----------------------------------------------------------------------*
***INCLUDE ZRBOM_MAINT_MODULES.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  %_INIT_PAI  INPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE %_init_pai INPUT.

  IF sy-subrc = 0.  "the user clicked the execute button
    sscrfields-ucomm = 'ONLI'.  "set the system command for the next screen to execute
  ENDIF.

ENDMODULE.
