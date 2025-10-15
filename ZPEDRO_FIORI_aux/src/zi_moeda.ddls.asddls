@AbapCatalog.sqlViewName: 'ZVMOEDA'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Moeda'
@Metadata.allowExtensions: true
@Search.searchable: true

define view ZI_MOEDA
  as select from tcurt
{
      @UI.hidden: true
  key spras,
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Código'
  key waers,
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Descrição'
      ltext
}
where
  spras = 'E'
