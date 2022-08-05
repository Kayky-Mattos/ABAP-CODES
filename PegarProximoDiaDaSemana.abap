FUNCTION zfm_retorna_grade.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(I_WERKS) TYPE  ZDE_VAREJO
*"  EXPORTING
*"     REFERENCE(E_TAB) TYPE  SYDATUM
*"----------------------------------------------------------------------

  DATA: wa_tab   TYPE zst_data_grade,
        lv_wotnr TYPE p.

  SELECT SINGLE * FROM ztbmm_drp_grdest INTO @DATA(wa_drp_grdest)
  WHERE werks = @i_werks.

  IF sy-subrc IS INITIAL.
    IF wa_drp_grdest-segunda IS NOT INITIAL.
      wa_tab-grade = 1.
    ENDIF.

    IF wa_drp_grdest-terca IS NOT INITIAL.
      wa_tab-grade = 2.
    ENDIF.
    IF wa_drp_grdest-quarta IS NOT INITIAL.
      wa_tab-grade = 3.
    ENDIF.
    IF wa_drp_grdest-quinta IS NOT INITIAL.
      wa_tab-grade = 4.
    ENDIF.
    IF wa_drp_grdest-sexta IS NOT INITIAL.
      wa_tab-grade = 5.
    ENDIF.
    IF wa_drp_grdest-sabado IS NOT INITIAL.
      wa_tab-grade = 6.
    ENDIF.
    IF wa_drp_grdest-domingo IS NOT INITIAL.
      wa_tab-grade = 7.
    ENDIF.

    DATA(lv_datum) = sy-datum.

    DO 7 TIMES.

      CALL FUNCTION 'DAY_IN_WEEK'
        EXPORTING
          datum = lv_datum
        IMPORTING
          wotnr = lv_wotnr.

      IF lv_wotnr EQ wa_tab-grade.
        e_tab = lv_datum.
        EXIT.
      ENDIF.
      lv_datum = lv_datum + 1.

    ENDDO.
  ENDIF.


*  CALL FUNCTION 'RP_CALC_DATE_IN_INTERVAL'
*    EXPORTING
*      date      = sy-datum
*      days      = lv_grade
*      months    = 00
*      years     = 00
*    IMPORTING
*      calc_date = e_tab.

*
*  DO 100 TIMES.
*
*    IF lv_grade-segunda IS NOT INITIAL AND vl_ret <= 1.
*      lv_data = lv_data + 1.
*      wa_tab-grade = lv_data.
*      APPEND wa_tab TO e_tab.
*      lv_cont = lv_cont + 1.
*      IF lv_cont = 5.
*        EXIT.
*      ENDIF.
*    ELSEIF  lv_grade-terca IS NOT INITIAL  AND vl_ret <= 2.
*      lv_data = lv_data + 2.
*      wa_tab-grade = lv_data.
*      APPEND wa_tab TO e_tab.
*      lv_cont = lv_cont + 1.
*      IF lv_cont = 5.
*        EXIT.
*      ENDIF.
**    ELSEIF  lv_grade-quarta IS NOT INITIAL  AND vl_ret <= 3.
*    ELSEIF  lv_grade-quarta IS NOT INITIAL.
*
*      lv_data = lv_data + 7.
*      wa_tab-grade = lv_data.
*      APPEND wa_tab TO e_tab.
*      lv_cont = lv_cont + 1.
*      IF lv_cont = 5.
*        EXIT.
*      ENDIF.
*    ELSEIF lv_grade-quinta IS  NOT INITIAL  AND vl_ret <= 4.
*      lv_data = lv_data + 4.
*      wa_tab-grade = lv_data.
*      APPEND wa_tab TO e_tab.
*      lv_cont = lv_cont + 1.
*      IF lv_cont = 5.
*        EXIT.
*      ENDIF.
*    ELSEIF lv_grade-sexta IS NOT INITIAL  AND vl_ret <= 5.
*      lv_data = lv_data + 5.
*      wa_tab-grade = lv_data.
*      APPEND wa_tab TO e_tab.
*      lv_cont = lv_cont + 1.
*      IF lv_cont = 5.
*        EXIT.
*      ENDIF.
*    ELSEIF  lv_grade-sabado IS NOT INITIAL  AND vl_ret <= 6.
*      lv_data = lv_data + 6.
*      wa_tab-grade = lv_data.
*      APPEND wa_tab TO e_tab.
*      lv_cont = lv_cont + 1.
*      IF lv_cont = 5.
*        EXIT.
*      ENDIF.
*    ELSEIF  lv_grade-domingo IS NOT INITIAL  AND vl_ret <= 7.
*      lv_data = lv_data + 7.
*      wa_tab-grade = lv_data.
*      APPEND wa_tab TO e_tab.
*      lv_cont = lv_cont + 1.
*      IF lv_cont = 5.
*        EXIT.
*      ENDIF.
*    ENDIF.
*
*    vl_ret = vl_ret + 1.
*    IF vl_ret = 7.
*      vl_ret = 1.
*    ENDIF.
*
*  ENDDO.

ENDFUNCTION.