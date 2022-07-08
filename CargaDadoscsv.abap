REPORT zteste_kayky.

TABLES: ztbsd_ptl_mat.

SELECTION-SCREEN BEGIN OF BLOCK b1 WITH FRAME.

PARAMETERS: url_foto TYPE string.

SELECTION-SCREEN END OF BLOCK b1.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR url_foto.

  DATA: it_arquivo    TYPE TABLE OF string,
        it_portal_mat TYPE  TABLE OF ztbsd_ptl_mat,
        wa_portal_mat TYPE  ztbsd_ptl_mat,
        lftab         TYPE filetable,
        lrcount       TYPE i.

  CALL METHOD cl_gui_frontend_services=>file_open_dialog
    CHANGING
      file_table              = lftab
      rc                      = lrcount
    EXCEPTIONS
      file_open_dialog_failed = 1
      cntl_error              = 2
      error_no_gui            = 3
      not_supported_by_gui    = 4
      OTHERS                  = 5.

  IF lrcount > 0.
    READ TABLE lftab INDEX 1 INTO url_foto.

    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = url_foto
*       filetype                = 'ASC'
        has_field_separator     = abap_true
      CHANGING
        data_tab                = it_arquivo
      EXCEPTIONS
        file_open_error         = 1
        file_read_error         = 2
        no_batch                = 3
        gui_refuse_filetransfer = 4
        invalid_type            = 5
        no_authority            = 6
        unknown_error           = 7
        bad_data_format         = 8
        header_not_allowed      = 9
        separator_not_allowed   = 10
        header_too_long         = 11
        unknown_dp_error        = 12
        access_denied           = 13
        dp_out_of_memory        = 14
        disk_full               = 15
        dp_timeout              = 16
        not_supported_by_gui    = 17
        error_no_gui            = 18
        OTHERS                  = 19.
    ENDIF.

    IF sy-subrc = 0.
      LOOP AT it_arquivo  INTO DATA(wa_arquivo).
        SPLIT wa_arquivo AT ';' INTO wa_portal_mat-matnr wa_portal_mat-url_foto.

        APPEND wa_portal_mat TO it_portal_mat.

        CLEAR wa_portal_mat.
      ENDLOOP.
      MODIFY ztbsd_ptl_mat FROM TABLE it_portal_mat.
    IF lrcount > 0.
      MESSAGE 'Dados inseridos com sucesso !' TYPE 'I' DISPLAY LIKE 'S'.
    ELSE.
      MESSAGE 'Os Dados não foram inseridos !' TYPE 'I' DISPLAY LIKE 'E'.
    ENDIF.
    ENDIF.