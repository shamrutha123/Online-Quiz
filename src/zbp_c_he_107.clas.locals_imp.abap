CLASS lsc_zci_he_107 DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.
    METHODS finalize REDEFINITION.
    METHODS check_before_save REDEFINITION.
    METHODS save REDEFINITION.
    METHODS cleanup REDEFINITION.
    METHODS cleanup_finalize REDEFINITION.
ENDCLASS.

CLASS lsc_zci_he_107 IMPLEMENTATION.
  METHOD finalize.
  ENDMETHOD.

  METHOD check_before_save.
  ENDMETHOD.

  METHOD save.
    DATA(lo_util) = zci_u_107=>get_instance( ).

    lo_util->get_quiz_hdr( IMPORTING ex_quiz_hdr = DATA(ls_quiz_hdr) ).
    lo_util->get_quiz_itm( IMPORTING ex_quiz_itm = DATA(ls_quiz_itm) ).
    lo_util->get_hdr_t_deletion( IMPORTING ex_quiz_docs = DATA(lt_quiz_hdr_del) ).
    lo_util->get_itm_t_deletion( IMPORTING ex_item_keys = DATA(lt_quiz_itm_del) ).
    lo_util->get_deletion_flags( IMPORTING ex_quiz_hdr_del = DATA(lv_quiz_del_flag) ).

    " 1. Save Header
    IF ls_quiz_hdr-quiz_id IS NOT INITIAL.
      MODIFY zci_dt_107 FROM @ls_quiz_hdr.
    ENDIF.

    " 2. Save Item
    IF ls_quiz_itm-question_id IS NOT INITIAL.
      MODIFY zci_ite_107 FROM @ls_quiz_itm.
    ENDIF.

    " 3. Handle Deletions
    IF lv_quiz_del_flag = abap_true.
      IF lt_quiz_hdr_del IS NOT INITIAL.
        LOOP AT lt_quiz_hdr_del INTO DATA(ls_del_hdr).
          DELETE FROM zci_dt_107 WHERE quiz_id = @ls_del_hdr-quiz_id.
          DELETE FROM zci_ite_107 WHERE quiz_id = @ls_del_hdr-quiz_id.
        ENDLOOP.
      ENDIF.
    ELSE.
      IF lt_quiz_itm_del IS NOT INITIAL.
        LOOP AT lt_quiz_itm_del INTO DATA(ls_del_itm).
          DELETE FROM zci_ite_107 WHERE quiz_id = @ls_del_itm-quiz_id AND question_id = @ls_del_itm-question_id.
        ENDLOOP.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD cleanup.
    zci_u_107=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.

  METHOD cleanup_finalize.
    zci_u_107=>get_instance( )->cleanup_buffer( ).
  ENDMETHOD.
ENDCLASS.
