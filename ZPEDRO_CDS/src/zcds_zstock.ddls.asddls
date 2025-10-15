@AbapCatalog.sqlViewName: 'ZV_ZSTOCK'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Busca dados da tabela ZSTOCK'
@Metadata.ignorePropagatedAnnotations: true
define view ZCDS_ZSTOCK as select from zstock
{
    key matnr as Matnr,
    key locid as Locid,
    qty as Qty
}
