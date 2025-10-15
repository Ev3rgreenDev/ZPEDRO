@AbapCatalog.sqlViewName: 'ZVMMMOV'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Movimentações'
@Metadata.allowExtensions: true
@ObjectModel: {
            updateEnabled: true,
            compositionRoot: true,
            writeActivePersistence: 'zmov',
            modelCategory: #BUSINESS_OBJECT,
            transactionalProcessingEnabled: true
}
define view ZI_MM_MOV
  as select from zmov
  association [1..1] to ZI_MM_MAT as _mat on $projection.matnr = _mat.matnr
  association [1..1] to ZI_MM_LOC as _loc on $projection.locid = _loc.locid
{
  key idmov,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_mat',
                                               entity.element: 'matnr' }]
      matnr,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_LOC',
                                           entity.element: 'locid' }]
      locid,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_STATUS',
                                           additionalBinding: [{
                                               element: 'domname',
                                               localConstant: 'ZD_TPMOV',
                                               usage: #FILTER
                                           }],
                                           entity.element: 'domvalue_l' }]
      tpmov,
      qty,
      data,
      hora,
      obs,
      loc_dest,
      _mat,
      _loc
}
