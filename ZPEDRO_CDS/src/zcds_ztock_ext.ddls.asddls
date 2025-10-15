@AbapCatalog.sqlViewAppendName: 'ZEXT_ZSTOCK'
@EndUserText.label: 'Extensão ZCDS_ZTOCK'
extend view ZCDS_ZSTOCK with ZCDS_ZTOCK_EXT
{
    dt_atualiz as DataAtualiz
}
