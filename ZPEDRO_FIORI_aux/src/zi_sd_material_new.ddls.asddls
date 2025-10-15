@AbapCatalog.sqlViewName: 'ZVWSDMATNEW'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Materais das Itens'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
@ObjectModel:{
                createEnabled: true,
                updateEnabled: true,
                deleteEnabled: true,
                compositionRoot: true,
                writeActivePersistence: 'ZMAT',
                modelCategory: #BUSINESS_OBJECT,
                transactionalProcessingEnabled: true
}
define view ZI_SD_MATERIAL_NEW
  as select from zmat
{
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_MAT',
                                           entity.element: 'matnr' }]
  key matnr,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_MAT',
                                               entity.element: 'descr' }]
      descr,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_UNID_SEARCH_HELP',
                                           entity.element: 'msehi' }]
      zmat.unid,
      zmat.ativo
}
