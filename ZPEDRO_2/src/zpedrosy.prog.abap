*&---------------------------------------------------------------------*
*& Report ZPEDROSY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT ZPEDROSY.

*comentario que começa na primeira coluna

WRITE: /001 sy-uline,
       /001 sy-datum, "data local
       060
       sy-uzeit, "hora local
       /030 'Hello World.',
       /001 sy-uline.
