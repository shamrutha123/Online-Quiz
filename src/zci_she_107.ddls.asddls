@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quiz Item Interface View'
@Metadata.ignorePropagatedAnnotations: true

define view entity ZCI_SHE_107 
  as select from zci_ite_107 as Questions
  
  /* Link back to the specific Header root entity */
  association to parent ZCI_HE_107 as _QuizHeader 
    on $projection.QuizId = _QuizHeader.QuizId
{
    
    key quiz_id               as QuizId, 
    key question_id           as QuestionId,
    question_text             as QuestionText,
    option_a                  as OptionA,
    option_b                  as OptionB,
    option_c                  as OptionC,
    option_d                  as OptionD,
    correct_answer            as CorrectAnswer,
    difficulty_level          as DifficultyLevel,
    explanation               as Explanation,
    marks                     as Marks,
    
    /* Administrative fields */
    @Semantics.user.createdBy: true
    local_created_by          as LocalCreatedBy,
    @Semantics.systemDateTime.createdAt: true
    local_created_at          as LocalCreatedAt,
    @Semantics.user.lastChangedBy: true
    local_last_changed_by     as LocalLastChangedBy,
    @Semantics.systemDateTime.localInstanceLastChangedAt: true
    local_last_changed_at     as LocalLastChangedAt,
    @Semantics.systemDateTime.lastChangedAt: true
    last_changed_at           as LastChangedAt,
   
   
    _QuizHeader
}
