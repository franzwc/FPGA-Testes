/* Verilog HDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief TSoIp Top
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! TS over Ethernet
--!
--! DETAILS:      
--!
--!- Project Name: TSoIp_Bridge.v                       
--!- Module Name: TSoIp_Bridge
--!- Tools: Quartus II 10.0  
--!- Author: Franz Wagner
--!- Company: HK LINEAR
--!- Create Date: 24/07/2013     
--!- Version: 1.0.0 (Jul/2013)  
--------------------------------------------------------------------------------
-- HKLINEAR - 2013
--------------------------------------------------------------------------------
--}}} Header*/

module TSoIp_Bridge (

          	 input                    i_Clk27,
				 input                    i_nRst,
				 input   [7:0]            i_Data_table_fnios,
				 input                    i_Valid_table_fnios,
				 input                    i_Sync_table_fnios,//dados vindos da web
				 
				 input   [7:0]            i_ts_Data, //asi
				 input                    i_ts_Valid,
				 input                    i_ts_Sync,
				 
				 input                    i_PhyTxClk,//clk da phy 25mhz
				 
				 
				 //saidas
				 output                   o_PhyTxEna,
				 output   [3:0]           o_PhyTxData

);


   //--------------------------------------------------------------------------------------------
	// Pega os parametros da web e entrega ao modulo 
	//--------------------------------------------------------------------------------------------
//	wire              CtrlPhy;
//   wire   [7:0]      i_Protocol;
//	wire   [7:0]      i_TimeToLive;
//   wire   [7:0]      i_NumberPacket;
//   wire  [31:0]      i_IpSource;
//   wire  [47:0]      i_MacSource;
//   wire  [15:0]      i_PortSource;
//   wire  [31:0]      i_IpDest;
//   wire  [47:0]      i_MacDest;
//   wire  [15:0]      i_PortDest;
//	
//   ReaderTableConfigIP u_ReaderTableConfigIP (
//
//	          .iClock                                  (i_Clk27),
//				 .iReset                                  (i_nRst),
//				 .iData                                   (i_Data_table_fnios),
//				 .iSync                                   (i_Sync_table_fnios),
//				 .iValid                                  (i_Valid_table_fnios),
//				 
//				 .out_CtrlPhy                             (CtrlPhy),
//				 .out_Protocol                            (i_Protocol[7:0]),
//				 .out_TimeToLive                          (i_TimeToLive[7:0]),
//				 .out_TsPackets                           (i_NumberPacket[7:0]),
//				 .out_IpSource                            (i_IpSource[31:0]),
//				 .out_MacSource                           (i_MacSource[47:0]),
//				 .out_PortSource                          (i_PortSource[15:0]),
//				 .out_IpDest                              (i_IpDest[31:0]),
//				 .out_MacDest                             (i_MacDest[47:0]),
//				 .out_PortDest                            (i_PortDest[15:0])
//				 
//			 		 
//	);
	
	
	//--------------------------------------------------------------------------------------------
	//modulo tsoverethernet
	//--------------------------------------------------------------------------------------------
	TOP_TSoIP u_TOP_TSoIP (

	          .clk                                     (i_Clk27),
				 .nRst                                    (1'b1),
				 .BTS_comp                                (1'b0),
				 .ClkPhy                                  (i_PhyTxClk),
				 .i_ts_valid                              (i_ts_Valid),
				 .i_ts_sync                               (i_ts_Valid),
				 .i_ts_data                               (i_ts_Data[7:0]),
				 .i_ts_PacketLength                       (8'd204),
				 .i_MacDest                               (48'h74867afb78c7),
				 .i_MacSource                             (48'haabbccddeeff),
				 .i_IpDest                                (32'ha001b1f),
				 .i_IpSource                              (32'ha001b21),
				 .i_Protocol                              (8'h11),
				 .i_PortDest                              (16'd3000),
				 .i_PortSource                            (16'd3000),
				 .i_TimeToLive                            (8'h01),
				 .i_NumberPacket                          (3'd7),
				 
				 .PhytxEna                                (o_PhyTxEna),
				 .PhytxData                               (o_PhyTxData[3:0])
			 		 
	);


endmodule 