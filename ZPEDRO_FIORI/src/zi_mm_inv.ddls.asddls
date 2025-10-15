@AbapCatalog.sqlViewName: 'ZVMMINV'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Inventário'
@Metadata.allowExtensions: true
@ObjectModel:{
              createEnabled: true,
              updateEnabled: true,
              deleteEnabled: true,
              compositionRoot: true,
              writeActivePersistence: 'ZINV',
              modelCategory: #BUSINESS_OBJECT,
              transactionalProcessingEnabled: true
}
define view ZI_MM_INV
  as select from zinv
  association to ZI_MM_STOCK_SH_LOC as _searchLoc on $projection.locid = _searchLoc.locid
  association to ZI_MM_STOCK_SH_MAT as _searchMat on $projection.matnr = _searchMat.matnr
{
  key idinv,
      @Consumption.valueHelp: '_searchMat'
      matnr,
      @Consumption.valueHelp: '_searchLoc'
      locid,
      qty_contada,
      data_cont,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MM_STOCK_SH_STATUS',
                                           additionalBinding: [{
                                               element: 'domname',
                                               localConstant: 'ZD_STAT_INV',
                                               usage: #FILTER
                                           }],
                                           entity.element: 'domvalue_l' }]
      status,
      _searchLoc,
      _searchMat
}
