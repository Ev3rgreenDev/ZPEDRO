@AbapCatalog.sqlViewName: 'ZVSDCUSTSH'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Search Help'
@Metadata.ignorePropagatedAnnotations: true
@Search.searchable: true

define view ZI_SD_CUST_SH
  as select from zcust
{
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Código do Cliente'
  key custid,
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'CPF'
  key cpf,
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Nome'
      nome
}
