*&---------------------------------------------------------------------*
*& Report ZTESTE_KAYKY
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zteste_kayky.

DATA:
  lr_data TYPE REF TO   data,
  lt_col  TYPE          lvc_t_fcat,
  lt_file TYPE TABLE OF string,
  lftab   TYPE filetable,
  lrcount TYPE i.

FIELD-SYMBOLS:
  <fs_tab> TYPE STANDARD TABLE,
  <fs_ws>.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS p_table TYPE dd02l-tabname.
PARAMETERS url     TYPE string.
SELECTION-SCREEN: END OF BLOCK b1.

START-OF-SELECTION.

  CREATE DATA lr_data TYPE TABLE OF (p_table).
  ASSIGN lr_data->* TO <fs_tab>.

  CREATE DATA lr_data LIKE LINE OF <fs_tab>.
  ASSIGN lr_data->* TO <fs_ws>.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = p_table
    CHANGING
      ct_fieldcat      = lt_col.

  IF lrcount <> 0.

    CALL METHOD cl_gui_frontend_services=>gui_upload
      EXPORTING
        filename                = url
*       has_field_separator     = abap_true
      CHANGING
        data_tab                = lt_file
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

    IF sy-subrc = 0.
      LOOP AT lt_file INTO DATA(ws_file).
        SPLIT ws_file AT ';' INTO TABLE DATA(lt_split).

        LOOP AT lt_col INTO DATA(ws_col).
          READ TABLE lt_split INTO DATA(ws_split)
                              INDEX sy-tabix.
          ASSIGN COMPONENT ws_col-fieldname OF STRUCTURE <fs_ws> TO FIELD-SYMBOL(<fs_field>).
          <fs_field> = ws_split.
        ENDLOOP.

        APPEND <fs_ws> TO <fs_tab>.

      ENDLOOP.
      IF sy-subrc = 0.
        MODIFY (p_table) FROM TABLE <fs_tab>.
        MESSAGE 'Dados inseridos com sucesso !' TYPE 'I' DISPLAY LIKE 'S'.
      ELSE.
        MESSAGE 'Os Dados não foram inseridos !' TYPE 'I' DISPLAY LIKE 'E'.
      ENDIF.
    ENDIF.
  ENDIF.



AT SELECTION-SCREEN ON VALUE-REQUEST FOR url.

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

  IF lrcount <> 0.
    READ TABLE lftab INDEX 1 INTO url.
  ENDIF.
