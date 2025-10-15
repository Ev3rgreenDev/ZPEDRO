@AbapCatalog.sqlViewName: 'ZVWSDHEADER'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header da Ordem de vendas'
@Metadata.ignorePropagatedAnnotations: true

define view ZI_SD_HEADER
  as select from zvnd_h
{
  key vbeln     as Vbeln,
      custid    as Custid,
      data_doc  as DataDoc,
      hora_doc  as HoraDoc,
      moeda     as Moeda,
      val_bruto as ValBruto,
      val_desc  as ValDesc,
      val_liq   as ValLiq,
      status    as Status,
      obs       as Obs
}
