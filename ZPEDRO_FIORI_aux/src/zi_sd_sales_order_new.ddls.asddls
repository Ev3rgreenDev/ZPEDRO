@AbapCatalog.sqlViewName: 'ZVWSDS0NEW'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ordem de venda'
@Metadata.allowExtensions: true
@ObjectModel:{
                createEnabled: true,
                updateEnabled: true,
                deleteEnabled: true,
                compositionRoot: true,
                writeActivePersistence: 'ZVND_H',
                modelCategory: #BUSINESS_OBJECT,
                transactionalProcessingEnabled: true
}

define view ZI_SD_SALES_ORDER_NEW
  as select from ZI_SD_HEADER_NEW
  association [1..*] to ZI_SD_ITEMS_NEW as _I on $projection.vbeln = _I.vbeln
  association [0..*] to ZI_SD_CUST_NEW  as _C on $projection.custid = _C.custid

{
  key ZI_SD_HEADER_NEW.vbeln,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_SD_CUST_SH',
                                           entity.element: 'custid' }]
      ZI_SD_HEADER_NEW.custid,
      ZI_SD_HEADER_NEW.data_doc,
      ZI_SD_HEADER_NEW.hora_doc,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MOEDA',
                                           entity.element: 'waers' }]
      ZI_SD_HEADER_NEW.moeda,
      ZI_SD_HEADER_NEW.val_bruto,
      ZI_SD_HEADER_NEW.val_desc,
      ZI_SD_HEADER_NEW.val_liq,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_STATUS',
                                           additionalBinding: [{
                                               element: 'domname',
                                               localConstant: 'ZD_STATUS',
                                               usage: #FILTER
                                           }],
                                           entity.element: 'domvalue_l' }]
      ZI_SD_HEADER_NEW.status,
      ZI_SD_HEADER_NEW.obs,
      _I,
      _C
}
