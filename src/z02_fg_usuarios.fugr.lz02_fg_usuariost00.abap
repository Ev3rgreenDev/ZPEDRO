*---------------------------------------------------------------------*
*    view related data declarations
*---------------------------------------------------------------------*
*...processing: ZCUST...........................................*
DATA:  BEGIN OF STATUS_ZCUST                         .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZCUST                         .
CONTROLS: TCTRL_ZCUST
            TYPE TABLEVIEW USING SCREEN '9013'.
*...processing: ZINV............................................*
DATA:  BEGIN OF STATUS_ZINV                          .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZINV                          .
CONTROLS: TCTRL_ZINV
            TYPE TABLEVIEW USING SCREEN '9010'.
*...processing: ZLOC............................................*
DATA:  BEGIN OF STATUS_ZLOC                          .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZLOC                          .
CONTROLS: TCTRL_ZLOC
            TYPE TABLEVIEW USING SCREEN '9007'.
*...processing: ZMAT............................................*
DATA:  BEGIN OF STATUS_ZMAT                          .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMAT                          .
CONTROLS: TCTRL_ZMAT
            TYPE TABLEVIEW USING SCREEN '9006'.
*...processing: ZMOV............................................*
DATA:  BEGIN OF STATUS_ZMOV                          .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZMOV                          .
CONTROLS: TCTRL_ZMOV
            TYPE TABLEVIEW USING SCREEN '9009'.
*...processing: ZPRICE..........................................*
DATA:  BEGIN OF STATUS_ZPRICE                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZPRICE                        .
CONTROLS: TCTRL_ZPRICE
            TYPE TABLEVIEW USING SCREEN '9014'.
*...processing: ZRES............................................*
DATA:  BEGIN OF STATUS_ZRES                          .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZRES                          .
CONTROLS: TCTRL_ZRES
            TYPE TABLEVIEW USING SCREEN '9011'.
*...processing: ZSTOCK..........................................*
DATA:  BEGIN OF STATUS_ZSTOCK                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSTOCK                        .
CONTROLS: TCTRL_ZSTOCK
            TYPE TABLEVIEW USING SCREEN '9008'.
*...processing: ZSTOCK_AUX......................................*
DATA:  BEGIN OF STATUS_ZSTOCK_AUX                    .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZSTOCK_AUX                    .
CONTROLS: TCTRL_ZSTOCK_AUX
            TYPE TABLEVIEW USING SCREEN '9012'.
*...processing: ZT02_CONTA_CPF..................................*
DATA:  BEGIN OF STATUS_ZT02_CONTA_CPF                .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZT02_CONTA_CPF                .
CONTROLS: TCTRL_ZT02_CONTA_CPF
            TYPE TABLEVIEW USING SCREEN '9003'.
*...processing: ZT02_FINANCEIRO.................................*
DATA:  BEGIN OF STATUS_ZT02_FINANCEIRO               .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZT02_FINANCEIRO               .
CONTROLS: TCTRL_ZT02_FINANCEIRO
            TYPE TABLEVIEW USING SCREEN '9001'.
*...processing: ZT02_FINANCEIRO2................................*
DATA:  BEGIN OF STATUS_ZT02_FINANCEIRO2              .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZT02_FINANCEIRO2              .
CONTROLS: TCTRL_ZT02_FINANCEIRO2
            TYPE TABLEVIEW USING SCREEN '9002'.
*...processing: ZT02_USUARIO....................................*
DATA:  BEGIN OF STATUS_ZT02_USUARIO                  .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZT02_USUARIO                  .
CONTROLS: TCTRL_ZT02_USUARIO
            TYPE TABLEVIEW USING SCREEN '9000'.
*...processing: ZTACC...........................................*
DATA:  BEGIN OF STATUS_ZTACC                         .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTACC                         .
CONTROLS: TCTRL_ZTACC
            TYPE TABLEVIEW USING SCREEN '9004'.
*...processing: ZTACC_TX........................................*
DATA:  BEGIN OF STATUS_ZTACC_TX                      .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZTACC_TX                      .
CONTROLS: TCTRL_ZTACC_TX
            TYPE TABLEVIEW USING SCREEN '9005'.
*...processing: ZVND_H..........................................*
DATA:  BEGIN OF STATUS_ZVND_H                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVND_H                        .
CONTROLS: TCTRL_ZVND_H
            TYPE TABLEVIEW USING SCREEN '9015'.
*...processing: ZVND_I..........................................*
DATA:  BEGIN OF STATUS_ZVND_I                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVND_I                        .
CONTROLS: TCTRL_ZVND_I
            TYPE TABLEVIEW USING SCREEN '9016'.
*...processing: ZVND_P..........................................*
DATA:  BEGIN OF STATUS_ZVND_P                        .   "state vector
         INCLUDE STRUCTURE VIMSTATUS.
DATA:  END OF STATUS_ZVND_P                        .
CONTROLS: TCTRL_ZVND_P
            TYPE TABLEVIEW USING SCREEN '9017'.
*.........table declarations:.................................*
TABLES: *ZCUST                         .
TABLES: *ZINV                          .
TABLES: *ZLOC                          .
TABLES: *ZMAT                          .
TABLES: *ZMOV                          .
TABLES: *ZPRICE                        .
TABLES: *ZRES                          .
TABLES: *ZSTOCK                        .
TABLES: *ZSTOCK_AUX                    .
TABLES: *ZT02_CONTA_CPF                .
TABLES: *ZT02_FINANCEIRO               .
TABLES: *ZT02_FINANCEIRO2              .
TABLES: *ZT02_USUARIO                  .
TABLES: *ZTACC                         .
TABLES: *ZTACC_TX                      .
TABLES: *ZVND_H                        .
TABLES: *ZVND_I                        .
TABLES: *ZVND_P                        .
TABLES: ZCUST                          .
TABLES: ZINV                           .
TABLES: ZLOC                           .
TABLES: ZMAT                           .
TABLES: ZMOV                           .
TABLES: ZPRICE                         .
TABLES: ZRES                           .
TABLES: ZSTOCK                         .
TABLES: ZSTOCK_AUX                     .
TABLES: ZT02_CONTA_CPF                 .
TABLES: ZT02_FINANCEIRO                .
TABLES: ZT02_FINANCEIRO2               .
TABLES: ZT02_USUARIO                   .
TABLES: ZTACC                          .
TABLES: ZTACC_TX                       .
TABLES: ZVND_H                         .
TABLES: ZVND_I                         .
TABLES: ZVND_P                         .

* general table data declarations..............
  INCLUDE LSVIMTDT                                .
