*&---------------------------------------------------------------------*
*& Report zteste_kayky
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT zteste_kayky.

DATA:
  lr_data TYPE REF TO   data,
  lt_col  TYPE          lvc_t_fcat,
  lt_file TYPE TABLE OF string.

FIELD-SYMBOLS:
  <fs_tab> TYPE STANDARD TABLE,
  <fs_ws>.

SELECTION-SCREEN: BEGIN OF BLOCK b1 WITH FRAME TITLE TEXT-001.
PARAMETERS p_table TYPE dd02l-tabname.
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

  CALL FUNCTION 'GUI_UPLOAD'
    EXPORTING
      filename = 'D:\One Drive\OneDrive\Área de Trabalho\spfli.csv'
    TABLES
      data_tab = lt_file.

  DELETE lt_col WHERE fieldname = 'MANDT'.

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

  BREAK-POINT.