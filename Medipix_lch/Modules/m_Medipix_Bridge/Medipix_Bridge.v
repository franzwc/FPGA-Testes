/*! Verilog HDL FILE
  @file
--------------------------------------------------------------------------------
  @brief Medipix Bridge
--------------------------------------------------------------------------------

 Bridge de comunicacao com o chip medipix

 Project Name: Medipix_Bridge.v 

 Tools: Quartus II 10.0 SP1

 @name Medipix_Bridge
 @author Franz Wagner
 @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
 @date 2/12/2013
 @version 1.0.0 (Dez/2013)

--------------------------------------------------------------------------------*/
module Medipix_Bridge (
      //--------------------------------------------------------------------------------------------
		//-- input
		//--------------------------------------------------------------------------------------------
		input               In_Reset,
		input               In_Clk_nios,
		input               In_Clk,
		
		input               In_En_Equalize,
		input               In_Data_Equalize,
		input          	  In_Send_Equalize,

		input               In_En_nios,
		input               In_Sync_nios,
		input  [7:0]        In_Data_nios,
		//--------------------------------------------------------------------------------------------
		//-- output
		//--------------------------------------------------------------------------------------------
		output [2:0]        Out_M,
		output [1:0]        Out_PS,
		output [1:0]        Out_CountL,

		output              Out_Reset_Mdpx,
		
		output              Out_Clk_Mdpx,
		output              Out_Data_Mdpx,
		output              Out_En_Mdpx,
		output              Out_Shutter_Mdpx,
		output              Out_Cont_sel_Mdpx,
		output              Out_MtxClr_Mdpx,
		output              Out_TPSWT_Mdpx,
		output              Out_Write_FIFO_Data
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
		assign  Out_PS = w_PS;
		assign  Out_CountL = w_COUNT_L;
		
		assign  Out_Shutter_Mdpx = 1'b1;
		assign  Out_Cont_sel_Mdpx = 1'b1;
		assign  Out_MtxClr_Mdpx = 1'b1;
		assign  Out_TPSWT_Mdpx = 1'b1;
		
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
				.Out_Send_OMR                                 (w_send_omr),
				.Out_Send_LDac                                (w_send_ldac),
				.Out_Send_RDac                                (w_send_rdac),
				.Out_Send_LCtpr                               (w_send_lctpr),
				.Out_Send_LCH                                 (w_send_lch),
				.Out_Send_RCH                                 (w_send_rch),
				.Out_Send_RCL                                 (w_send_rcl)
				);
				
		Gera_M u_Gera_M (
		
		      .In_Reset                                     (In_Reset),
	         .In_Clk_nios                                  (In_Clk_nios),
	
	         .In_Send_OMR                                  (w_send_omr),
	         .In_Send_LDac                                 (w_send_ldac),
	         .In_Send_RDac                                 (w_send_rdac),
	         .In_Send_LCtpr                                (w_send_lctpr),
	         .In_Send_LCH                                  (w_send_lch|In_Send_Equalize),
	         .In_Send_RCH                                  (w_send_rch),
				.In_Send_RCL											 (w_send_rcl),
	
	         .In_Send_DACS                                 (w_send_dacs),
	
	         .Out_M                                        (w_out_M)
				);
				
		Select_Output u_Select_Output (
		      
				.In_Clk                                       (In_Clk),
				.In_Reset                                     (In_Reset),
				.In_M                                         (w_out_M),

				.In_Clk_Mdpx_OMR                              (sig_Clk_Mdpx_OMR),
				.In_Reset_Mdpx_OMR                            (sig_Reset_Mdpx_OMR),
				.In_Data_Mdpx_OMR                             (sig_Data_Mdpx_OMR),
				.In_En_Mdpx_OMR                               (sig_En_Mdpx_OMR),
	
				.In_Clk_Mdpx_LD                               (sig_Clk_Mdpx_LD),
				.In_Reset_Mdpx_LD                             (sig_Reset_Mdpx_LD),
				.In_Data_Mdpx_LD                              (sig_Data_Mdpx_LD),
				.In_En_Mdpx_LD                                (sig_En_Mdpx_LD),
				
				.In_Clk_Mdpx_RD                               (sig_Clk_Mdpx_RD),
				.In_Reset_Mdpx_RD                             (sig_Reset_Mdpx_RD),
				.In_Data_Mdpx_RD                              (sig_Data_Mdpx_RD),
				.In_En_Mdpx_RD                                (sig_En_Mdpx_RD),
				
				.In_Clk_Mdpx_LCTPR                            (sig_Clk_Mdpx_LCTPR),
				.In_Reset_Mdpx_LCTPR                          (sig_Reset_Mdpx_LCTPR),
				.In_Data_Mdpx_LCTPR                           (sig_Data_Mdpx_LCTPR),
				.In_En_Mdpx_LCTPR                             (sig_En_Mdpx_LCTPR),
				
				.In_Clk_Mdpx_LCH                              (sig_Clk_Mdpx_LCH),
				.In_Reset_Mdpx_LCH                            (sig_Reset_Mdpx_LCH),
				.In_Data_Mdpx_LCH                             (sig_Data_Mdpx_LCH),
				.In_En_Mdpx_LCH                               (sig_En_Mdpx_LCH),
				
				.In_Clk_Mdpx_RCH                              (sig_Clk_Mdpx_RCH),
				.In_Reset_Mdpx_RCH                            (sig_Reset_Mdpx_RCH),
				.In_Data_Mdpx_RCH                             (sig_Data_Mdpx_RCH),
				.In_En_Mdpx_RCH                               (sig_En_Mdpx_RCH),
	
				.Out_Clk_Medipix                              (sig_clk_out_data),
				.Out_Reset_Mdpx                               (Out_Reset_Mdpx),
				.Out_Data_Mdpx                                (Out_Data_Mdpx),
				.Out_En_Mdpx                                  (Out_En_Mdpx)
				);
		
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
            .Out_En_Mdpx                                   (sig_En_Mdpx_OMR)
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
            .Out_En_Mdpx                                   (sig_En_Mdpx_RD)
            );
				
				
		Gera_Rajada_Load_CounterH u_Gera_Rajada_Load_CounterH (
		
		      .In_Reset                                      (In_Reset),
				.In_Clk                                        (In_Clk_nios),
				.In_Send                                       (w_send_lch|In_Send_Equalize),
				
				.In_Equalize_Data										  (In_Data_Equalize),
				.In_Equalize_En                                (1'b1),
				
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
            .Out_En_Mdpx                                   (sig_En_Mdpx_LCH)
            );

endmodule 
