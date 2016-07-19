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
--!- Project Name: TOP_MEDoIP.v                       
--!- Module Name: TOP_MEDoIP
--!- Tools: Quartus II 10.0  
--!- Author: Franz Wagner
--!- Company: HK LINEAR
--!- Create Date: 20/11/2012     
--!- Version: 1.0.0 (Nov/2012)  
--------------------------------------------------------------------------------
-- HKLINEAR - 2012
--------------------------------------------------------------------------------
--}}} Header*/

module TOP_MEDoIP (

          	 input                    In_Clk_Dado,
				 input                    In_nRst,
				 input                    In_Clk_Phy,
				 input                    In_ts_valid,
				 input                    In_ts_sync,
				 input   [7:0]            In_ts_data,
				 input  [10:0]            In_ts_PacketLength,
				 
				 input                    In_En_nios,
	          input                    In_Sync_nios,
	          input   [7:0]            In_Data_nios,
				 
				 output                   Out_PhytxEna,
				 output  [3:0]            Out_PhytxData

);


wire               MacHeader_nRst;
wire   [7:0]       DataToFifo;
wire               ValidToFifo;

wire   [7:0]       DataFromFifo;
wire  [11:0]       NivelRdFifo;
wire               enRd;
wire               EnRdHdEth;
wire               Out_Valid;
wire               Out_Sync;
wire               Out_End;
wire               oClr;
wire               valid_test;

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

wire   [7:0]      o_Data;
wire              o_Valid;
wire              o_Sync;
wire              o_End;

wire   [7:0]      data_test;

wire  				fifo_rst;
wire  				fifo_full;

