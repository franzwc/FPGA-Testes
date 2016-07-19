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
            .Out_Eth_En                                   (Out_Eth_RxEn),
				.Out_Eth_Data											 (Out_Eth_Rxdata[3:0])
            );
		
endmodule
