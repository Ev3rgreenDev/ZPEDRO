@AbapCatalog.sqlViewName: 'ZVWSDMAT'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Materais das Itens'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SD_MATERIAL
  as select from zmat
{
  key matnr as Matnr,
      descr as Descr,
      unid  as Unid,
      ativo as Ativo
}
