/* VHDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief Medipix Bridge
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! Bridge de comunicacao com o chip medipix
--!
--! DETAILS:      
--!
--!- Project Name: Medipix_Bridge.v                       
--!- Module Name: Medipix_Bridge
--!- Tools: Quartus II 10.0 SP1 
--!- Author: Franz Wagner
--!- Company: LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--!- Create Date: 2/12/2013     
--!- Version: 1.0.0 (Dez/2013) 
--------------------------------------------------------------------------------
-- LNLS - DET - 2013
--------------------------------------------------------------------------------
--}}} Header*/

module Medipix_Bridge (

      //--------------------------------------------------------------------------------------------
		//-- input
		//--------------------------------------------------------------------------------------------

		input               In_Reset,
		input               In_Clk_nios,

		input               In_En_nios,
		input               In_Sync_nios,
		input  [7:0]        In_Data_nios,
	
		//--------------------------------------------------------------------------------------------
		//-- output
		//--------------------------------------------------------------------------------------------
		output [2:0]        Out_M,

		output              Out_Reset_Mdpx,
		
		output              Out_Clk_Mdpx,
		output              Out_Data_Mdpx,
		output              Out_En_Mdpx,
		output              Out_Shutter_Mdpx,
		output              Out_Cont_sel_Mdpx,
		output              Out_MtxClr_Mdpx,
		output              Out_TPSWT_Mdpx
	
);
		
		// REGISTROS DO CHIP 48 bits
		wire   [2:0]         w_M;
		wire                 w_CRW_SRW;
		wire                 w_POLARITY;
		wire   [1:0]         w_PS;
		wire                 w_DISC_CSM_SPM;
		wire                 w_ENABLE_TP;
		wire   [1:0]         w_COUNT_L;
		wire   [2:0]         w_COLUMN_BLOCK;
		wire                 w_COLUMN_BLOCKSEL;
		wire   [2:0]         w_ROW_BLOCK;
		wire                 w_ROW_BLOCKSEL;
		wire                 w_EQUALIZATION;
		wire                 w_COLOUR_MODE;
		wire                 w_CSM_SPM;
		wire                 w_INFO_HEADER;
		wire   [5:0]         w_FUSE_SEL;
		wire   [5:0]         w_FUSE_PULSE_WD;
		wire   [1:0]         w_GAIN_MODE;
		wire                 w_SENSE_DAC;
		wire                 w_EXT_DAC;
		wire                 w_EXT_BG_SEL;
		wire                 w_send_omr;
		wire                 w_send_ldac;
		wire                 w_send_rdac;
		wire                 w_send_lctpr;
		wire                 w_send_lch;
		wire                 w_send_rch;
		wire                 w_send_dacs;
		wire   [2:0]         w_out_M;
		
		//thresholds e dacs
		wire   [8:0]         w_threshold0;
	   wire   [8:0]         w_threshold1;
		wire   [8:0]         w_threshold2;
      wire   [8:0]         w_threshold3;
		wire   [8:0]         w_threshold4;
		wire   [8:0]         w_threshold5;
		wire   [8:0]         w_threshold6;
		wire   [8:0]         w_threshold7;
		wire   [7:0]         w_preamp;
		wire   [7:0]         w_ikrum;
		wire   [7:0]         w_shaper;
		wire   [7:0]         w_disc;
		wire   [7:0]         w_discls;
		wire   [7:0]         w_shaper_test;
		wire   [7:0]         w_dac_discl;
		wire   [7:0]         w_dac_test;
		wire   [7:0]         w_dac_disch;
		wire   [7:0]         w_delay;
		wire   [7:0]         w_tp_buffer_in;
		wire   [7:0]         w_tp_buffer_out;
		wire   [7:0]         w_rpz;
		wire   [7:0]         w_gnd;
		wire   [7:0]         w_tp_ref;
		wire   [7:0]         w_fbk;
		wire   [7:0]         w_cas;
		wire   [8:0]         w_tp_refa;
		wire   [8:0]         w_tp_refb;
		
		// 
      wire                 sig_Clk_Mdpx_OMR;
		wire                 sig_Reset_Mdpx_OMR;
		wire                 sig_Data_Mdpx_OMR;
		wire                 sig_En_Mdpx_OMR;
		wire                 sig_Shutter_Mdpx_OMR;
		wire                 sig_Cont_sel_Mdpx_OMR;
		wire                 sig_MtxClr_Mdpx_OMR;
		wire                 sig_TPSWT_Mdpx_OMR;
		
		wire                 sig_Clk_Mdpx_LD;
		wire                 sig_Reset_Mdpx_LD;
		wire                 sig_Data_Mdpx_LD;
		wire                 sig_En_Mdpx_LD;
		wire                 sig_Shutter_Mdpx_LD;
		wire                 sig_Cont_sel_Mdpx_LD;
		wire                 sig_MtxClr_Mdpx_LD;
		wire                 sig_TPSWT_Mdpx_LD;
		
		wire                 sig_Clk_Mdpx_RD;
		wire                 sig_Reset_Mdpx_RD;
		wire                 sig_Data_Mdpx_RD;
		wire                 sig_En_Mdpx_RD;
		wire                 sig_Shutter_Mdpx_RD;
		wire                 sig_Cont_sel_Mdpx_RD;
		wire                 sig_MtxClr_Mdpx_RD;
		wire                 sig_TPSWT_Mdpx_RD;
		
		wire                 sig_Clk_Mdpx_LCTPR;
		wire                 sig_Reset_Mdpx_LCTPR;
		wire                 sig_Data_Mdpx_LCTPR;
		wire                 sig_En_Mdpx_LCTPR;
		wire                 sig_Shutter_Mdpx_LCTPR;
		wire                 sig_Cont_sel_Mdpx_LCTPR;
		wire                 sig_MtxClr_Mdpx_LCTPR;
		wire                 sig_TPSWT_Mdpx_LCTPR;
		
		wire                 sig_Clk_Mdpx_LCH;
		wire                 sig_Reset_Mdpx_LCH;
		wire                 sig_Data_Mdpx_LCH;
		wire                 sig_En_Mdpx_LCH;
		wire                 sig_Shutter_Mdpx_LCH;
		wire                 sig_Cont_sel_Mdpx_LCH;
		wire                 sig_MtxClr_Mdpx_LCH;
		wire                 sig_TPSWT_Mdpx_LCH;
		
		wire                 sig_Clk_Mdpx_RCH;
		wire                 sig_Reset_Mdpx_RCH;
		wire                 sig_Data_Mdpx_RCH;
		wire                 sig_En_Mdpx_RCH;
		wire                 sig_Shutter_Mdpx_RCH;
		wire                 sig_Cont_sel_Mdpx_RCH;
		wire                 sig_MtxClr_Mdpx_RCH;
		wire                 sig_TPSWT_Mdpx_RCH;
		
	   assign  Out_M = w_out_M;
		
		Decoder_Parametros u_Decoder_Parametros (

            .In_Reset                                     (In_Reset),
				.In_Clk_nios                                  (In_Clk_nios),
				.In_Data_nios                                 (In_Data_nios),
				.In_En_nios                                   (In_En_nios),
				.In_Sync_nios                                 (In_Sync_nios),

				.Out_M                                        (w_M),
				.Out_CRW_SRW                                  (w_CRW_SRW),
				.Out_POLARITY                                 (w_POLARITY),
				.Out_PS                                       (w_PS),
				.Out_DISC_CSM_SPM                             (w_DISC_CSM_SPM),
				.Out_ENABLE_TP                                (w_ENABLE_TP),
				.Out_COUNT_L                                  (w_COUNT_L),
				.Out_COLUMN_BLOCK                             (w_COLUMN_BLOCK),
				.Out_COLUMN_BLOCKSEL                          (w_COLUMN_BLOCKSEL),
				.Out_ROW_BLOCK                                (w_ROW_BLOCK),
				.Out_ROW_BLOCKSEL                             (w_ROW_BLOCKSEL),
				.Out_EQUALIZATION                             (w_EQUALIZATION),
				.Out_COLOUR_MODE                              (w_COLOUR_MODE),
				.Out_CSM_SPM                                  (w_CSM_SPM),
				.Out_INFO_HEADER                              (w_INFO_HEADER),
				.Out_FUSE_SEL                                 (w_FUSE_SEL),
				.Out_FUSE_PULSE_WD                            (w_FUSE_PULSE_WD),
				.Out_GAIN_MODE                                (w_GAIN_MODE),
				.Out_SENSE_DAC                                (w_SENSE_DAC),
				.Out_EXT_DAC                                  (w_EXT_DAC),
				.Out_EXT_BG_SEL                               (w_EXT_BG_SEL),
				.Out_Send_OMR                                 (w_send_omr),
				.Out_Send_LDac                                (w_send_ldac),
				.Out_Send_RDac                                (w_send_rdac),
				.Out_Send_LCtpr                               (w_send_lctpr),
				.Out_Send_LCH                                 (w_send_lch),
				.Out_Send_RCH                                 (w_send_rch)
				
				);
				
		Decoder_Dacs u_Decoder_Dacs (

            .In_Reset                                     (In_Reset),
				.In_Clk_nios                                  (In_Clk_nios),
				.In_Data_nios                                 (In_Data_nios),
				.In_En_nios                                   (In_En_nios),
				.In_Sync_nios                                 (In_Sync_nios),

				.Out_Threshold_0                              (w_threshold0),
				.Out_Threshold_1                              (w_threshold1),
				.Out_Threshold_2                              (w_threshold2),
				.Out_Threshold_3                              (w_threshold3),
				.Out_Threshold_4                              (w_threshold4),
				.Out_Threshold_5                              (w_threshold5),
				.Out_Threshold_6                              (w_threshold6),
				.Out_Threshold_7                              (w_threshold7),
				.Out_Preamp                                   (w_preamp),
				.Out_Ikrum                                    (w_ikrum),
				.Out_Shaper                                   (w_shaper),
				.Out_Disc                                     (w_disc),
				.Out_DiscLS                                   (w_discls),
				.Out_Shaper_Test                              (w_shaper_test),
				.Out_DAC_DiscL                                (w_dac_discl),
				.Out_DAC_Test                                 (w_dac_test),
				.Out_DAC_DiscH                                (w_dac_disch),
				.Out_Delay                                    (w_delay),
				.Out_TP_Buffer_In                             (w_tp_buffer_in),
				.Out_TP_Buffer_Out                            (w_tp_buffer_out),
				.Out_Rpz                                      (w_rpz),
				.Out_Gnd                                      (w_gnd),
				.Out_TP_Ref                                   (w_tp_ref),
				.Out_Fbk                                      (w_fbk),
				.Out_Cas                                      (w_cas),
				.Out_TP_RefA                                  (w_tp_refa),
				.Out_TP_RefB                                  (w_tp_refb),
				
				.Out_Send_DACS                                (w_send_dacs)
				
				);
				
		Gera_M u_Gera_M (
		
		      .In_Reset                                     (In_Reset),
	         .In_Clk_nios                                  (In_Clk_nios),
	
	         .In_Send_OMR                                  (w_send_omr),
	         .In_Send_LDac                                 (w_send_ldac),
	         .In_Send_RDac                                 (w_send_rdac),
	         .In_Send_LCtpr                                (w_send_lctpr),
	         .In_Send_LCH                                  (w_send_lch),
	         .In_Send_RCH                                  (w_send_rch),
	
	         .In_Send_DACS                                 (w_send_dacs),
	
	         .Out_M                                        (w_out_M)
		
		);
				
		Select_Output u_Select_Output (
		      
				.In_Clk                                       (In_Clk_nios),
				.In_Reset                                     (In_Reset),
				.In_M                                         (w_out_M),

				.In_Clk_Mdpx_OMR                              (sig_Clk_Mdpx_OMR),
				.In_Reset_Mdpx_OMR                            (sig_Reset_Mdpx_OMR),
				.In_Data_Mdpx_OMR                             (sig_Data_Mdpx_OMR),
				.In_En_Mdpx_OMR                               (sig_En_Mdpx_OMR),
				.In_Shutter_Mdpx_OMR                          (sig_Shutter_Mdpx_OMR),
				.In_Cont_sel_Mdpx_OMR                         (sig_Cont_sel_Mdpx_OMR),
				.In_MtxClr_Mdpx_OMR                           (sig_MtxClr_Mdpx_OMR),
				.In_TPSWT_Mdpx_OMR                            (sig_TPSWT_Mdpx_OMR),
	
				.In_Clk_Mdpx_LD                               (sig_Clk_Mdpx_LD),
				.In_Reset_Mdpx_LD                             (sig_Reset_Mdpx_LD),
				.In_Data_Mdpx_LD                              (sig_Data_Mdpx_LD),
				.In_En_Mdpx_LD                                (sig_En_Mdpx_LD),
				.In_Shutter_Mdpx_LD                           (sig_Shutter_Mdpx_LD),
				.In_Cont_sel_Mdpx_LD                          (sig_Cont_sel_Mdpx_LD),
				.In_MtxClr_Mdpx_LD                            (sig_MtxClr_Mdpx_LD),
				.In_TPSWT_Mdpx_LD                             (sig_TPSWT_Mdpx_LD),
				
				.In_Clk_Mdpx_RD                               (sig_Clk_Mdpx_RD),
				.In_Reset_Mdpx_RD                             (sig_Reset_Mdpx_RD),
				.In_Data_Mdpx_RD                              (sig_Data_Mdpx_RD),
				.In_En_Mdpx_RD                                (sig_En_Mdpx_RD),
				.In_Shutter_Mdpx_RD                           (sig_Shutter_Mdpx_RD),
				.In_Cont_sel_Mdpx_RD                          (sig_Cont_sel_Mdpx_RD),
				.In_MtxClr_Mdpx_RD                            (sig_MtxClr_Mdpx_RD),
				.In_TPSWT_Mdpx_RD                             (sig_TPSWT_Mdpx_RD),
				
				.In_Clk_Mdpx_LCTPR                            (sig_Clk_Mdpx_LCTPR),
				.In_Reset_Mdpx_LCTPR                          (sig_Reset_Mdpx_LCTPR),
				.In_Data_Mdpx_LCTPR                           (sig_Data_Mdpx_LCTPR),
				.In_En_Mdpx_LCTPR                             (sig_En_Mdpx_LCTPR),
				.In_Shutter_Mdpx_LCTPR                        (sig_Shutter_Mdpx_LCTPR),
				.In_Cont_sel_Mdpx_LCTPR                       (sig_Cont_sel_Mdpx_LCTPR),
				.In_MtxClr_Mdpx_LCTPR                         (sig_MtxClr_Mdpx_LCTPR),
				.In_TPSWT_Mdpx_LCTPR                          (sig_TPSWT_Mdpx_LCTPR),
				
				.In_Clk_Mdpx_LCH                              (sig_Clk_Mdpx_LCH),
				.In_Reset_Mdpx_LCH                            (sig_Reset_Mdpx_LCH),
				.In_Data_Mdpx_LCH                             (sig_Data_Mdpx_LCH),
				.In_En_Mdpx_LCH                               (sig_En_Mdpx_LCH),
				.In_Shutter_Mdpx_LCH                          (sig_Shutter_Mdpx_LCH),
				.In_Cont_sel_Mdpx_LCH                         (sig_Cont_sel_Mdpx_LCH),
				.In_MtxClr_Mdpx_LCH                           (sig_MtxClr_Mdpx_LCH),
				.In_TPSWT_Mdpx_LCH                            (sig_TPSWT_Mdpx_LCH),
				
				.In_Clk_Mdpx_RCH                              (sig_Clk_Mdpx_RCH),
				.In_Reset_Mdpx_RCH                            (sig_Reset_Mdpx_RCH),
				.In_Data_Mdpx_RCH                             (sig_Data_Mdpx_RCH),
				.In_En_Mdpx_RCH                               (sig_En_Mdpx_RCH),
				.In_Shutter_Mdpx_RCH                          (sig_Shutter_Mdpx_RCH),
				.In_Cont_sel_Mdpx_RCH                         (sig_Cont_sel_Mdpx_RCH),
				.In_MtxClr_Mdpx_RCH                           (sig_MtxClr_Mdpx_RCH),
				.In_TPSWT_Mdpx_RCH                            (sig_TPSWT_Mdpx_RCH),
	
				.Out_Clk_Medipix                              (Out_Clk_Mdpx),
				.Out_Reset_Mdpx                               (Out_Reset_Mdpx),
				.Out_Data_Mdpx                                (Out_Data_Mdpx),
				.Out_En_Mdpx                                  (Out_En_Mdpx),
				.Out_Shutter_Mdpx                             (Out_Shutter_Mdpx),
				.Out_Cont_sel_Mdpx                            (Out_Cont_sel_Mdpx),
				.Out_MtxClr_Mdpx                              (Out_MtxClr_Mdpx),
				.Out_TPSWT_Mdpx                               (Out_TPSWT_Mdpx)
		
		);

		//assign Out_Clk_Mdpx=~In_Clk_nios;
		
		Gera_Rajada_OMR u_Gera_Rajada_OMR (

				.In_Reset                                      (In_Reset),
				.In_Clk                                        (In_Clk_nios),
				.In_Send                                       (w_send_omr),
				
				.In_M                                          (w_M),
				.In_CRW_SRW                                    (w_CRW_SRW),
				.In_POLARITY                                   (w_POLARITY),
				.In_PS                                         (w_PS),
				.In_DISC_CSM_SPM                               (w_DISC_CSM_SPM),
				.In_ENABLE_TP                                  (w_ENABLE_TP),
				.In_COUNT_L                                    (w_COUNT_L),
				.In_COLUMN_BLOCK                               (w_COLUMN_BLOCK),
				.In_COLUMN_BLOCKSEL                            (w_COLUMN_BLOCKSEL),
				.In_ROW_BLOCK                                  (w_ROW_BLOCK),
				.In_ROW_BLOCKSEL                               (w_ROW_BLOCKSEL),
				.In_EQUALIZATION                               (w_EQUALIZATION),
				.In_COLOUR_MODE                                (w_COLOUR_MODE),
				.In_CSM_SPM                                    (w_CSM_SPM),
				.In_INFO_HEADER                                (w_INFO_HEADER),
				.In_FUSE_SEL                                   (w_FUSE_SEL),
				.In_FUSE_PULSE_WD                              (w_FUSE_PULSE_WD),
				.In_GAIN_MODE                                  (w_GAIN_MODE),
				.In_SENSE_DAC                                  (w_SENSE_DAC),
				.In_EXT_DAC                                    (w_EXT_DAC),
				.In_EXT_BG_SEL                                 (w_EXT_BG_SEL),

				.Out_Clk_Medipix                               (sig_Clk_Mdpx_OMR),
            .Out_Reset_Mdpx                                (sig_Reset_Mdpx_OMR),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_OMR),
            .Out_En_Mdpx                                   (sig_En_Mdpx_OMR),
            .Out_Shutter_Mdpx                              (sig_Shutter_Mdpx_OMR),
            .Out_Cont_sel_Mdpx                             (sig_Cont_sel_Mdpx_OMR),
            .Out_MtxClr_Mdpx                               (sig_MtxClr_Mdpx_OMR),
            .Out_TPSWT_Mdpx                                (sig_TPSWT_Mdpx_OMR)
				
            );
				
		Gera_Rajada_Load_DAC u_Gera_Rajada_Load_DAC (

				.In_Reset                                      (In_Reset),
				.In_Clk                                        (In_Clk_nios),
				.In_Send                                       (w_send_ldac | w_send_dacs),
				
				.In_M                                          (w_M),
				.In_CRW_SRW                                    (w_CRW_SRW),
				.In_POLARITY                                   (w_POLARITY),
				.In_PS                                         (w_PS),
				.In_DISC_CSM_SPM                               (w_DISC_CSM_SPM),
				.In_ENABLE_TP                                  (w_ENABLE_TP),
				.In_COUNT_L                                    (w_COUNT_L),
				.In_COLUMN_BLOCK                               (w_COLUMN_BLOCK),
				.In_COLUMN_BLOCKSEL                            (w_COLUMN_BLOCKSEL),
				.In_ROW_BLOCK                                  (w_ROW_BLOCK),
				.In_ROW_BLOCKSEL                               (w_ROW_BLOCKSEL),
				.In_EQUALIZATION                               (w_EQUALIZATION),
				.In_COLOUR_MODE                                (w_COLOUR_MODE),
				.In_CSM_SPM                                    (w_CSM_SPM),
				.In_INFO_HEADER                                (w_INFO_HEADER),
				.In_FUSE_SEL                                   (w_FUSE_SEL),
				.In_FUSE_PULSE_WD                              (w_FUSE_PULSE_WD),
				.In_GAIN_MODE                                  (w_GAIN_MODE),
				.In_SENSE_DAC                                  (w_SENSE_DAC),
				.In_EXT_DAC                                    (w_EXT_DAC),
				.In_EXT_BG_SEL                                 (w_EXT_BG_SEL),
				
				.In_Threshold_0                                (w_threshold0),
	         .In_Threshold_1                                (w_threshold1),
				.In_Threshold_2                                (w_threshold2),
				.In_Threshold_3                                (w_threshold3),
				.In_Threshold_4                                (w_threshold4),
				.In_Threshold_5                                (w_threshold5),
				.In_Threshold_6                                (w_threshold6),
				.In_Threshold_7                                (w_threshold7),
				.In_Preamp                                     (w_preamp),
				.In_Ikrum                                      (w_ikrum),
				.In_Shaper                                     (w_shaper),
				.In_Disc                                       (w_disc),
				.In_DiscLS                                     (w_discls),
				.In_Shaper_Test                                (w_shaper_test),
				.In_DAC_DiscL                                  (w_dac_discl),
				.In_DAC_Test                                   (w_dac_test),
				.In_DAC_DiscH                                  (w_dac_disch),
				.In_Delay                                      (w_delay),
				.In_TP_Buffer_In                               (w_tp_buffer_in),
				.In_TP_Buffer_Out                              (w_tp_buffer_out),
				.In_Rpz                                        (w_rpz),
				.In_Gnd                                        (w_gnd),
				.In_TP_Ref                                     (w_tp_ref),
				.In_Fbk                                        (w_fbk),
				.In_Cas                                        (w_cas),
				.In_TP_RefA                                    (w_tp_refa),
				.In_TP_RefB                                    (w_tp_refb),

				.Out_Clk_Medipix                               (sig_Clk_Mdpx_LD),
            .Out_Reset_Mdpx                                (sig_Reset_Mdpx_LD),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_LD),
            .Out_En_Mdpx                                   (sig_En_Mdpx_LD),
            .Out_Shutter_Mdpx                              (sig_Shutter_Mdpx_LD),
            .Out_Cont_sel_Mdpx                             (sig_Cont_sel_Mdpx_LD),
            .Out_MtxClr_Mdpx                               (sig_MtxClr_Mdpx_LD),
            .Out_TPSWT_Mdpx                                (sig_TPSWT_Mdpx_LD)
				
            );
				
		Gera_Rajada_Read_DAC u_Gera_Rajada_Read_DAC (

				.In_Reset                                      (In_Reset),
				.In_Clk                                        (In_Clk_nios),
				.In_Send                                       (w_send_rdac),
				
				.In_M                                          (w_M),
				.In_CRW_SRW                                    (w_CRW_SRW),
				.In_POLARITY                                   (w_POLARITY),
				.In_PS                                         (w_PS),
				.In_DISC_CSM_SPM                               (w_DISC_CSM_SPM),
				.In_ENABLE_TP                                  (w_ENABLE_TP),
				.In_COUNT_L                                    (w_COUNT_L),
				.In_COLUMN_BLOCK                               (w_COLUMN_BLOCK),
				.In_COLUMN_BLOCKSEL                            (w_COLUMN_BLOCKSEL),
				.In_ROW_BLOCK                                  (w_ROW_BLOCK),
				.In_ROW_BLOCKSEL                               (w_ROW_BLOCKSEL),
				.In_EQUALIZATION                               (w_EQUALIZATION),
				.In_COLOUR_MODE                                (w_COLOUR_MODE),
				.In_CSM_SPM                                    (w_CSM_SPM),
				.In_INFO_HEADER                                (w_INFO_HEADER),
				.In_FUSE_SEL                                   (w_FUSE_SEL),
				.In_FUSE_PULSE_WD                              (w_FUSE_PULSE_WD),
				.In_GAIN_MODE                                  (w_GAIN_MODE),
				.In_SENSE_DAC                                  (w_SENSE_DAC),
				.In_EXT_DAC                                    (w_EXT_DAC),
				.In_EXT_BG_SEL                                 (w_EXT_BG_SEL),

				.Out_Clk_Medipix                               (sig_Clk_Mdpx_RD),
            .Out_Reset_Mdpx                                (sig_Reset_Mdpx_RD),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_RD),
            .Out_En_Mdpx                                   (sig_En_Mdpx_RD),
            .Out_Shutter_Mdpx                              (sig_Shutter_Mdpx_RD),
            .Out_Cont_sel_Mdpx                             (sig_Cont_sel_Mdpx_RD),
            .Out_MtxClr_Mdpx                               (sig_MtxClr_Mdpx_RD),
            .Out_TPSWT_Mdpx                                (sig_TPSWT_Mdpx_RD)
				
            );
				
		Gera_Rajada_Load_CTPR u_Gera_Rajada_Load_CTPR (
		
		      .In_Reset                                      (In_Reset),
				.In_Clk                                        (In_Clk_nios),
				.In_Send                                       (w_send_lctpr),
				
				.In_M                                          (w_M),
				.In_CRW_SRW                                    (w_CRW_SRW),
				.In_POLARITY                                   (w_POLARITY),
				.In_PS                                         (w_PS),
				.In_DISC_CSM_SPM                               (w_DISC_CSM_SPM),
				.In_ENABLE_TP                                  (w_ENABLE_TP),
				.In_COUNT_L                                    (w_COUNT_L),
				.In_COLUMN_BLOCK                               (w_COLUMN_BLOCK),
				.In_COLUMN_BLOCKSEL                            (w_COLUMN_BLOCKSEL),
				.In_ROW_BLOCK                                  (w_ROW_BLOCK),
				.In_ROW_BLOCKSEL                               (w_ROW_BLOCKSEL),
				.In_EQUALIZATION                               (w_EQUALIZATION),
				.In_COLOUR_MODE                                (w_COLOUR_MODE),
				.In_CSM_SPM                                    (w_CSM_SPM),
				.In_INFO_HEADER                                (w_INFO_HEADER),
				.In_FUSE_SEL                                   (w_FUSE_SEL),
				.In_FUSE_PULSE_WD                              (w_FUSE_PULSE_WD),
				.In_GAIN_MODE                                  (w_GAIN_MODE),
				.In_SENSE_DAC                                  (w_SENSE_DAC),
				.In_EXT_DAC                                    (w_EXT_DAC),
				.In_EXT_BG_SEL                                 (w_EXT_BG_SEL),

				.Out_Clk_Medipix                               (sig_Clk_Mdpx_LCTPR),
            .Out_Reset_Mdpx                                (sig_Reset_Mdpx_LCTPR),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_LCTPR),
            .Out_En_Mdpx                                   (sig_En_Mdpx_LCTPR),
            .Out_Shutter_Mdpx                              (sig_Shutter_Mdpx_LCTPR),
            .Out_Cont_sel_Mdpx                             (sig_Cont_sel_Mdpx_LCTPR),
            .Out_MtxClr_Mdpx                               (sig_MtxClr_Mdpx_LCTPR),
            .Out_TPSWT_Mdpx                                (sig_TPSWT_Mdpx_LCTPR)
				
            );
				
		Gera_Rajada_Load_CounterH u_Gera_Rajada_Load_CounterH (
		
		      .In_Reset                                      (In_Reset),
				.In_Clk                                        (In_Clk_nios),
				.In_Send                                       (w_send_lch),
				
				.In_M                                          (w_M),
				.In_CRW_SRW                                    (w_CRW_SRW),
				.In_POLARITY                                   (w_POLARITY),
				.In_PS                                         (w_PS),
				.In_DISC_CSM_SPM                               (w_DISC_CSM_SPM),
				.In_ENABLE_TP                                  (w_ENABLE_TP),
				.In_COUNT_L                                    (w_COUNT_L),
				.In_COLUMN_BLOCK                               (w_COLUMN_BLOCK),
				.In_COLUMN_BLOCKSEL                            (w_COLUMN_BLOCKSEL),
				.In_ROW_BLOCK                                  (w_ROW_BLOCK),
				.In_ROW_BLOCKSEL                               (w_ROW_BLOCKSEL),
				.In_EQUALIZATION                               (w_EQUALIZATION),
				.In_COLOUR_MODE                                (w_COLOUR_MODE),
				.In_CSM_SPM                                    (w_CSM_SPM),
				.In_INFO_HEADER                                (w_INFO_HEADER),
				.In_FUSE_SEL                                   (w_FUSE_SEL),
				.In_FUSE_PULSE_WD                              (w_FUSE_PULSE_WD),
				.In_GAIN_MODE                                  (w_GAIN_MODE),
				.In_SENSE_DAC                                  (w_SENSE_DAC),
				.In_EXT_DAC                                    (w_EXT_DAC),
				.In_EXT_BG_SEL                                 (w_EXT_BG_SEL),

				.Out_Clk_Medipix                               (sig_Clk_Mdpx_LCH),
            .Out_Reset_Mdpx                                (sig_Reset_Mdpx_LCH),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_LCH),
            .Out_En_Mdpx                                   (sig_En_Mdpx_LCH),
            .Out_Shutter_Mdpx                              (sig_Shutter_Mdpx_LCH),
            .Out_Cont_sel_Mdpx                             (sig_Cont_sel_Mdpx_LCH),
            .Out_MtxClr_Mdpx                               (sig_MtxClr_Mdpx_LCH),
            .Out_TPSWT_Mdpx                                (sig_TPSWT_Mdpx_LCH)
				
            );
				
		Gera_Rajada_Read_CounterH u_Gera_Rajada_Read_CounterH (
		
		      .In_Reset                                      (In_Reset),
				.In_Clk                                        (In_Clk_nios),
				.In_Send                                       (w_send_rch),
				
				.In_M                                          (w_M),
				.In_CRW_SRW                                    (w_CRW_SRW),
				.In_POLARITY                                   (w_POLARITY),
				.In_PS                                         (w_PS),
				.In_DISC_CSM_SPM                               (w_DISC_CSM_SPM),
				.In_ENABLE_TP                                  (w_ENABLE_TP),
				.In_COUNT_L                                    (w_COUNT_L),
				.In_COLUMN_BLOCK                               (w_COLUMN_BLOCK),
				.In_COLUMN_BLOCKSEL                            (w_COLUMN_BLOCKSEL),
				.In_ROW_BLOCK                                  (w_ROW_BLOCK),
				.In_ROW_BLOCKSEL                               (w_ROW_BLOCKSEL),
				.In_EQUALIZATION                               (w_EQUALIZATION),
				.In_COLOUR_MODE                                (w_COLOUR_MODE),
				.In_CSM_SPM                                    (w_CSM_SPM),
				.In_INFO_HEADER                                (w_INFO_HEADER),
				.In_FUSE_SEL                                   (w_FUSE_SEL),
				.In_FUSE_PULSE_WD                              (w_FUSE_PULSE_WD),
				.In_GAIN_MODE                                  (w_GAIN_MODE),
				.In_SENSE_DAC                                  (w_SENSE_DAC),
				.In_EXT_DAC                                    (w_EXT_DAC),
				.In_EXT_BG_SEL                                 (w_EXT_BG_SEL),

				.Out_Clk_Medipix                               (sig_Clk_Mdpx_RCH),
            .Out_Reset_Mdpx                                (sig_Reset_Mdpx_RCH),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_RCH),
            .Out_En_Mdpx                                   (sig_En_Mdpx_RCH),
            .Out_Shutter_Mdpx                              (sig_Shutter_Mdpx_RCH),
            .Out_Cont_sel_Mdpx                             (sig_Cont_sel_Mdpx_RCH),
            .Out_MtxClr_Mdpx                               (sig_MtxClr_Mdpx_RCH),
            .Out_TPSWT_Mdpx                                (sig_TPSWT_Mdpx_RCH)
				
            );

endmodule 
