CLASS zci_u_107 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.
    TYPES: BEGIN OF ty_quiz_hdr,
             quiz_id TYPE zci_dt_107-quiz_id,
           END OF ty_quiz_hdr.

    TYPES: BEGIN OF ty_quiz_item,
             quiz_id     TYPE zci_ite_107-quiz_id,
             question_id TYPE zci_ite_107-question_id,
           END OF ty_quiz_item.

    TYPES: tt_quiz_header TYPE STANDARD TABLE OF ty_quiz_hdr  WITH DEFAULT KEY,
           tt_quiz_items  TYPE STANDARD TABLE OF ty_quiz_item WITH DEFAULT KEY.

    CLASS-METHODS get_instance RETURNING VALUE(ro_instance) TYPE REF TO zci_u_107.

    " Methods for Header Buffer
    METHODS set_quiz_hdr IMPORTING im_quiz_hdr TYPE zci_dt_107 EXPORTING ex_created TYPE abap_boolean.
    METHODS get_quiz_hdr EXPORTING ex_quiz_hdr TYPE zci_dt_107.

    " Methods for Item Buffer
    METHODS set_quiz_itm IMPORTING im_quiz_itm TYPE zci_ite_107 EXPORTING ex_created TYPE abap_boolean.
    METHODS get_quiz_itm EXPORTING ex_quiz_itm TYPE zci_ite_107.

    " Methods for Deletions (Matching Saver Parameter Names)
    METHODS set_hdr_deletion_flag IMPORTING im_quiz_delete TYPE abap_boolean.
    METHODS get_deletion_flags    EXPORTING ex_quiz_hdr_del TYPE abap_boolean.

    METHODS set_hdr_t_deletion    IMPORTING im_quiz_key TYPE ty_quiz_hdr.
    METHODS get_hdr_t_deletion    EXPORTING ex_quiz_docs TYPE tt_quiz_header.

    METHODS set_itm_t_deletion    IMPORTING im_item_key TYPE ty_quiz_item.
    METHODS get_itm_t_deletion    EXPORTING ex_item_keys TYPE tt_quiz_items.

    METHODS cleanup_buffer.

  PRIVATE SECTION.
    CLASS-DATA: go_instance TYPE REF TO zci_u_107.
    DATA: ms_quiz_hdr     TYPE zci_dt_107,
          ms_quiz_itm     TYPE zci_ite_107,
          mv_quiz_del     TYPE abap_boolean,
          mt_quiz_header  TYPE tt_quiz_header,
          mt_quiz_items   TYPE tt_quiz_items.
ENDCLASS.

CLASS zci_u_107 IMPLEMENTATION.

  METHOD get_instance.
    IF go_instance IS NOT BOUND.
      go_instance = NEW #( ).
    ENDIF.
    ro_instance = go_instance.
  ENDMETHOD.

  METHOD set_quiz_hdr.
    IF ms_quiz_hdr-quiz_id IS INITIAL OR ms_quiz_hdr-quiz_id = im_quiz_hdr-quiz_id.
      ms_quiz_hdr = CORRESPONDING #( BASE ( ms_quiz_hdr ) im_quiz_hdr ).

      " Administrative Fields & ETag Logic
      IF ms_quiz_hdr-local_created_by IS INITIAL.
        ms_quiz_hdr-local_created_by = sy-uname.
      ENDIF.
      IF ms_quiz_hdr-local_created_at IS INITIAL.
        GET TIME STAMP FIELD ms_quiz_hdr-local_created_at.
      ENDIF.

      ms_quiz_hdr-local_last_changed_by = sy-uname.
      GET TIME STAMP FIELD ms_quiz_hdr-local_last_changed_at.
      GET TIME STAMP FIELD ms_quiz_hdr-last_changed_at.

      ex_created = abap_true.
    ELSE.
      ex_created = abap_false.
    ENDIF.
  ENDMETHOD.

  METHOD get_quiz_hdr.
    ex_quiz_hdr = ms_quiz_hdr.
  ENDMETHOD.

  METHOD set_quiz_itm.
    ms_quiz_itm = CORRESPONDING #( BASE ( ms_quiz_itm ) im_quiz_itm ).

    IF ms_quiz_itm-local_created_by IS INITIAL.
        ms_quiz_itm-local_created_by = sy-uname.
    ENDIF.

    ms_quiz_itm-local_last_changed_by = sy-uname.
    GET TIME STAMP FIELD ms_quiz_itm-local_last_changed_at.
    GET TIME STAMP FIELD ms_quiz_itm-last_changed_at.

    ex_created = abap_true.
  ENDMETHOD.

  METHOD get_quiz_itm.
    ex_quiz_itm = ms_quiz_itm.
  ENDMETHOD.

  METHOD set_hdr_deletion_flag.
    mv_quiz_del = im_quiz_delete.
  ENDMETHOD.

  METHOD get_deletion_flags.
    " Renamed to match Saver call: EX_QUIZ_HDR_DEL
    ex_quiz_hdr_del = mv_quiz_del.
  ENDMETHOD.

  METHOD set_hdr_t_deletion.
    APPEND im_quiz_key TO mt_quiz_header.
  ENDMETHOD.

  METHOD get_hdr_t_deletion.
    " Renamed to match Saver call: EX_QUIZ_DOCS
    ex_quiz_docs = mt_quiz_header.
  ENDMETHOD.

  METHOD set_itm_t_deletion.
    APPEND im_item_key TO mt_quiz_items.
  ENDMETHOD.

  METHOD get_itm_t_deletion.
    " Match Saver call: EX_ITEM_KEYS
    ex_item_keys = mt_quiz_items.
  ENDMETHOD.

  METHOD cleanup_buffer.
    CLEAR: ms_quiz_hdr, ms_quiz_itm, mv_quiz_del, mt_quiz_header, mt_quiz_items.
  ENDMETHOD.
ENDCLASS.
