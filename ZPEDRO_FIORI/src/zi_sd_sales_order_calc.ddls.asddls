@AbapCatalog.sqlViewName: 'ZVWSDSALESORDERC'
@AbapCatalog.compiler.compareFilter: true
@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ordem de venda'
@Metadata.ignorePropagatedAnnotations: true
define view ZI_SD_SALES_ORDER_CALC
  as select from ZI_SD_HEADER as H
  association [0..*] to ZI_SD_ITEMS as _I on $projection.Vbeln = _I.Vbeln
  association [0..*] to ZI_SD_CUST  as _C on $projection.Custid = _C.Custid

{
  key Vbeln,
      Custid,
      DataDoc,
      HoraDoc,
      //      Moeda,
      @ObjectModel.virtualElement: true
      @ObjectModel.virtualElementCalculatedBy: 'ZCL_CDS_CALC_FIELD'
      cast( '' as ze_cuky5 ) as Moeda,
      ValBruto,
      ValDesc,
      ValLiq,
      Status,
      Obs,
      _I,
      _C
}
