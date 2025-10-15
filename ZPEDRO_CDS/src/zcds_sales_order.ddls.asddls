@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'SALES ORDER'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity ZCDS_SALES_ORDER
  as

  select from       zvnd_h as H
    left outer join zvnd_i as I on  H.vbeln    = I.vbeln
                                and I.currency = 'BRL'
    left outer join zcust  as C on H.custid = C.custid
    left outer join zmat   as M on I.matnr = M.matnr
{
  key H.vbeln        as Vbeln,
  key C.custid       as Custid,
  key C.cpf          as Cpf,
  key I.vbeln        as Pedido,
  key I.posnr        as Posnr,
      H.custid       as ID_CLiente,
      H.data_doc     as DataDoc,
      H.hora_doc     as HoraDoc,
      H.moeda        as Moeda,
      @Semantics.amount.currencyCode: 'moeda'
      H.val_bruto    as ValBruto,
      @Semantics.amount.currencyCode: 'moeda'
      H.val_desc     as ValDesc,
      @Semantics.amount.currencyCode: 'moeda'
      H.val_liq      as ValLiq,
      H.status       as Status,
      H.obs          as Obs,
      C.nome         as Nome,
      C.ativo        as Ativo,
      M.descr        as Descr,
      M.unid         as Unid,
      I.matnr        as Matnr,
      I.locid        as Locid,
      @Semantics.quantity.unitOfMeasure: 'Unid'
      I.qty          as Qty,
      @Semantics.amount.currencyCode: 'moeda'
      I.price        as Price,
      I.currency     as Currency,
      @Semantics.amount.currencyCode: 'moeda'
      I.val_item     as ValItem,
      @Semantics.amount.currencyCode: 'moeda'
      I.desc_it      as DescIt,
      @Semantics.amount.currencyCode: 'moeda'
      I.val_liq_item as ValLiqItem
}
