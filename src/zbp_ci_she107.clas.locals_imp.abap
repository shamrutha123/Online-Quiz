CLASS lhc_QuizQuestion DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    METHODS update FOR MODIFY IMPORTING entities FOR UPDATE QuizQuestion.
    METHODS delete FOR MODIFY IMPORTING keys FOR DELETE QuizQuestion.
    METHODS read FOR READ IMPORTING keys FOR READ QuizQuestion RESULT result.
    METHODS rba_Quizheader FOR READ IMPORTING keys_rba FOR READ QuizQuestion\_Quizheader FULL result_requested RESULT result LINK association_links.
ENDCLASS.

CLASS lhc_QuizQuestion IMPLEMENTATION.
  METHOD update.
    DATA: ls_quiz_itm TYPE zci_ite_107.
    DATA(lo_util) = zci_u_107=>get_instance( ).

    LOOP AT entities INTO DATA(ls_entity).
      lo_util->get_quiz_itm( IMPORTING ex_quiz_itm = ls_quiz_itm ).
      ls_quiz_itm = CORRESPONDING #( BASE ( ls_quiz_itm ) ls_entity MAPPING FROM ENTITY ).
      lo_util->set_quiz_itm( EXPORTING im_quiz_itm = ls_quiz_itm ).
    ENDLOOP.
  ENDMETHOD.

  METHOD delete.
    DATA: ls_quiz_itm_key TYPE zci_u_107=>ty_quiz_item.
    DATA(lo_util) = zci_u_107=>get_instance( ).

    LOOP AT keys INTO DATA(ls_key).
      ls_quiz_itm_key-quiz_id     = ls_key-QuizId.
      ls_quiz_itm_key-question_id = ls_key-QuestionId.
      lo_util->set_itm_t_deletion( im_item_key = ls_quiz_itm_key ).

      APPEND VALUE #( quizid = ls_key-QuizId
                      questionid = ls_key-QuestionId
                      %msg = new_message( id = 'SY' number = '000' severity = if_abap_behv_message=>severity-success v1 = 'Question Deleted' )
                    ) TO reported-quizquestion.
    ENDLOOP.
  ENDMETHOD.

  METHOD read.
    LOOP AT keys INTO DATA(ls_key).
      SELECT SINGLE * FROM zci_ite_107 WHERE quiz_id = @ls_key-QuizId AND question_id = @ls_key-QuestionId INTO @DATA(ls_itm).
      IF sy-subrc = 0.
        APPEND CORRESPONDING #( ls_itm MAPPING TO ENTITY ) TO result.
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

  METHOD rba_Quizheader.
  ENDMETHOD.
ENDCLASS.
