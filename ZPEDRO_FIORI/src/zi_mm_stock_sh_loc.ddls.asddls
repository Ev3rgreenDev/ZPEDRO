@AbapCatalog.sqlViewName: 'ZVMMSHLOC'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Local do Estoque'
@Metadata.allowExtensions: true
@Search.searchable: true

define view ZI_MM_STOCK_SH_LOC
  as select from zloc
{
      @Semantics.text: true
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Código'
  key locid,
      @Semantics.text: true
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Descrição'
      descr
}
