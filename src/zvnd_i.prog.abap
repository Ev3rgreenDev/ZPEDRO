*&---------------------------------------------------------------------*
*& Report ZVND_I
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zvnd_i.

INCLUDE zvnd_i_top.
INCLUDE zvnd_i_f01.

AT SELECTION-SCREEN.
  PERFORM valida_parameters USING p_VBELN p_MATNR p_QTY p_DESC.
  PERFORM set_date USING gv_data.


START-OF-SELECTION.

  PERFORM get_data       USING p_VBELN p_MATNR                 CHANGING gwa_zprice.

  PERFORM check_currency USING p_VBELN p_MATNR                 CHANGING gwa_zstock.

  PERFORM get_values     USING p_QTY p_DESC gwa_zprice         CHANGING gwa_ZVND_I gv_VAL_BRUTO gv_val_desc gv_val_liq.

  PERFORM update_zstock  USING p_matnr p_qty gwa_zstock gv_data.

  PERFORM set_posnr                                            CHANGING gv_posnr.

  PERFORM create_zmov    USING p_vbeln gv_posnr p_qty gv_data  CHANGING gwa_zmov.

  PERFORM create_ZVND_I  USING p_VBELN gv_POSNR p_MATNR gwa_zstock p_qty gwa_zprice p_desc gv_val_bruto CHANGING gwa_ZVND_I.

  PERFORM alv_event.
