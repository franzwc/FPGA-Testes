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
--!- Create Date: 20/11/2012     
--!- Version: 1.0.0 (Nov/2012)  
--------------------------------------------------------------------------------
-- HKLINEAR - 2012
--------------------------------------------------------------------------------
--}}} Header*/

module TSoIp_Bridge (

          	 input                    clk,
				 input                    nRst,
				 input                    BTS_comp,
				 input                    ClkPhy,
				 input                    i_ts_valid,
				 input                    i_ts_sync,
				 input   [7:0]            i_ts_data,
				 input   [7:0]            i_ts_PacketLength,
				 input  [47:0]            i_MacDest,
				 input  [47:0]            i_MacSource,
				 input  [31:0]            i_IpDest,
				 input  [31:0]            i_IpSource,
				 input   [7:0]            i_Protocol,
				 input  [15:0]            i_PortDest,
				 input  [15:0]            i_PortSource,
				 input   [7:0]            i_TimeToLive,
				 input   [2:0]            i_NumberPacket,
				 
				 output                   o_Sync,
				 output                   o_End,
				 output                   o_Valid,
				 output   [7:0]           o_Data,
				 output                   PhytxEna,
				 output    [3:0]          PhytxData,
				 output   [10:0]          NivelRdFifo,
				 output                   enRd,
				 output                   EnRdHdEth,
				 output                   Out_Valid,
				 output                   Out_Sync,
				 output                   Out_End

);

wire               MacHeader_nRst;
wire   [7:0]       DataToFifo;
wire               ValidToFifo;

wire   [7:0]       DataFromFifo;

wire   [7:0]       MacHeader_data;
wire   [5:0]       MacHeader_add;
wire               MacHeader_wr;

wire  [10:0]       contavbyte;
wire   [7:0]       dataHeader;

wire               oValidCRC;

wire  [31:0]      Update_fcs;
wire  [31:0]      fcs;

wire   [7:0]      data_tx_crc;
wire              sync_tx_crc;
wire              valid_tx_crc;
wire              end_tx_crc;

