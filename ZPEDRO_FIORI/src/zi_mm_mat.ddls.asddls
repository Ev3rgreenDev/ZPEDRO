@AbapCatalog.sqlViewName: 'ZVMMMAT'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Materiais'
@Metadata.allowExtensions: true
@ObjectModel: {
            createEnabled: true,
            updateEnabled: true,
            deleteEnabled: true,
            compositionRoot: true,
            writeActivePersistence: 'zmat',
            modelCategory: #BUSINESS_OBJECT,
            transactionalProcessingEnabled: true
}
define view ZI_MM_MAT
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
      unid,
      ativo
}
