@AbapCatalog.sqlViewName: 'ZVSTATUS'
@AbapCatalog.compiler.compareFilter: true
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: '##GENERATED Status (###)'
@Metadata.allowExtensions: true
@Search.searchable: true

define view ZI_STATUS
  as select from dd07t
{
      @UI.hidden: true
  key ddlanguage,
      @UI.hidden: true
  key as4local,
      @UI.hidden: true
  key as4vers,
      @UI.hidden: true
  key valpos,
      @UI.hidden: true
  key domname,

      @Semantics.text: true
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Descrição'
      ddtext,

      @Semantics.text: true
      @Search.fuzzinessThreshold: 0.8
      @Search.defaultSearchElement: true
      @EndUserText.label: 'Código'
      domvalue_l

}
where
  ddlanguage = 'E'
