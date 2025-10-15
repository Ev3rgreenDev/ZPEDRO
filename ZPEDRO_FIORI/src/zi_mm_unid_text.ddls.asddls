@AbapCatalog.sqlViewName: 'ZVMMUNIDTEXT'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unid search help'
@Metadata.allowExtensions: true

@ObjectModel.dataCategory: #TEXT
@Search.searchable: true

define view ZI_MM_UNID_TEXT
  as select from t006a
{
      @Semantics.language: true
  key spras,
      @Semantics.text: true
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Unidade'
  key msehi
}
