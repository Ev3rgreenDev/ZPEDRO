*---------------------------------------------------------------------*
*    program for:   TABLEFRAME_Z02_FG_USUARIOS
*---------------------------------------------------------------------*
FUNCTION TABLEFRAME_Z02_FG_USUARIOS    .

  PERFORM TABLEFRAME TABLES X_HEADER X_NAMTAB DBA_SELLIST DPL_SELLIST
                            EXCL_CUA_FUNCT
                     USING  CORR_NUMBER VIEW_ACTION VIEW_NAME.

ENDFUNCTION.
