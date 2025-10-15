@AbapCatalog.sqlViewName: 'ZVMMUNIDSH'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Unidade de Medida'
@Metadata.allowExtensions: true

@ObjectModel.dataCategory: #VALUE_HELP
@Search.searchable: true

define view ZI_MM_UNID_SEARCH_HELP
  as select from t006a
{
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Código'
  key msehi,
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Descrição'
      msehl
}
where
  spras = 'E'
