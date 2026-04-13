@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quiz Header Consumption View'
@Search.searchable: true
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true

define root view entity ZCI_HE1_107 
  provider contract transactional_query
  as projection on ZCI_HE_107
{
    @Search.defaultSearchElement: true
    key QuizId,
    
    @Search.defaultSearchElement: true
    QuizTitle,
    
    Description,
    Subject,
    Category,
    TotalMarks,
    PassingMarks,
    DurationMinutes,
    NumberOfQuestions,
    StartDate,
    EndDate,
    NegativeMarks,
    
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    
   
    _Questions : redirected to composition child ZCI_SHE1_107
}
