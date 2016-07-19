/*- Verilog File
--{{{ HEADER
--!@file
-------------------------------------------------------------------------------------------------
--!@brief Medipix Bridge
-------------------------------------------------------------------------------------------------
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
--!- Create Date: 17/2/2014     
--!- Version: 1.0.0 (Fev/2014) 
-------------------------------------------------------------------------------------------------
-- LNLS - DET - 2014
-------------------------------------------------------------------------------------------------
--}}} Header*/

module Rx_Data_Medipix (

      //--------------------------------------------------------------------------------------------
		//-- input
		//--------------------------------------------------------------------------------------------

		input               In_Reset,
		input               In_Clk_10M,
		input               In_Clk_Double,
	   input               In_Clk_Mdpx,
	   input               In_En_Mdpx,
      input               In_Data_Mdpx,
		input [10:0]        In_Packet_Length,
	   input  [2:0]        In_M,
		input  [1:0]        In_PS,
		input  [1:0]        In_CountL,
		input               In_OutEn_Mdpx,
	
		//--------------------------------------------------------------------------------------------
		//-- output
		//--------------------------------------------------------------------------------------------
		output              Out_Sync,
		output              Out_Valid,
		output [7:0]        Out_Data
	
);
		
		wire                 w_En_RCL;
		wire                 w_Data_RCL;
		
		wire                 w_En_RCH;
		wire                 w_Data_RCH;
		
		wire                 w_En_RDAC;
		wire                 w_Data_RDAC;
		
		wire                 w_En_ROMR;
		wire                 w_Data_ROMR;
		
		wire                 reg_valid;
		wire  [7:0]          reg_data;
		
		wire     				w_Clk;
		wire 					   w_En;
		wire     				w_Data;
		
		wire     				w_write_en;
		wire     				w_write_data;
		
		wire [15:0] 			w_fifo_use;
		wire      				w_fifo_read_en;
		wire        			w_rst_fifo;
		wire        			w_out_fifo;
		wire        			w_fifo_full;
		
		//--------------------------------------------------------------------------------------------
		//Descrimina os dados
		//--------------------------------------------------------------------------------------------		
	   Input_En u_Input_En (

            .In_Reset                                     (In_Reset),
				.In_Clk                                       (In_Clk_Double),
				.In_Clk_Mdpx                                  (In_Clk_Mdpx),
				.In_En_Mdpx                                   (In_En_Mdpx),
				.In_Data_Mdpx                                 (In_Data_Mdpx),
				.In_OutEn_Mdpx                                (In_OutEn_Mdpx),
				
				.Out_Clk                                      (w_Clk),
				.Out_En                                       (w_En),
				.Out_Data                                     (w_Data)		
		);
				
		Data_Discriminate u_Data_Discriminate (

            .In_Reset                                     (In_Reset),
				.In_Clk_Mdpx                                  (w_Clk),
				.In_En_Mdpx                                   (w_En),
				.In_Data_Mdpx                                 (w_Data),
				.In_M                                         (In_M),

				.Out_En_RCL                                   (w_En_RCL),
				.Out_Data_RCL                                 (w_Data_RCL),
				
				.Out_En_RCH                                   (w_En_RCH),
				.Out_Data_RCH                                 (w_Data_RCH),
				
				.Out_En_RDAC                                  (w_En_RDAC),
				.Out_Data_RDAC                                (w_Data_RDAC),
				
				.Out_En_ROMR                                  (w_En_ROMR),
				.Out_Data_ROMR                                (w_Data_ROMR)
		);
				
		input_fifo_65525 u_input_fifo_65525 (

            .data                                         (w_Data_RCH),
				.wrreq                                        (w_En_RCH),
				.wrclk                                        (~w_Clk),

				.rdreq                                        (w_fifo_read_en),
				.rdclk                                        (In_Clk_10M),
				
				.aclr                                         (w_rst_fifo),
				
				.wrusedw                                      (),
				.wrfull                                       (w_fifo_full),
				
				.rdusedw                                      (w_fifo_use),
				.rdempty                                      (),
				.q                                            (w_out_fifo)		
		);
		
	   Read_Input_Fifo u_Read_Input_Fifo (
		      
				.In_Reset                                     (In_Reset),
				.In_Clk                                       (In_Clk_10M),
				.In_Fifo_Use                                  (w_fifo_use),
				.In_Fifo_Full                                 (w_fifo_full),
				.In_Packet_Length                             (In_Packet_Length),
				.In_q                                         (w_out_fifo),

				.Out_Fifo_Read_En                             (w_fifo_read_en),
				.Out_Fifo_rst                                 (w_rst_fifo),
				
				.Out_data                                     (Out_Data),
	         .Out_valid                                    (Out_Valid),
	         .Out_sync                                     (Out_Sync)
		);

endmodule 
