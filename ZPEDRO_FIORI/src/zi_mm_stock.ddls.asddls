@AbapCatalog.sqlViewName: 'ZVMMSOTCK'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Estoque'
@Metadata.allowExtensions: true
@ObjectModel:{
            createEnabled: true,
            updateEnabled: true,
            deleteEnabled: true,
            compositionRoot: true,
            writeActivePersistence: 'zstock',
            modelCategory: #BUSINESS_OBJECT,
            transactionalProcessingEnabled: true
}
define view ZI_MM_STOCK
  as select from zstock
{
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_MAT',
                                                 entity.element: 'matnr' }]
  key matnr,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_LOC',
                                           entity.element: 'locid' }]
  key locid,
      qty,
      dt_atualiz
}
