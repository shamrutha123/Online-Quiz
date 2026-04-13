@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quiz Header Interface View'
@Metadata.ignorePropagatedAnnotations: true

define root view entity ZCI_HE_107 
  as select from zci_dt_107 as QuizHeader
  
  /* Composition defines the relationship to the child Questions */
  composition [0..*] of ZCI_SHE_107 as _Questions 
{
    key quiz_id               as QuizId,
    quiz_title                as QuizTitle,
    description               as Description,
    subject                   as Subject,
    category                  as Category,
    total_marks               as TotalMarks,
    passing_marks             as PassingMarks,
    duration_minutes          as DurationMinutes,
    number_of_questions       as NumberOfQuestions,
    start_date                as StartDate,
    end_date                  as EndDate,
    negative_marks            as NegativeMarks,
    
    /* Administrative fields with required RAP semantics */
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
    
    /* Exposing association to child */
    _Questions 
}