wire   [7:0]      data_test;

	//--------------------------------------------------------------------------------------------
	//Controle de escrita dos pacotes no buffer
	//--------------------------------------------------------------------------------------------
	CtrlWrTxTsOIP u_TOP_CtrlWrTxTsOIP (

	          .i_Clk                                   (clk),
				 .i_nRst                                  (MacHeader_nRst),
				 .i_Valid                                 (i_ts_valid),
				 .i_Sync                                  (i_ts_sync),
				 .i_Data                                  (i_ts_data[7:0]),
				 .i_PacketLength                          (i_ts_PacketLength[7:0]),
				 
				 .o_Data                                  (DataToFifo[7:0]),
				 .o_Valid                                 (ValidToFifo),
				 .o_Sync                                  ()
			 		 
	);
	
   //--------------------------------------------------------------------------------------------
	//Buffer de pacotes de entrada
	//--------------------------------------------------------------------------------------------
	
   IpFifoTsOIp u_IpFifoTsOIp (

	          .data                                    (DataToFifo[7:0]),
				 .wrreq                                   (ValidToFifo),
				 .wrclk                                   (clk),
				 
				 .rdreq                                   (enRd),
				 .rdclk                                   (ClkPhy),
				 .aclr                                    (~MacHeader_nRst),
				 
				 .wrfull                                  (),
				 .wrusedw                                 (),
				 .q                                       (DataFromFifo[7:0]),
				 .rdempty                                 (),
				 .rdusedw                                 (NivelRdFifo[10:0])
			 		 
	);

   //--------------------------------------------------------------------------------------------
	//Cria cabeçalho MAC
	//--------------------------------------------------------------------------------------------
	
	mac_header u_mac_header (

	          .i_Clk                                   (clk),
				 .i_nRst                                  (nRst),
				 .i_BtsComp                               (BTS_comp),
				 .i_MacDest                               (i_MacDest[47:0]),
				 .i_MacSource                             (i_MacSource[47:0]),
				 .i_IPDest                                (i_IpDest[31:0]),
				 .i_IPSource                              (i_IpSource[31:0]),
				 .i_Protocol                              (i_Protocol[7:0]),
				 .i_PortDest                              (i_PortDest[15:0]),
				 .i_PortSource                            (i_PortSource[15:0]),
				 .i_TTL                                   (i_TimeToLive[7:0]),
				 .i_NumeroPkt                             (i_NumberPacket[2:0]),
				 
				 .o_Data                                  (MacHeader_data[7:0]),
				 .o_Add                                   (MacHeader_add[5:0]),
				 .o_Valid                                 (MacHeader_wr),
				 .o_HeaderReady                           (MacHeader_nRst),
				 .o_CheckSum                              ()
			 		 
	);
	
	IpRamHeadermac u_IpRamHeadermac (

	          .data                                    (MacHeader_data[7:0]),
				 .wraddress                               (MacHeader_add[5:0]),
				 .wren                                    (MacHeader_wr),
				 
				 .rdaddress                               (contavbyte[5:0]),
				 .rden                                    (EnRdHdEth),
				 
				 .wrclock                                 (clk),
				 .rdclock                                 (ClkPhy),
				 
				 .q                                       (dataHeader[7:0])
			 		 
	);
	
   //--------------------------------------------------------------------------------------------
	//Controle de Leitura do cabeçalho MAC e buffer de pacotes
	//--------------------------------------------------------------------------------------------
	
	CtrlRdTxTsOIp u_CtrlRdTxTsOIp (

	          .i_Clk                                   (ClkPhy),
				 .i_nRst                                  (MacHeader_nRst),
				 .i_NivelRdFifo                           (NivelRdFifo[10:0]),
				 .i_NumPactRd                             (i_NumberPacket[2:0]),
				 .i_BytespPact                            (i_ts_PacketLength[7:0]),
				 .i_FifoEmpty                             (1'b0),
				 .HeaderEthLength                         (8'd42),
				 
				 
				 .o_EnableRdPact                          (enRd),
				 .o_EnableRdHdEth                         (EnRdHdEth),
				 .o_ValidOut                              (Out_Valid),
				 .o_Sync                                  (Out_Sync),
				 .o_End                                   (Out_End),
				 .o_AddrHeader                            (contavbyte[10:0]),
				 .o_Ler                                   ()
			 		 
	);
	
   //--------------------------------------------------------------------------------------------
	//Mux de Cabeçalho e pacotes TS
	//--------------------------------------------------------------------------------------------
	
		MuxHdPactAddCRC u_MuxHdPactAddCRC (

	          .i_Clk                                   (ClkPhy),
				 .i_nRst                                  (MacHeader_nRst),
				 .i_Sync                                  (Out_Sync),
				 .i_End                                   (Out_End),
				 .i_ValidHdEth                            (EnRdHdEth),
				 .i_DataHd                                (dataHeader[7:0]),
				 .i_ValidPact                             (enRd),
				 .i_DataPacket                            (DataFromFifo[7:0]),
				 
				 
				 .o_Sync                                  (o_Sync),
				 .o_End                                   (o_End),
				 .o_Valid                                 (o_Valid),
				 .o_Data                                  (o_Data[7:0]),
				 .o_ValidCRC                              (oValidCRC),
				 .o_ValidCRC32                            ()
			 		 
	);

   //--------------------------------------------------------------------------------------------
	//Geracao/Insercao do CRC
	//--------------------------------------------------------------------------------------------
	
		mux_crc u_mux_crc (

	          .i_Clk                                   (ClkPhy),
				 .i_nRst                                  (MacHeader_nRst),
				 
				 .i_Data                                  (o_Data[7:0]),
				 .i_Sync                                  (o_Sync),
				 .i_Valid                                 (o_Valid),
				 .i_ValidCRC                              (oValidCRC),
				 .i_CRC                                   (Update_fcs[31:0]),
				 
				 .o_Data                                  (data_tx_crc[7:0]),
				 .o_Sync                                  (sync_tx_crc),
				 .o_Valid                                 (valid_tx_crc),			 
				 .o_End                                   (end_tx_crc)
			 		 
	);
	
		teste_crc u_teste_crc (

	          .i_Clk                                   (ClkPhy),
				 .i_nRst                                  (MacHeader_nRst),
				 
				 .i_Sync                                  (o_Sync),
				 .i_Valid                                 (o_Valid),
				 .i_Data                                  (o_Data[7:0]),
				 .i_ValidCRC                              (oValidCRC),
				 
				 .o_Data                                  (data_test[7:0]),
				 .o_Clr                                   (oClr),
				 .o_Valid                                 (valid_test)
			 		 
	);
	
		auk_udpipmac_ethernet_crc u_auk_udpipmac_ethernet_crc (

	          .clk                                     (ClkPhy),
				 .rst                                     (~MacHeader_nRst),
				 
				 .din                                     (data_test[7:0]),
				 .din_valid                               (valid_test),
				 .clear_crc                               (oClr),
				 
				 .crc                                     (fcs[31:0]),
				 .crc_error                               ()
			 		 
	);
	
		myblkinv2 u_myblkinv2 (

	          .in                                      (fcs[31:0]),
				 
				 .out                                     (Update_fcs[31:0])
			 		 
	);
	
   //--------------------------------------------------------------------------------------------
	//Prepara dados para o PHY
	//--------------------------------------------------------------------------------------------
	
		PhyInterface u_PhyInterface (

				 .in_Rst                                  (~MacHeader_nRst),
				 .in_TxClk                                (ClkPhy),
				 
				 .in_MacTxEna                             (valid_tx_crc),
				 .in_MacTxData                            (data_tx_crc[7:0]),
				 .in_MacTxStart                           (sync_tx_crc),
				 .in_MacTxEnd                             (end_tx_crc),
				 
				 .out_PhyTxEna                            (PhytxEna),
				 .out_PhyTxData                           (PhytxData[3:0])
			 		 
	);

endmodule 