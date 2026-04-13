@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Quiz Item Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@Search.searchable: true

define view entity ZCI_SHE1_107
  as projection on ZCI_SHE_107
{
    key QuizId,
    key QuestionId,
    
    @Search.defaultSearchElement: true
    QuestionText,
    
    OptionA,
    OptionB,
    OptionC,
    OptionD,
    CorrectAnswer,
    DifficultyLevel,
    Explanation,
    Marks,
    
    LocalCreatedBy,
    LocalCreatedAt,
    LocalLastChangedBy,
    LocalLastChangedAt,
    LastChangedAt,
    
    
    _QuizHeader : redirected to parent ZCI_HE1_107
}
