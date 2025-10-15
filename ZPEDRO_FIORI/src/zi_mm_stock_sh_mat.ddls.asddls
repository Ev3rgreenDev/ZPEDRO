@AbapCatalog.sqlViewName: 'ZVMMSHMAT'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Material'
@Metadata.allowExtensions: true
@Search.searchable: true

define view ZI_MM_STOCK_SH_MAT
  as select from zmat
{
      @Semantics.text: true
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Código'
  key matnr,
      @Semantics.text: true
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Descrição'
      descr

}
