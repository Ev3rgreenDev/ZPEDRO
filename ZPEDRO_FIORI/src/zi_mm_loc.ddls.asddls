@AbapCatalog.sqlViewName: 'ZVMMLOC'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Locais'
@Metadata.allowExtensions: true
@ObjectModel: {
            createEnabled: true,
            updateEnabled: true,
            deleteEnabled: true,
            compositionRoot: true,
            writeActivePersistence: 'zloc',
            modelCategory: #BUSINESS_OBJECT,
            transactionalProcessingEnabled: true
}
define view ZI_MM_LOC
  as select from zloc
{
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_LOC',
                                           entity.element: 'locid' }]
  key locid,
      descr,
      ativo
}
