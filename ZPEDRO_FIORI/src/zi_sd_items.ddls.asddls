@AbapCatalog.sqlViewName: 'ZVWSDITEMS'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Itens das Ordens de vendas'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SD_ITEMS
  as select from zvnd_i
  association [0..1] to ZI_SD_MATERIAL as _M on $projection.Matnr = _M.Matnr
{
  key vbeln        as Vbeln,
  key posnr        as Posnr,
      matnr        as Matnr,
      locid        as Locid,
      qty          as Qty,
      price        as Price,
      currency     as Currency,
      val_item     as ValItem,
      desc_it      as DescIt,
      val_liq_item as ValLiqItem,
      _M
}
