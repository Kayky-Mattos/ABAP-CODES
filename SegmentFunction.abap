*&---------------------------------------------------------------------*
*& Report ZSEGMENT_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zsegment_test.


SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS: indx TYPE i.
SELECTION-SCREEN: END OF BLOCK b1.


DATA lv_data TYPE string VALUE 'Kaio,Kayky,Kaue'.
                                " 1     2     3 "
TRY.
    DATA(lv_result) = segment( val = lv_data index = indx sep = ',' ).
  CATCH  cx_sy_strg_par_val.
    WRITE: 'O valor' ,indx, 'não existe no segmento !'.
ENDTRY.
WRITE: lv_result.

* Com um simples TRY CATCH podemos tratar o dumping que estava dando ao o usuario digitar um valor que
* não possuia no segmento 
