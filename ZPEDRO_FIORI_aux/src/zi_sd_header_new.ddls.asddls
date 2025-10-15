@AbapCatalog.sqlViewName: 'ZVWSDHEADERNEW'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Header da Ordem de vendas'
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

define view ZI_SD_HEADER_NEW
  as select from zvnd_h
{
  key zvnd_h.vbeln,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_SD_CUST_SH',
                                               entity.element: 'custid' }]
      zvnd_h.custid,
      zvnd_h.data_doc,
      zvnd_h.hora_doc,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_MOEDA',
                                           entity.element: 'waers' }]
      zvnd_h.moeda,
      zvnd_h.val_bruto,
      zvnd_h.val_desc,
      zvnd_h.val_liq,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_STATUS',
                                           additionalBinding: [{
                                               element: 'domname',
                                               localConstant: 'ZD_STATUS',
                                               usage: #FILTER
                                           }],
                                           entity.element: 'domvalue_l' }]
      zvnd_h.status,
      zvnd_h.obs
}
