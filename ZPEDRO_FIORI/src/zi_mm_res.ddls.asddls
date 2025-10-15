@AbapCatalog.sqlViewName: 'ZVMMRES'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Reservas'
@Metadata.allowExtensions: true
@ObjectModel:{
              createEnabled: true,
              updateEnabled: true,
              deleteEnabled: true,
              compositionRoot: true,
              writeActivePersistence: 'zres',
              modelCategory: #BUSINESS_OBJECT,
              transactionalProcessingEnabled: true
}
define view ZI_MM_RES
  as select from zres
  association [1..1] to ZI_MM_MAT as _mat on $projection.matnr = _mat.matnr
  association [1..1] to ZI_MM_LOC as _loc on $projection.locid = _loc.locid
{
  key idres,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_mat',
                                               entity.element: 'matnr' }]
      matnr,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_LOC',
                                           entity.element: 'locid' }]
      locid,
      qty_res,
      data,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_STATUS',
                                           additionalBinding: [{
                                               element: 'domname',
                                               localConstant: 'ZD_STAT_RES',
                                               usage: #FILTER
                                           }],
                                           entity.element: 'domvalue_l' }]
      status,
      _mat,
      _loc
}
