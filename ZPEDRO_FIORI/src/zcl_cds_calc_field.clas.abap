class ZCL_CDS_CALC_FIELD definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .
  interfaces IF_SADL_EXIT_CALC_ELEMENT_READ .
protected section.
private section.
ENDCLASS.



CLASS ZCL_CDS_CALC_FIELD IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_cds TYPE STANDARD TABLE OF zi_sd_sales_order_calc.

    MOVE-CORRESPONDING it_original_data TO lt_cds.

    LOOP AT lt_cds ASSIGNING FIELD-SYMBOL(<fs_cds>).

      <fs_cds>-moeda = 'USD'.

    ENDLOOP.

    MOVE-CORRESPONDING lt_cds TO ct_calculated_data.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.



  ENDMETHOD.
ENDCLASS.
