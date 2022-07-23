FUNCTION zfm_upload_tab.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(I_TAB) TYPE
*"        ZCL_ZGW_ESTOQUE_VAR_02_MPC_EXT=>TS_DEEP_ENTITY
*"----------------------------------------------------------------------

  DATA:
    lr_data  TYPE REF TO   data,
    lt_col   TYPE          lvc_t_fcat,
    tab_name TYPE dd02l-tabname.

  FIELD-SYMBOLS:
    <fs_tab> TYPE STANDARD TABLE,
    <fs_ws>.

  tab_name = i_tab-nome_tabela.

  CREATE DATA lr_data TYPE TABLE OF (i_tab-nome_tabela).
  ASSIGN lr_data->* TO <fs_tab>.

  CREATE DATA lr_data LIKE LINE OF <fs_tab>.
  ASSIGN lr_data->* TO <fs_ws>.

  CALL FUNCTION 'LVC_FIELDCATALOG_MERGE'
    EXPORTING
      i_structure_name = tab_name
    CHANGING
      ct_fieldcat      = lt_col.

  DELETE lt_col WHERE fieldname = 'MANDT'.

  LOOP AT i_tab-ZTB_TABELANAV ASSIGNING FIELD-SYMBOL(<f_ZTB_TABELANAV>).

    SPLIT <f_ZTB_TABELANAV>-VALOR AT ';' INTO TABLE DATA(lt_split).

    LOOP AT lt_col INTO DATA(ws_col).
      READ TABLE lt_split INTO DATA(ws_split)
                          INDEX sy-tabix.
      ASSIGN COMPONENT ws_col-fieldname OF STRUCTURE <fs_ws> TO FIELD-SYMBOL(<fs_field>).
      <fs_field> = ws_split.
    ENDLOOP.

    APPEND <fs_ws> TO <fs_tab>.

  ENDLOOP.

  MODIFY (i_tab-nome_tabela) FROM TABLE <fs_tab>.




ENDFUNCTION.