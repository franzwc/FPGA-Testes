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
		
		input               In_Rx_Fifo_Empty,
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
		wire   [4:0]         w_FUSE_SEL;
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
		wire                 w_send_lcl;
		wire                 w_send_lcl_h;
		
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
		wire                 sig_Data_Mdpx_OMR;
		wire                 sig_En_Mdpx_OMR;
		
		wire                 sig_Clk_Mdpx_LD;
		wire                 sig_Data_Mdpx_LD;
		wire                 sig_En_Mdpx_LD;
		
		wire                 sig_Clk_Mdpx_RD;
		wire                 sig_Data_Mdpx_RD;
		wire                 sig_En_Mdpx_RD;
		
		wire                 sig_Clk_Mdpx_LCTPR;
		wire                 sig_Data_Mdpx_LCTPR;
		wire                 sig_En_Mdpx_LCTPR;
		
		wire                 sig_Clk_Mdpx_LCH;
		wire                 sig_Data_Mdpx_LCH;
		wire                 sig_En_Mdpx_LCH;
		
		wire                 sig_Clk_Mdpx_LCL;
		wire                 sig_Data_Mdpx_LCL;
		wire                 sig_En_Mdpx_LCL;
		
		wire                 sig_Clk_Mdpx_RCH;
		wire                 sig_Data_Mdpx_RCH;
		wire                 sig_En_Mdpx_RCH;
		
		wire                 sig_clk_out_data;
		wire                 sig_clk_out_shutter;
		
		wire    					w_start_shutter;
		wire   [6:0]         w_image_counter;
		wire  [13:0]         w_image_interval;
		
		wire   [1:0]         w_read_couter;
		
	   assign  Out_M = w_out_M;
		assign  Out_PS = w_PS;
		assign  Out_CountL = w_COUNT_L;
		
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
				
		Gera_M u_Gera_M (
		
		      .In_Reset                                     (In_Reset),
	         .In_Clk_nios                                  (In_Clk_nios),
	
	         .In_Send_OMR                                  (w_send_omr),
	         .In_Send_LDac                                 (w_send_ldac),
	         .In_Send_RDac                                 (w_send_rdac),
	         .In_Send_LCtpr                                (w_send_lctpr),
	         .In_Send_LCH                                  (w_send_lch|In_Send_Equalize),
				.In_Send_LCL                                  (w_send_lcl),
	         .In_Send_RCH                                  (w_send_rch),
				.In_Send_RCL											 (w_send_rcl),
	
	         .In_Send_DACS                                 (w_send_dacs),
	
	         .Out_M                                        (w_out_M)
				);
		
		Gera_Shutter u_Gera_Shutter (
		
				.In_Reset                                     (In_Reset),
	         .In_Clk_Shutter                               (In_Clk_nios),
				.In_Clk_Double                                (In_Clk),
	
	         .In_Start_Shutter                             (w_start_shutter),
				.In_Time_Int                                  (w_aqst_time_int),
				.In_Time_Fraq                                 (w_aqst_time_fraq),
	
	         .Out_Shutter                                  (Out_Shutter_Mdpx),
				.Out_Clk_Shutter                              (sig_clk_out_shutter)
				);
				
		Select_Output u_Select_Output (
		      
				.In_Clk                                       (In_Clk),
				.In_Reset                                     (In_Reset),
				.In_M                                         (w_out_M),

				.In_Clk_Mdpx_OMR                              (sig_Clk_Mdpx_OMR),
				.In_Data_Mdpx_OMR                             (sig_Data_Mdpx_OMR),
				.In_En_Mdpx_OMR                               (sig_En_Mdpx_OMR),
	
				.In_Clk_Mdpx_LD                               (sig_Clk_Mdpx_LD),
				.In_Data_Mdpx_LD                              (sig_Data_Mdpx_LD),
				.In_En_Mdpx_LD                                (sig_En_Mdpx_LD),
				
				.In_Clk_Mdpx_RD                               (sig_Clk_Mdpx_RD),
				.In_Data_Mdpx_RD                              (sig_Data_Mdpx_RD),
				.In_En_Mdpx_RD                                (sig_En_Mdpx_RD),
				
				.In_Clk_Mdpx_LCTPR                            (sig_Clk_Mdpx_LCTPR),
				.In_Data_Mdpx_LCTPR                           (sig_Data_Mdpx_LCTPR),
				.In_En_Mdpx_LCTPR                             (sig_En_Mdpx_LCTPR),
				
				.In_Clk_Mdpx_LCL                              (sig_Clk_Mdpx_LCL),
				.In_Data_Mdpx_LCL                             (sig_Data_Mdpx_LCL),
				.In_En_Mdpx_LCL                               (sig_En_Mdpx_LCL),
				
				.In_Clk_Mdpx_LCH                              (sig_Clk_Mdpx_LCH),
				.In_Data_Mdpx_LCH                             (sig_Data_Mdpx_LCH),
				.In_En_Mdpx_LCH                               (sig_En_Mdpx_LCH),
				
				.In_Clk_Mdpx_RCH                              (sig_Clk_Mdpx_RCH),
				.In_Data_Mdpx_RCH                             (sig_Data_Mdpx_RCH),
				.In_En_Mdpx_RCH                               (sig_En_Mdpx_RCH),
	
				.Out_Clk_Medipix                              (sig_clk_out_data),
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

				.Out_M													  (),
				.Out_Clk_Medipix                               (sig_Clk_Mdpx_OMR),
            .Out_Reset_Mdpx                                (),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_OMR),
            .Out_En_Mdpx                                   (sig_En_Mdpx_OMR)
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

				.Out_M													  (),
				.Out_Clk_Medipix                               (sig_Clk_Mdpx_LD),
            .Out_Reset_Mdpx                                (),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_LD),
            .Out_En_Mdpx                                   (sig_En_Mdpx_LD)
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

				.Out_M													  (),
				.Out_Clk_Medipix                               (sig_Clk_Mdpx_RD),
            .Out_Reset_Mdpx                                (),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_RD),
            .Out_En_Mdpx                                   (sig_En_Mdpx_RD)
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

				.Out_M													  (),
				.Out_Clk_Medipix                               (sig_Clk_Mdpx_LCTPR),
            .Out_Reset_Mdpx                                (),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_LCTPR),
            .Out_En_Mdpx                                   (sig_En_Mdpx_LCTPR)
            );
				
		Gera_Rajada_Load_CounterL u_Gera_Rajada_Load_CounterL (
		
		      .In_Reset                                      (In_Reset),
				.In_Clk                                        (In_Clk_nios),
				.In_Send                                       (w_send_lcl),
				
				.In_M                                          (w_M),
				.In_POLARITY                                   (w_POLARITY),
				.In_DISC_CSM_SPM                               (w_DISC_CSM_SPM),
				.In_COUNT_L                                    (w_COUNT_L),
				.In_EQUALIZATION                               (w_EQUALIZATION),
				.In_COLOUR_MODE                                (w_COLOUR_MODE),
				.In_CSM_SPM                                    (w_CSM_SPM),
				.In_GAIN_MODE                                  (w_GAIN_MODE),

				.Out_M													  (),
				.Out_Clk_Medipix                               (sig_Clk_Mdpx_LCL),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_LCL),
            .Out_En_Mdpx                                   (sig_En_Mdpx_LCL)
            );
				
		Gera_Rajada_Load_CounterH u_Gera_Rajada_Load_CounterH (
		
		      .In_Reset                                      (In_Reset),
				.In_Clk                                        (In_Clk_nios),
				.In_Send                                       (w_send_lch|In_Send_Equalize),
				
				.In_Equalize_Data										  (In_Data_Equalize),
				.In_Equalize_En                                (In_En_Equalize),
				
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

				.Out_M													  (),
				.Out_Send_LCL                                  (w_send_lcl_h),
				.Out_Clk_Medipix                               (sig_Clk_Mdpx_LCH),
            .Out_Reset_Mdpx                                (),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_LCH),
            .Out_En_Mdpx                                   (sig_En_Mdpx_LCH)
            );
				
		Gera_Rajada_Read_CounterH u_Gera_Rajada_Read_CounterH (
		
		      .In_Reset                                      (In_Reset),
				.In_Clk                                        (In_Clk_nios),
				.In_Send                                       (w_send_rch|w_send_rcl),
				.In_End_Shutter                                (Out_Shutter_Mdpx),
				
				.In_Rx_Fifo_Empty                              (In_Rx_Fifo_Empty),
				
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
				.In_IMG_COUNTER                                (w_image_counter),
				.In_IMG_GAP                                    (w_image_interval),
				.In_READ_CONTER                                (w_read_couter),

				.Out_M													  (),
				.Out_Start_Shutter                             (w_start_shutter),
				.Out_Clk_Medipix                               (sig_Clk_Mdpx_RCH),
            .Out_Reset_Mdpx                                (),
            .Out_Data_Mdpx                                 (sig_Data_Mdpx_RCH),
            .Out_En_Mdpx                                   (sig_En_Mdpx_RCH),
            .Out_Cont_sel_Mdpx                             (Out_Cont_sel_Mdpx),
            .Out_MtxClr_Mdpx                               (Out_MtxClr_Mdpx),
            .Out_TPSWT_Mdpx                                (Out_TPSWT_Mdpx),
				.Out_Write_FIFO_Data                           (Out_Write_FIFO_Data)
            );

endmodule 
