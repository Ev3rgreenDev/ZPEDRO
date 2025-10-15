@AbapCatalog.sqlViewName: 'ZVWSDITEMSNEW'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Itens das Ordens de vendas'
@Metadata.allowExtensions: true
@ObjectModel:{
                createEnabled: true,
                updateEnabled: true,
                deleteEnabled: true,
                compositionRoot: true,
                writeActivePersistence: 'ZVND_I',
                modelCategory: #BUSINESS_OBJECT,
                transactionalProcessingEnabled: true
}
define view ZI_SD_ITEMS_NEW
  as select from zvnd_i
  association [0..1] to ZI_SD_MATERIAL_NEW as _M on $projection.matnr = _M.matnr
{
  key zvnd_i.vbeln,
  key zvnd_i.posnr,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_MAT',
                                           entity.element: 'matnr' }]
      zvnd_i.matnr,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_LOC',
                                           entity.element: 'locid' }]
      zvnd_i.locid,
      zvnd_i.qty,
      zvnd_i.price,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MOEDA',
                                           entity.element: 'waers' }]
      zvnd_i.currency,
      zvnd_i.val_item,
      zvnd_i.desc_it,
      zvnd_i.val_liq_item,
      _M
}
