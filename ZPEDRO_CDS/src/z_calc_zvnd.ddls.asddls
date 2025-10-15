@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Cálculos em ZVND'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_CALc_ZVND
  as select from zvnd_i
{
  key vbeln,
      currency,
      //      @Semantics.amount.currencyCode: 'currency'
      //      val_item,
      //      @Semantics.amount.currencyCode: 'currency'
      //      desc_it,
      @Semantics.amount.currencyCode: 'currency'
      sum(val_item) as Soma,
      @Semantics.amount.currencyCode: 'currency'
      min(val_item) as Minimo
}
group by
  vbeln,
  currency
  having vbeln = '0000000001' // diferente do where não apga o registros antes da agrupação
