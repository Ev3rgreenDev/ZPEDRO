@AbapCatalog.sqlViewName: 'ZVMMSTOCKNAV'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Estoque com navegação'
@Metadata.allowExtensions: true
@ObjectModel:{
              createEnabled: true,
              updateEnabled: true,
              deleteEnabled: true,
              compositionRoot: true,
              writeActivePersistence: 'ZSTOCK',
              modelCategory: #BUSINESS_OBJECT,
              transactionalProcessingEnabled: true
}
define view ZI_MM_STOCK_NAV
  as select from ZI_MM_STOCK
  association [1..1] to ZI_MM_MAT as _mat on  $projection.matnr = _mat.matnr
  association [1..1] to ZI_MM_LOC as _loc on  $projection.locid = _loc.locid
  association [1..*] to ZI_MM_MOV as _mov on  $projection.locid = _mov.locid
                                          and $projection.matnr = _mov.matnr
  association [1..*] to ZI_MM_INV as _inv on  $projection.locid = _inv.locid
                                          and $projection.matnr = _inv.matnr
{
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_MAT',
                                           entity.element: 'matnr' }]
  key matnr,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_LOC',
                                           entity.element: 'locid' }]
  key locid,
      qty,
      dt_atualiz,
      _mat,
      _loc,
      _mov,
      _inv
}
