FUNCTION zfm_retorna_grade.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(I_WERKS) TYPE  ZDE_VAREJO
*"  EXPORTING
*"     REFERENCE(E_TAB) TYPE  SYDATUM
*"----------------------------------------------------------------------

  DATA: wa_tab   TYPE zst_data_grade,
        lv_wotnr TYPE p,
        lv_ret   TYPE p.

  SELECT SINGLE * FROM ztbmm_drp_grdest INTO @DATA(wa_drp_grdest)
  WHERE werks = @i_werks.
*
  IF sy-subrc IS INITIAL.
    IF wa_drp_grdest-segunda IS NOT INITIAL.
      wa_tab-grade = 1.
    ELSEIF wa_drp_grdest-terca IS NOT INITIAL.
      wa_tab-grade = 2.
    ELSEIF wa_drp_grdest-quarta IS NOT INITIAL.
      wa_tab-grade = 3.
    ELSEIF wa_drp_grdest-quinta IS NOT INITIAL.
      wa_tab-grade = 4.
    ELSEIF wa_drp_grdest-sexta IS NOT INITIAL.
      wa_tab-grade = 5.
    ELSEIF wa_drp_grdest-sabado IS NOT INITIAL.
      wa_tab-grade = 6.
    ELSEIF wa_drp_grdest-domingo IS NOT INITIAL.
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
        IF sy-index = 1.
          e_tab = lv_datum + 7.
        ELSE.
          e_tab = lv_datum.
        ENDIF.
        EXIT.
      ELSE.
        lv_datum = lv_datum + 1.
      ENDIF.
    ENDDO.
  ENDIF.

ENDFUNCTION.
