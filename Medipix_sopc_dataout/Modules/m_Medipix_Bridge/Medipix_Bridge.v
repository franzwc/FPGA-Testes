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
		input               In_Clk,

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
		wire   [6:0]         w_FUSE_PULSE_WD;
		wire   [1:0]         w_GAIN_MODE;
		wire   [4:0]         w_SENSE_DAC;
		wire   [4:0]         w_EXT_DAC;
		wire                 w_EXT_BG_SEL;
		wire   [6:0]         w_aqst_time_int;
		wire   [9:0]         w_aqst_time_fraq;
		wire                 w_send_omr;
		wire                 w_send_ldac;
		wire                 w_send_rdac;
		wire                 w_send_lctpr;
		wire                 w_send_lch;
		wire                 w_send_rch;
		wire                 w_send_rcl;
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
		
      wire                 sig_Clk_Mdpx_OMR;
		wire                 sig_Reset_Mdpx_OMR;
		wire                 sig_Data_Mdpx_OMR;
		wire                 sig_En_Mdpx_OMR;
		
		wire                 sig_Clk_Mdpx_LD;
		wire                 sig_Reset_Mdpx_LD;
		wire                 sig_Data_Mdpx_LD;
		wire                 sig_En_Mdpx_LD;
		
		wire                 sig_Clk_Mdpx_RD;
		wire                 sig_Reset_Mdpx_RD;
		wire                 sig_Data_Mdpx_RD;
		wire                 sig_En_Mdpx_RD;
		
		wire                 sig_Clk_Mdpx_LCTPR;
		wire                 sig_Reset_Mdpx_LCTPR;
		wire                 sig_Data_Mdpx_LCTPR;
		wire                 sig_En_Mdpx_LCTPR;
		
		wire                 sig_Clk_Mdpx_LCH;
		wire                 sig_Reset_Mdpx_LCH;
		wire                 sig_Data_Mdpx_LCH;
		wire                 sig_En_Mdpx_LCH;
		
		wire                 sig_Clk_Mdpx_RCH;
		wire                 sig_Reset_Mdpx_RCH;
		wire                 sig_Data_Mdpx_RCH;
		wire                 sig_En_Mdpx_RCH;
		
		wire                 sig_clk_out_data;
		wire                 sig_clk_out_shutter;
		
		wire    					w_start_shutter;
		
	   assign  Out_M = w_out_M;
		
		assign  Out_Clk_Mdpx = sig_clk_out_data | sig_clk_out_shutter;
		
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
				.Out_AQST_TIME_INT                            (w_aqst_time_int),
				.Out_AQST_TIME_FRAQ                           (w_aqst_time_fraq),
				.Out_IMG_COUNTER                              (w_image_counter),
				.Out_IMG_GAP                                  (w_image_interval),
				.Out_READ_COUNTER                             (w_read_couter),
				.Out_TP_PERIOD                                (),
	         .Out_TP_NPULSES                               (),
				.Out_Send_OMR                                 (w_send_omr),
				.Out_Send_LDac                                (w_send_ldac),
				.Out_Send_RDac                                (w_send_rdac),
				.Out_Send_LCtpr                               (w_send_lctpr),
				.Out_Send_LCH                                 (w_send_lch),
				.Out_Send_LCL                                 (w_send_lcl),
				.Out_Send_RCH                                 (w_send_rch),
				.Out_Send_RCL                                 (w_send_rcl)
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
				

endmodule 
