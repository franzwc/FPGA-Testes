/*! VHDL FILE
  @file
--------------------------------------------------------------------------------
  @brief Rx Data Medipix
--------------------------------------------------------------------------------

 Faz a aquisicao do stream do chip e empacota em pacotes de 1028 bytes. 
 1024 payload + 4 cabecalho

 Project Name: Rx_Data_Medipix.v 

 Tools: Quartus II 10.0 SP1

 @name Rx_Data_Medipix
 @author Franz Wagner
 @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
 @date 17/2/2014 
 @version 1.0.0 (Fev/2014) 

--------------------------------------------------------------------------------*/
module Rx_Data_Medipix (
      //--------------------------------------------------------------------------------------------
		//-- input
		//--------------------------------------------------------------------------------------------
		input               In_Reset,
		input               In_Clk_10M,
		input               In_Clk_Double,
	   input               In_Clk_Mdpx,
	   input               In_En_Mdpx,
      input  [7:0]        In_Data_Mdpx,
		input [10:0]        In_Packet_Length,
	   input  [2:0]        In_M,
		input  [1:0]        In_PS,
		input  [1:0]        In_CountL,
		input               In_FIFO_Write,
		//--------------------------------------------------------------------------------------------
		//-- output
		//--------------------------------------------------------------------------------------------
		output              Out_Fifo_Empty,
		output [12:0]       Out_fifo_use,
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
		
		wire [12:0] 			w_fifo_use;
		wire      				w_fifo_read_en;
		wire        			w_rst_fifo;
		wire        			w_out_fifo;
		wire        			w_fifo_full;
		
		assign  Out_fifo_use=w_fifo_use;
		//--------------------------------------------------------------------------------------------
		//Descrimina os dados
		//--------------------------------------------------------------------------------------------		
		Data_Discriminate u_Data_Discriminate (

            .In_Reset                                     (In_Reset),
				.In_Clk_Mdpx                                  (In_Clk_Mdpx),
				.In_En_Mdpx                                   (In_FIFO_Write),
				.In_Data_Mdpx                                 (In_Data_Mdpx[0]),
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
				.wrclk                                        (~In_Clk_Mdpx),

				.rdreq                                        (w_fifo_read_en),
				.rdclk                                        (In_Clk_10M),
				
				.aclr                                         (w_rst_fifo),
				
				.wrusedw                                      (),
				.wrfull                                       (w_fifo_full),
				
				.rdusedw                                      (w_fifo_use),
				.rdempty                                      (Out_Fifo_Empty),
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
