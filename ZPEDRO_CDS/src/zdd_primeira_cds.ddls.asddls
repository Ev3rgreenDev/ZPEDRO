@AbapCatalog.sqlViewName: 'ZV_PRIMEIRA_CDS'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Primeira CDS'
@Metadata.ignorePropagatedAnnotations: true
@OData.publish: true
define view ZDD_PRIMEIRA_CDS as 
select from zmat
{
    key matnr,
    descr,
    unid,
    ativo
}
