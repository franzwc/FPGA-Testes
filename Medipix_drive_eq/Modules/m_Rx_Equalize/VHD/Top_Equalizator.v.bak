/*! Verilog HDL FILE
  @file
--------------------------------------------------------------------------------
  @brief Send Equalization
--------------------------------------------------------------------------------
 Recebe dados da equalizacao pela ethernet e manda para o chip Medipix

 Project Name: Top_Equalizator.v

 Tools: Quartus II 10.0 SP1

 @name Top_Equalizator
 @author Franz Wagner
 @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
 @date 31/07/2014
 @version 1.0.0 (Jul/2014)

--------------------------------------------------------------------------------*/

module Top_Equalizator (
		//--------------------------------------------------------------------------------------------
		//-- input reset
		//--------------------------------------------------------------------------------------------
      input               In_Rst,
		input               In_Clk_Medipix,
		//--------------------------------------------------------------------------------------------
		//-- ethernet phy interface
		//--------------------------------------------------------------------------------------------
		input                In_Eth_Rxc,
		input                In_Eth_RxCtl,
		input   [3:0]        In_Eth_Rxd,
		
		output               Out_Eth_Linux_RxEn,
		output  [3:0]        Out_Eth_Linux_Rxdata,
		output               Out_Eth_RxEn,
		output  [3:0]        Out_Eth_Rxdata
);

		wire  		w_equalize_fifo_en;
		wire [3:0] 	w_equalize_fifo_data;
		
		//--------------------------------------------------------------------------------------------
		//-- Recebe dados da Ethernet
		//--------------------------------------------------------------------------------------------
		Rx_Equalization u_Rx_Equalization (
            .In_Clk                                       (~In_Eth_Rxc),
            .In_Rst                                       (In_Rst),
				.In_Eth_En                                    (In_Eth_RxCtl),
				.In_Eth_Data											 (In_Eth_Rxd[3:0]),
				
				.Out_Eth_Linux_En										 (Out_Eth_Linux_RxEn),
				.Out_Eth_Linux_Data									 (Out_Eth_Linux_Rxdata),
            .Out_Eth_En                                   (w_equalize_fifo_en),
				.Out_Eth_Data											 (w_equalize_fifo_data)
            );
		//--------------------------------------------------------------------------------------------
		//-- fifo
		//--------------------------------------------------------------------------------------------
		wire [16:0]  w_fifo_wruse;
		wire [16:0]  w_fifo_wruse2;
		wire         w_fifo_data_out;
		wire         w_read_fifo;
		Equalize_Fifo u_Equalize_Fifo (

            .data                                         (w_equalize_fifo_data[0]),
				.wrreq                                        (w_equalize_fifo_en),
				.wrclk                                        (~In_Eth_Rxc),

				.rdreq                                        (w_read_fifo),
				.rdclk                                        (In_Clk_Medipix),
				
				.aclr                                         (),
				
				.wrusedw                                      (),
				
				.rdusedw                                      (w_fifo_wruse[16:0]),
				.q                                            (w_fifo_data_out)		
				);
				
		Equalize_Fifo u_Equalize_Fifo2 (

            .data                                         (w_equalize_fifo_data[0]),
				.wrreq                                        (),
				.wrclk                                        (~In_Eth_Rxc),

				.rdreq                                        (),
				.rdclk                                        (In_Clk_Medipix),
				
				.aclr                                         (),
				
				.wrusedw                                      (),
				
				.rdusedw                                      (w_fifo_wruse2[16:0]),
				.q                                            ()		
				);
		//--------------------------------------------------------------------------------------------
		//-- read fifo
		//--------------------------------------------------------------------------------------------	
		Read_Equalize_Fifo u_Read_Equalize_Fifo (
				.In_Reset                                     (In_Rst),
				.In_Clk                                       (In_Clk_Medipix),
				.In_Fifo_Use                                  (w_fifo_wruse[16:0]),
				.In_Fifo_Full                                 (1'b0),
				.In_Packet_Length                             (),
				.In_q                                         (w_fifo_data_out),
				 
				.Out_Fifo_Read_En                             (w_read_fifo),
				.Out_Fifo_rst                                 (),
				
				.Out_data                                     (),
				.Out_valid                                    (),
				.Out_sync                                     ()
		);

endmodule