wire  [47:0]      w_out_mac_tx;
wire  [31:0]      w_out_ip_tx;
wire  [15:0]      w_out_port_tx;

	//--------------------------------------------------------------------------------------------
	//Controle de escrita dos pacotes no buffer
	//--------------------------------------------------------------------------------------------
	Decoder_IP_TX u_Decoder_IP_TX (
	          .In_Reset                                   (~In_nRst),
	          .In_Clk_nios                                (In_Clk_Dado),
	          .In_En_nios                                 (In_En_nios),
	          .In_Sync_nios                               (In_Sync_nios),
	          .In_Data_nios                               (In_Data_nios[7:0]),
				 
				 .Out_MAC               	                  (w_out_mac_tx[47:0]),
				 .Out_IP                 	                  (w_out_ip_tx[31:0]),
				 .Out_PORT                                   (w_out_port_tx[15:0])
				 );
	//--------------------------------------------------------------------------------------------
	//Controle de escrita dos pacotes no buffer
	//--------------------------------------------------------------------------------------------
	CtrlWrTxTsOIP u_TOP_CtrlWrTxTsOIP (
	          .i_Clk                                   	(In_Clk_Dado),
				 .i_nRst                  		               (MacHeader_nRst),
				 .i_Valid                     	            (In_ts_valid),
				 .i_Sync                         	         (In_ts_sync),
				 .i_Data                            	      (In_ts_data[7:0]),
				 .i_PacketLength                       	   (In_ts_PacketLength[10:0]),
				 
				 .o_Data                                  	(DataToFifo[7:0]),
				 .o_Valid                    		            (ValidToFifo),
				 .o_Sync                         	         ()	 
				 );
   //--------------------------------------------------------------------------------------------
	//Buffer de pacotes de entrada
	//--------------------------------------------------------------------------------------------
   IpFifoTsOIp u_IpFifoTsOIp (
	          .data       	                             (DataToFifo[7:0]),
				 .wrreq        	                          (ValidToFifo),
				 .wrclk           	                       (In_Clk_Dado),
				 
				 .rdreq              	                    (enRd),
				 .rdclk                 	                 (In_Clk_Phy),
				 .aclr                     	              (fifo_rst),
				 
				 .wrfull                      	           (fifo_full),
				 .wrusedw                        	        (),
				 .q                                 	     (DataFromFifo[7:0]),
				 .rdempty                              	  (),
				 .rdusedw                                   (NivelRdFifo[11:0])
				 );
   //--------------------------------------------------------------------------------------------
	//Cria cabeçalho MAC
	//--------------------------------------------------------------------------------------------
	mac_header u_mac_header (
	          .i_Clk                                  		(In_Clk_Dado),
				 .i_nRst                          		      (In_nRst),
				 .i_MacDest                            	   (w_out_mac_tx[47:0]),
				 .i_MacSource                             	(48'h585076ddeeff),
				 .i_IPDest            		                  (w_out_ip_tx[31:0]),
				 .i_IPSource               	               (32'h0a001b43),
				 .i_Protocol                  	            (8'h11),
				 .i_PortDest                     	         (w_out_port_tx[15:0]),
				 .i_PortSource                      	      (w_out_port_tx[15:0]),
				 .i_TTL                                	   (8'hFF),
				 .i_ts_PacketLength                       	(In_ts_PacketLength[10:0]),
				 
				 .o_Data                     		            (MacHeader_data[7:0]),
				 .o_Add                          	         (MacHeader_add[5:0]),
				 .o_Valid                           	      (MacHeader_wr),
				 .o_HeaderReady                        	   (MacHeader_nRst)
				 );
	
	IpRamHeadermac u_IpRamHeadermac (
	          .data                        	            (MacHeader_data[7:0]),
				 .wraddress                      	         (MacHeader_add[5:0]),
				 .wren                              	      (MacHeader_wr),
				 
				 .rdaddress                            	   (contavbyte[5:0]),
				 .rden                                    	(EnRdHdEth),
				 
				 .wrclock                           	      (In_Clk_Dado),
				 .rdclock                              	   (In_Clk_Phy),
				 
				 .q                                       	(dataHeader[7:0])
				 );
   //--------------------------------------------------------------------------------------------
	//Controle de Leitura do cabeçalho MAC e buffer de pacotes
	//--------------------------------------------------------------------------------------------
	CtrlRdTxTsOIp u_CtrlRdTxTsOIp (
	          .i_Clk                         		         (In_Clk_Phy),
				 .i_nRst                            	      (MacHeader_nRst),
				 .i_NivelRdFifo                        	   (NivelRdFifo[11:0]),
				 .i_BytespPact                            	(In_ts_PacketLength[10:0]),
				 .i_Fifo_Full                       	      (fifo_full),
				 .HeaderEthLength                      	   (8'd42),
				 
				 
				 .o_EnableRdPact                          	(enRd),
				 .o_EnableRdHdEth                 		      (EnRdHdEth),
				 .o_ValidOut                           	   (Out_Valid),
				 .o_Sync                               	   (Out_Sync),
				 .o_End                                   	(Out_End),
				 .o_AddrHeader                      	      (contavbyte[10:0]),
				 .o_Fifo_Rst                           	   (fifo_rst)
				 );
   //--------------------------------------------------------------------------------------------
	//Mux de Cabeçalho e pacotes TS
	//--------------------------------------------------------------------------------------------
		MuxHdPactAddCRC u_MuxHdPactAddCRC (
	          .i_Clk                      	   	         (In_Clk_Phy),
				 .i_nRst                      	            (MacHeader_nRst),
				 .i_Sync                            	      (Out_Sync),
				 .i_End                                	   (Out_End),
				 .i_ValidHdEth                            	(EnRdHdEth),
				 .i_DataHd                      		         (dataHeader[7:0]),
				 .i_ValidPact                       	      (enRd),
				 .i_DataPacket                         	   (DataFromFifo[7:0]),
				 
				 
				 .o_Sync                            	      (o_Sync),
				 .o_End                                	   (o_End),
				 .o_Valid                                 	(o_Valid),
				 .o_Data                             		   (o_Data[7:0]),
				 .o_ValidCRC                              	(oValidCRC)
				 );
   //--------------------------------------------------------------------------------------------
	//Geracao/Insercao do CRC
	//--------------------------------------------------------------------------------------------
		mux_crc u_mux_crc (
	          .i_Clk                    	               (In_Clk_Phy),
				 .i_nRst                      	            (MacHeader_nRst),
				 
				 .i_Data                         	         (o_Data[7:0]),
				 .i_Sync                            	      (o_Sync),
				 .i_Valid                              	   (o_Valid),
				 .i_ValidCRC                              	(oValidCRC),
				 .i_CRC                              		   (Update_fcs[31:0]),
				 
				 .o_Data                  		               (data_tx_crc[7:0]),
				 .o_Sync                      	            (sync_tx_crc),
				 .o_Valid                        	         (valid_tx_crc),			 
				 .o_End                             	      (end_tx_crc)
				 );
	
		teste_crc u_teste_crc (
	          .i_Clk                                	   (In_Clk_Phy),
				 .i_nRst                                  	(MacHeader_nRst),
				 
				 .i_Sync                     		            (o_Sync),
				 .i_Valid                        	         (o_Valid),
				 .i_Data                            	      (o_Data[7:0]),
				 .i_ValidCRC                           	   (oValidCRC),
				 
				 .o_Data                    		            (data_test[7:0]),
				 .o_Clr                          	         (oClr),
				 .o_Valid                           	      (valid_test)
				 );
	
		auk_udpipmac_ethernet_crc u_auk_udpipmac_ethernet_crc (
	          .clk                                  	   (In_Clk_Phy),
				 .rst                                     	(~MacHeader_nRst),
				 
				 .din                               	      (data_test[7:0]),
				 .din_valid                            	   (valid_test),
				 .clear_crc                               	(oClr),
				 
				 .crc                               	      (fcs[31:0]),
				 .crc_error                            	   ()
				 );
	
		myblkinv2 u_myblkinv2 (
	          .in                                      	(fcs[31:0]),
				 
				 .out                            	         (Update_fcs[31:0])
				 );
   //--------------------------------------------------------------------------------------------
	//Prepara dados para o PHY
	//--------------------------------------------------------------------------------------------
		PhyInterface u_PhyInterface (
				 .in_Rst                            	      (~MacHeader_nRst),
				 .in_TxClk                             	   (In_Clk_Phy),
					
				 .in_MacTxEna                 	            (valid_tx_crc),
				 .in_MacTxData                   	         (data_tx_crc[7:0]),
				 .in_MacTxStart                     	      (sync_tx_crc),
				 .in_MacTxEnd                          	   (end_tx_crc),
				 
				 .out_PhyTxEna                            	(Out_PhytxEna),
				 .out_PhyTxData                  				(Out_PhytxData[3:0])
				 );

endmodule 