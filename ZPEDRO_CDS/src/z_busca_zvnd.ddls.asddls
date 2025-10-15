@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Busca dados da tabela ZVND com WHERE'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.usageType:{
    serviceQuality: #X,
    sizeCategory: #S,
    dataClass: #MIXED
}
define view entity Z_BUSCA_ZVND
//  with parameters
//    clientNumber : vbeln
  as select from zvnd_h
  association [1..*] to zvnd_i as _itens on  _itens.vbeln = zvnd_h.vbeln
                                         and _itens.matnr = '000000000000000029'
{
  key vbeln,
      //      count(*) as Total_pedidos,
      custid,
      data_doc,
      hora_doc,
      moeda,
      cast(val_bruto as abap.dec(15,2))                                                 as valBruto,
      cast(val_desc  as abap.dec(15,2)) * 10                                            as valDesc,
      ( cast(val_bruto as abap.dec(15,2)) - cast(val_desc  as abap.dec(15,2)) * 10 )    as Vlr_liq,
//      min(val_bruto) as Menor_venda,
//      max(val_bruto) as Maior_venda,
      status,
      case status
      when 'O' then
            case moeda
            when 'BRL' then 'Pedido aberto - em Real'
            when 'USD' then 'Pedido aberto - em Dólar'
            else 'Pedido aberto - Outro'
            end
      when 'F' then 'Pedido fechado'
      else 'Outro'
      end                                                                               as Status_do_pedido,
      obs,
      $session.client                                                                   as Mandante,
      $session.system_date                                                              as Data_relat,
      $session.system_language                                                          as Idioma,
      $session.user                                                                     as Usuario,
      _itens
}
//group by val_bruto
//where
//  vbeln = $parameters.clientNumber
//where data_doc between '20250901' and '20259030'
//and hora_doc between '120000' and '180000'
//group by
//  vbeln,
//  custid,
//  data_doc,
//  hora_doc,
//  moeda,
//  status,
//  obs
