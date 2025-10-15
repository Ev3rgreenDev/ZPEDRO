@AbapCatalog.sqlViewName: 'ZVWSDSSALESORDER'
@AbapCatalog.compiler.compareFilter: true
//@AbapCatalog.preserveKey: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Ordem de venda'
@Metadata.ignorePropagatedAnnotations: true

define view ZI_SD_SALES_ORDER
  as select from ZI_SD_HEADER as H
  association [0..*] to ZI_SD_ITEMS as _I on $projection.Vbeln = _I.Vbeln
  association [0..*] to ZI_SD_CUST  as _C on $projection.Custid = _C.Custid

{
  key Vbeln,
      Custid,
      DataDoc,
      HoraDoc,
      Moeda,
      ValBruto,
      ValDesc,
      ValLiq,
      Status,
      Obs,
      _I,
      _C
}
