@AbapCatalog.sqlViewName: 'ZVWSDCUSTNEW'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Clientes da Ordem de vendas'
@Metadata.allowExtensions: true
@ObjectModel:{
                createEnabled: true,
                updateEnabled: true,
                deleteEnabled: true,
                compositionRoot: true,
                writeActivePersistence: 'ZCUST',
                modelCategory: #BUSINESS_OBJECT,
                transactionalProcessingEnabled: true
}

define view ZI_SD_CUST_NEW
  as select from zcust
{
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_SD_CUST_SH',
                                           entity.element: 'custid' }]
  key zcust.custid,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_SD_CUST_SH',
                                           entity.element: 'cpf' }]
  key zcust.cpf,
      @Consumption.valueHelpDefinition: [{ entity.name: 'ZI_SD_CUST_SH',
                                           entity.element: 'nome' }]
      zcust.nome,
      zcust.ativo
}
