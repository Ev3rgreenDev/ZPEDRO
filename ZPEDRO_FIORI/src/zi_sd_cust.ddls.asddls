@AbapCatalog.sqlViewName: 'ZVWSDCUST'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Clientes da Ordem de vendas'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SD_CUST
  as select from zcust
{
  key custid as Custid,
  key cpf    as Cpf,
      nome   as Nome,
      ativo  as Ativo
}
