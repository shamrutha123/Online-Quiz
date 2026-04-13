CLASS lhc_QuizHeader DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR QuizHeader RESULT result.

    METHODS get_global_authorizations FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations FOR QuizHeader RESULT result.

    METHODS create FOR MODIFY
      IMPORTING entities FOR CREATE QuizHeader.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE QuizHeader.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE QuizHeader.

    METHODS read FOR READ
      IMPORTING keys FOR READ QuizHeader RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK QuizHeader.

    METHODS rba_Questions FOR READ
      IMPORTING keys_rba FOR READ QuizHeader\_Questions FULL result_requested RESULT result LINK association_links.

    METHODS cba_Questions FOR MODIFY
      IMPORTING entities_cba FOR CREATE QuizHeader\_Questions.
ENDCLASS.

CLASS lhc_QuizHeader IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
  ENDMETHOD.

  METHOD create.
    DATA: ls_quiz_hdr TYPE zci_dt_107.
    DATA(lo_util) = zci_u_107=>get_instance( ).

    LOOP AT entities INTO DATA(ls_entity).
      " Map incoming entity (CamelCase) to DB structure (snake_case)
      ls_quiz_hdr = CORRESPONDING #( ls_entity MAPPING FROM ENTITY ).

      " Move to Singleton Buffer
      lo_util->set_quiz_hdr(
        EXPORTING im_quiz_hdr = ls_quiz_hdr
        IMPORTING ex_created  = DATA(lv_created)
      ).

      " Report mapped ID back to framework for Draft handling
      IF lv_created = abap_true.
        APPEND VALUE #( %cid   = ls_entity-%cid
                        quizid = ls_quiz_hdr-quiz_id ) TO mapped-quizheader.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD update.
    DATA: ls_quiz_hdr TYPE zci_dt_107.
    DATA(lo_util) = zci_u_107=>get_instance( ).

    LOOP AT entities INTO DATA(ls_entity).
      " Retrieve current buffer state
      lo_util->get_quiz_hdr( IMPORTING ex_quiz_hdr = ls_quiz_hdr ).

      " Merge updates into existing buffer data
      ls_quiz_hdr = CORRESPONDING #( BASE ( ls_quiz_hdr ) ls_entity MAPPING FROM ENTITY ).

      " Update Buffer
      lo_util->set_quiz_hdr( EXPORTING im_quiz_hdr = ls_quiz_hdr ).
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    LOOP AT keys INTO DATA(ls_key).
      " Mark for deletion in buffer
      zci_u_107=>get_instance( )->set_hdr_deletion_flag( abap_true ).
      zci_u_107=>get_instance( )->set_hdr_t_deletion(
        im_quiz_key = VALUE #( quiz_id = ls_key-QuizId )
      ).
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    " CRITICAL: Required for 'Edit' and 'Draft' to work
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE * FROM zci_dt_107
        WHERE quiz_id = @ls_key-QuizId
        INTO @DATA(ls_db_data).

      IF sy-subrc = 0.
        " Convert DB fields back to Entity fields
        APPEND CORRESPONDING #( ls_db_data MAPPING TO ENTITY ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD lock.
    " Standard lock master implementation
  ENDMETHOD.

  METHOD rba_Questions.
    " Read By Association logic
  ENDMETHOD.

  METHOD cba_Questions.
    DATA: ls_quiz_itm TYPE zci_ite_107.
    DATA(lo_util) = zci_u_107=>get_instance( ).

    LOOP AT entities_cba INTO DATA(ls_entity_cba).
      LOOP AT ls_entity_cba-%target INTO DATA(ls_target).
        ls_quiz_itm = CORRESPONDING #( ls_target MAPPING FROM ENTITY ).
        ls_quiz_itm-quiz_id = ls_entity_cba-QuizId.

        lo_util->set_quiz_itm( EXPORTING im_quiz_itm = ls_quiz_itm ).

        APPEND VALUE #( %cid       = ls_target-%cid
                        quizid     = ls_quiz_itm-quiz_id
                        questionid = ls_quiz_itm-question_id ) TO mapped-quizquestion.
      ENDLOOP.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
