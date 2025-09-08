*&---------------------------------------------------------------------*
*& Report ZPRICE
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zprice.

INCLUDE zprice_top.
INCLUDE zprice_f01.

AT SELECTION-SCREEN.
  PERFORM valida_parameters USING p_matnr p_VLD_FR p_VLD_TO p_PRICE p_WAERS.


START-OF-SELECTION.

  PERFORM check_zprice USING p_MATNR CHANGING gv_matnr.

  PERFORM update_price USING p_matnr p_VLD_FR p_VLD_TO p_PRICE p_WAERS p_ATIVO gv_matnr.

  PERFORM create_price USING p_matnr p_VLD_FR p_VLD_TO p_PRICE p_WAERS p_ATIVO gv_matnr CHANGING gwa_zprice.

  PERFORM alv_event.
