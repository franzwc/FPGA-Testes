--------------------------------------------------------------------------------
--!@file VHDL FILE
--!@brief Top Medipix
--------------------------------------------------------------------------------                                                                      

--! Topo de Hierarquia do projeto Top Medipix.
--! Ele instancia todos os outros blocos.

--! @details
--! Project Name: TOP_Medipix.vhd
--!         
--! Tools: Quartus II 10.0 SP1 
--! @name TOP_Medipix
--! @author Franz Wagner
--! @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
--! @date 30/10/2013     
--! @version 1.0.0 (Nov/2013) 
--------------------------------------------------------------------------------
--! LNLS - DET - 2013
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
USE ieee.std_logic_arith.all;

entity Top_Medipix is
		
		generic
		(	--!<Tamanho do Payload
			gPacket_Length					:	natural range 0 to 2047 := 1024
		
		);
		port
		(
			--Clocks de Entrada
			Clk25                  		:	in  std_logic;
			Clk125                 		:	in  std_logic;
			
			--DDR2 Sdram (1.8v)
			Ddr2_A                     :  out std_logic_vector(13 downto 0);
			Ddr2_Ba                    :  out std_logic_vector(2 downto 0);
			Ddr2_Cas_N                 :  out std_logic;
			Ddr2_Cke                   :  out std_logic;
			Ddr2_Clk_P                 :  inout std_logic;
			Ddr2_Clk_N                 :  inout std_logic;
			Ddr2_Cs_N                  :  out std_logic;
			Ddr2_Dm                    :  inout std_logic_vector(1 downto 0);
			Ddr2_Dq                    :  inout std_logic_vector(15 downto 0);
			Ddr2_Dqs                   :  inout std_logic_vector(1 downto 0);
			Ddr2_Odt                   :  out std_logic;
			Ddr2_Ras_N                 :  out std_logic;
			Ddr2_We_N                  :  out std_logic;
			
			--Gigabit Ethernet Phy rgmii gmii interface (3.3v)
			Eth_Txc                    :  out std_logic;
			Eth_TxCtl                  :  out std_logic;
			Eth_Txd                    :  out std_logic_vector(3 downto 0);
			Eth_Rxc                    :  in  std_logic;
			Eth_RxCtl                  :  in  std_logic;
			Eth_Rxd                    :  in  std_logic_vector(3 downto 0);
			Eth_Mdc                    :  out std_logic;
			Eth_Mdio                   :  inout std_logic;
			Eth_Rst_N                  :  out std_logic;
			Eth_Int_N                  :  in  std_logic;
			
			--EPCS Flash
			Flash_Do                   :  in  std_logic;
			Flash_Cclk                 :  out std_logic;
			Flash_Cs_N                 :  out std_logic;
			Flash_Di                   :  out std_logic;
			
			--Led
			Led_N                      :  out std_logic_vector(2 downto 0);
			
			--Conversores DA e AD
			ADC_Sclk                   :  out std_logic;
			ADC_Csn                    :  out std_logic;
			ADC_Dout                   :  in  std_logic;
			ADC_Din                    :  out std_logic;
		
			DAC_Sclk                   :  out std_logic;
			DAC_Csn                    :  out std_logic;
			DAC_Sdi                    :  out std_logic;
			
			--Controles Medipix
			Reset_out_Mdpx             :  out std_logic;
			Clk_out_Mdpx               :  out std_logic;
			Data_out_Mdpx              :  out std_logic;
			En_out_Mdpx                :  out std_logic;
			Shutter_out_Mdpx           :  out std_logic;
			Cont_sel_out_Mdpx          :  out std_logic;
			MtxClr_out_Mdpx            :  out std_logic;
			TPSWT_out_Mdpx             :  out std_logic;
			
			--Entrada Dados Medipix
			Clk_in_Mdpx                :  in  std_logic;
			En_in_Mdpx                 :  in  std_logic;
			Data_in_Mdpx               :  in  std_logic_vector(7 downto 0)
						
		);
end Top_Medipix;

architecture Top_Medipix_arc of Top_Medipix is

		--Sincronismo de Reset
		component Rst_Syncronizer is
		port
		(
			In_nRst                        :	in  std_logic;
			In_Clk                         :	in  std_logic;
			
			Out_rst							    :	out std_logic;
			Out_nrst                       :	out std_logic
		);
		end component;																	

		--Master PLL
		component cpu_pll is															
		port
		(
			inclk0                         :	in	 std_logic;
			areset                         :	in  std_logic;
			
			c0									    :	out std_logic;
			c1					                :	out std_logic;
			c2					                :	out std_logic;
			c3                             :	out std_logic;
			c4                             :	out std_logic
		);
		end component;

		--Controlador AD
		component ADC_Bridge is															
		port
		(
			In_Reset                       :	in	 std_logic;
			In_Clk_Adc                     :	in  std_logic;
			In_Adc_data                    :	in  std_logic;
			
			Out_Adc							    :	out std_logic
		);
		end component;

		--Controlador DA
		component DAC_Bridge is															
		port
		(
			In_Reset                       :	in	 std_logic;
			In_Clk_Dac                     :	in  std_logic;
			
			Out_Clk_Dac			    			 :	out std_logic;
			Out_Data_Dac					    :	out std_logic
		);
		end component;

		--Medipix Bridge
		component Medipix_Bridge is															
		port
		(
			In_Reset                       :	in	 std_logic;
			In_Clk_nios                    :	in  std_logic;
			In_Clk                         :	in  std_logic;
			In_En_nios                     :	in  std_logic;
			In_Sync_nios                   :	in  std_logic;
			In_Data_nios                   :	in  std_logic_vector(7 downto 0);
			
			Out_M					          	 :	out std_logic_vector(2 downto 0);
			Out_Reset_Mdpx					    :	out std_logic;
			Out_Clk_Mdpx					    :	out std_logic;
			Out_Data_Mdpx					    :	out std_logic;
			Out_En_Mdpx					       :	out std_logic;
			Out_Shutter_Mdpx				    :	out std_logic;
			Out_Cont_sel_Mdpx				    :	out std_logic;
			Out_MtxClr_Mdpx				    :	out std_logic;
			Out_TPSWT_Mdpx					    :	out std_logic
		);
		end component;

		--Medipix Data Receive
		component Rx_Data_Medipix is															
		port
		(
			In_Reset                       :	in	 std_logic;
			In_Clk_10M                     :	in  std_logic;
			In_Clk_Double                  :	in  std_logic;
			In_Clk_Mdpx                    :	in  std_logic;
			In_En_Mdpx                     :	in  std_logic;
			In_Data_Mdpx                   :	in  std_logic;
			In_Packet_Length               :	in  natural range 0 to 2047;
			In_M                           :	in  std_logic_vector(2 downto 0);
			In_PS                          :	in  std_logic_vector(1 downto 0);
			In_CountL                      :	in  std_logic_vector(1 downto 0);
			In_OutEn_Mdpx                  :	in  std_logic;
			
			Out_Sync			      		    :	out std_logic;
			Out_Valid					       :	out std_logic;
			Out_Data					          :	out std_logic_vector(7 downto 0)
		);
		end component;

		--Medipix Over Ethernet
		component Decoder_IP_TX is															
		port
		(
			In_Reset                       :	in	 std_logic;
			In_Clk_nios                    :	in  std_logic;
			In_En_nios                     :	in  std_logic;
			In_Sync_nios                   :	in  std_logic;
			In_Data_nios                   :	in  std_logic_vector(7 downto 0);
			
			Out_MAC	    	   			    :	out std_logic_vector(47 downto 0);
			Out_IP		    			       :	out std_logic_vector(31 downto 0);
			Out_PORT					          :	out std_logic_vector(15 downto 0)
		);
		end component;

		component TOP_MEDoIP is															
		port
		(
			In_Clk_Dado                    :	in	 std_logic;
			In_nRst                        :	in  std_logic;
			In_Clk_Phy                     :	in  std_logic;
			In_ts_valid                    :	in  std_logic;
			In_ts_sync                     :	in  std_logic;
			In_ts_data                     :	in  std_logic_vector(7 downto 0);
			In_ts_PacketLength             :	in  natural range 0 to 2047;
			In_MacDest                     :	in  std_logic_vector(47 downto 0);
			In_MacSource                   :	in  std_logic_vector(47 downto 0);
			In_IpDest                      :	in  std_logic_vector(31 downto 0);
			In_IpSource                    :	in  std_logic_vector(31 downto 0);
			In_Protocol                    :	in  std_logic_vector(7 downto 0);
			In_PortDest                    :	in  std_logic_vector(15 downto 0);
			In_PortSource                  :	in  std_logic_vector(15 downto 0);
			In_TimeToLive                  :	in  std_logic_vector(7 downto 0);
			
			Out_PhytxEna					    :	out std_logic;
			Out_PhytxData					    :	out std_logic_vector(3 downto 0)
		);
		end component;

		--Compartilhamento Ethernet
		component Eth_Share is															
		port
		(
			In_Reset                       :	in	 std_logic;
			In_Clk                         :	in  std_logic;
			In_Eth_Valid_Medpx             :	in  std_logic;
			In_Eth_Data_Medpx              :	in  std_logic_vector(3 downto 0);
			In_Eth_Valid_Linux             :	in  std_logic;
			In_Eth_Data_Linux              :	in  std_logic_vector(3 downto 0);
			
			Out_Eth_Valid					    :	out std_logic;
			Out_Eth_Data					    :	out std_logic_vector(3 downto 0)
		);
		end component;

		--SOPC Medipix
		component Medipix_sopc is															
		port
		(
			--Global Signals
			clk_125                        :	in	 std_logic;
			reset_n                        :	in  std_logic;
			
			--Igor Mac
			mcoll_pad_i_to_the_igor_mac    :	in  std_logic;
			mcrs_pad_i_to_the_igor_mac     :	in  std_logic;
			md_pad_i_to_the_igor_mac       :	in  std_logic;
			mrx_clk_pad_i_to_the_igor_mac  :	in  std_logic;
			mrxd_pad_i_to_the_igor_mac     :	in  std_logic_vector(3 downto 0);
			mrxdv_pad_i_to_the_igor_mac    :	in  std_logic;
			mrxerr_pad_i_to_the_igor_mac   :	in  std_logic;
			mtx_clk_pad_i_to_the_igor_mac  :	in  std_logic;
			
			md_pad_o_from_the_igor_mac		 :	out std_logic;
			md_padoe_o_from_the_igor_mac	 :	out std_logic;
			mdc_pad_o_from_the_igor_mac	 :	out std_logic;
			mtxd_pad_o_from_the_igor_mac	 :	out std_logic_vector(3 downto 0);
			mtxen_pad_o_from_the_igor_mac	 :	out std_logic;
			mtxerr_pad_o_from_the_igor_mac :	out std_logic;
			
			--SPI
			MISO_to_the_spi_0              :	in  std_logic;
			
			MOSI_from_the_spi_0	          :	out std_logic;
			SCLK_from_the_spi_0	          :	out std_logic;
			SS_n_from_the_spi_0	          :	out std_logic_vector(1 downto 0);
			
			--EPCS Flash
			data0_to_the_epcs_controller   :	in  std_logic;
			
			dclk_from_the_epcs_controller  :	out std_logic;
			sce_from_the_epcs_controller   :	out std_logic;
			sdo_from_the_epcs_controller   :	out std_logic;
			
			--DDR2 Sdram
			ram_aux_full_rate_clk_out      :	out std_logic;
			ram_aux_half_rate_clk_out      :	out std_logic;
			ram_phy_clk_out                :	out std_logic;
			
			global_reset_n_to_the_ram      :	in  std_logic;
			
			local_init_done_from_the_ram   :	out std_logic;
			local_refresh_ack_from_the_ram :	out std_logic;
			local_wdata_req_from_the_ram   :	out std_logic;
			
			mem_addr_from_the_ram          :	out std_logic_vector(12 downto 0);
			mem_ba_from_the_ram            :	out std_logic_vector(2 downto 0);
			mem_cas_n_from_the_ram         :	out std_logic;
			mem_cke_from_the_ram           :	out std_logic;
			mem_clk_n_to_and_from_the_ram  :	out std_logic;
			mem_clk_to_and_from_the_ram    :	out std_logic;
			mem_cs_n_from_the_ram          :	out std_logic;
			mem_dm_from_the_ram            :	out std_logic_vector(1 downto 0);
			mem_dq_to_and_from_the_ram     :	out std_logic_vector(15 downto 0);
			mem_dqs_to_and_from_the_ram    :	out std_logic_vector(1 downto 0);
			mem_odt_from_the_ram           :	out std_logic;
			mem_ras_n_from_the_ram         :	out std_logic;
			mem_we_n_from_the_ram          :	out std_logic;
			reset_phy_clk_n_from_the_ram   :	out std_logic;
			
			--Tx Table
			clock_vhdl_to_the_tx_table     :	in  std_logic;
			in_Nreset_to_the_tx_table      :	in  std_logic;
			
			info_out_from_the_tx_table     :	out std_logic_vector(7 downto 0);
			irq_from_the_tx_table          :	out std_logic;
			out_data_from_the_tx_table     :	out std_logic_vector(7 downto 0);
			out_sync_from_the_tx_table     :	out std_logic;
			out_valid_from_the_tx_table    :	out std_logic
			
		);
		end component;
		
		-- Signals
		signal	Clk_125						 :	std_logic;
		signal	igor_clk						 :	std_logic;
		signal	clk_10						 :	std_logic;
		signal	clk_20			          :	std_logic;
		signal	Rst25                    :	std_logic;
		signal	nRst25                   :	std_logic;
		
		signal	table_nios_data			 :	std_logic_vector(7 downto 0);
		signal	table_nios_sync			 :	std_logic;
		signal	table_nios_valid		    :	std_logic;
		
		signal	spi_sclk			          :	std_logic;
		signal	spi_csn						 :	std_logic_vector(1 downto 0);
		signal	spi_mosi					    :	std_logic;
		signal	spi_miso			          :	std_logic;
				
		signal	w_M                      :	std_logic_vector(2 downto 0);
		signal   sig_en_out_Mdpx          : std_logic;

		signal	mdpx_data                :	std_logic_vector(7 downto 0);
		signal	mdpx_valid			     	 :	std_logic;
		signal	mdpx_sync					 :	std_logic;

		signal	Eth_tx_en_Mdpx				 :	std_logic;
		signal	Eth_tx_data_Mdpx			 :	std_logic_vector(3 downto 0);
		signal	Eth_tx_en_linux			 :	std_logic;
		signal	Eth_tx_data_linux			 :	std_logic_vector(3 downto 0);

		signal	w_out_mac_tx				 :	std_logic_vector(47 downto 0);
		signal	w_out_ip_tx              :	std_logic_vector(31 downto 0);
		signal	w_out_port_tx            :	std_logic_vector(15 downto 0);

		signal	mdio_oen_from_the_igor_mac :	std_logic;
		signal	mdio_out_from_the_igor_mac :	std_logic;


begin

		-- Component Instatiation
		--Sincronismo de Reset
		u_Rst_Syncronizer: Rst_Syncronizer
		port map
		(
			In_nRst                        =>'1',
			In_Clk                         =>Clk25,
			
			Out_rst							    =>Rst25,
			Out_nrst                       =>nRst25
		);
		
		--Sistem PLL
		u_cpu_pll: cpu_pll
		port map
		(
			inclk0                         =>Clk25,
			areset                         =>Rst25,
			
			c0									    =>Clk_125,
			c1					                =>igor_clk,
			c2					                =>clk_10,
			c3                             =>clk_20
			--c4                             =>
		);

		--Controlador AD
		u_ADC_Bridge: ADC_Bridge
		port map
		(
			In_Reset                       =>Rst25,
			In_Clk_Adc                     =>igor_clk,
			In_Adc_data                    =>'0'
			
			--Out_Adc							    =>
		);

		--Controlador DA
		u_DAC_Bridge: DAC_Bridge
		port map
		(
			In_Reset                       =>Rst25,
			In_Clk_Dac                     =>igor_clk
			
			--Out_Clk_Dac			    			 =>'-'
			--Out_Data_Dac					    =>'-'
		);

		--Medipix Bridge
		u_Medipix_Bridge: Medipix_Bridge
		port map
		(
			In_Reset                       =>Rst25,
			In_Clk_nios                    =>clk_10,
			In_Clk                         =>clk_20,
			In_En_nios                     =>table_nios_valid,
			In_Sync_nios                   =>table_nios_sync,
			In_Data_nios                   =>table_nios_data(7 downto 0),
			
			Out_M					          	 =>w_M(2 downto 0),
			Out_Reset_Mdpx					    =>Reset_out_Mdpx,
			Out_Clk_Mdpx					    =>Clk_out_Mdpx,
			Out_Data_Mdpx					    =>Data_out_Mdpx,
			Out_En_Mdpx					       =>sig_en_out_Mdpx,
			Out_Shutter_Mdpx				    =>Shutter_out_Mdpx,
			Out_Cont_sel_Mdpx				    =>Cont_sel_out_Mdpx,
			Out_MtxClr_Mdpx				    =>MtxClr_out_Mdpx,
			Out_TPSWT_Mdpx					    =>TPSWT_out_Mdpx
		);

		--Medipix Data Receive
		u_Rx_Data_Medipix: Rx_Data_Medipix
		port map
		(
			In_Reset                       =>Rst25,
			In_Clk_10M                     =>clk_10,
			In_Clk_Double                  =>clk_20,
			In_Clk_Mdpx                    =>Clk_in_Mdpx,
			In_En_Mdpx                     =>En_in_Mdpx,
			In_Data_Mdpx                   =>Data_in_Mdpx(0),
			In_Packet_Length               =>gPacket_Length,
			In_M                           =>w_M(2 downto 0),
			In_PS                          =>(others=>'0'),
			In_CountL                      =>(others=>'0'),
			In_OutEn_Mdpx                  =>sig_en_out_Mdpx,
			
			Out_Sync			      		    =>mdpx_sync,
			Out_Valid					       =>mdpx_valid,
			Out_Data					          =>mdpx_data(7 downto 0)
		);

      --Medipix Over Ethernet
		u_Decoder_IP_TX: Decoder_IP_TX
		port map
		(
			In_Reset                       =>Rst25,
			In_Clk_nios                    =>clk_10,
			In_En_nios                     =>table_nios_valid,
			In_Sync_nios                   =>table_nios_sync,
			In_Data_nios                   =>table_nios_data(7 downto 0),
			
			Out_MAC	    	   			    =>w_out_mac_tx(47 downto 0),
			Out_IP		    			       =>w_out_ip_tx(31 downto 0),
			Out_PORT					          =>w_out_port_tx(15 downto 0)
		);

		u_TOP_MEDoIP: TOP_MEDoIP
		port map
		(
			In_Clk_Dado                    =>clk_10,
			In_nRst                        =>nRst25,
			In_Clk_Phy                     =>igor_clk,
			In_ts_valid                    =>mdpx_valid,
			In_ts_sync                     =>mdpx_sync,
			In_ts_data                     =>mdpx_data(7 downto 0),
			In_ts_PacketLength             =>gPacket_Length+4,
			In_MacDest                     =>w_out_mac_tx(47 downto 0),
			In_MacSource                   =>x"585076DDEEFF",
			In_IpDest                      =>w_out_ip_tx(31 downto 0),
			In_IpSource                    =>x"0a001b44",
			In_Protocol                    =>x"11",
			In_PortDest                    =>x"0BB8",
			In_PortSource                  =>w_out_port_tx(15 downto 0),
			In_TimeToLive                  =>x"FF",
			
			Out_PhytxEna					    =>Eth_tx_en_Mdpx,
			Out_PhytxData					    =>Eth_tx_data_Mdpx(3 downto 0)
		);

		--Compartilhamento Ethernet
		u_Eth_Share: Eth_Share
		port map
		(
			In_Reset                       =>Rst25,
			In_Clk                         =>igor_clk,
			In_Eth_Valid_Medpx             =>Eth_tx_en_Mdpx,
			In_Eth_Data_Medpx              =>Eth_tx_data_Mdpx(3 downto 0),
			In_Eth_Valid_Linux             =>Eth_tx_en_linux,
			In_Eth_Data_Linux              =>Eth_tx_data_linux(3 downto 0),
			
			Out_Eth_Valid					    =>Eth_TxCtl,
			Out_Eth_Data					    =>Eth_Txd(3 downto 0)
		);

		--SOPC Medipix
		u_Medipix_sopc: Medipix_sopc
		port map
		(
			--Global Signals
			clk_125                        =>Clk_125,
			reset_n                        =>nRst25,
			
			--Igor Mac
			mcoll_pad_i_to_the_igor_mac    =>'0',
			mcrs_pad_i_to_the_igor_mac     =>'0',
			md_pad_i_to_the_igor_mac       =>Eth_Mdio,
			mrx_clk_pad_i_to_the_igor_mac  =>not(Eth_Rxc),
			mrxd_pad_i_to_the_igor_mac     =>Eth_Rxd(3 downto 0),
			mrxdv_pad_i_to_the_igor_mac    =>Eth_RxCtl,
			mrxerr_pad_i_to_the_igor_mac   =>'0',
			mtx_clk_pad_i_to_the_igor_mac  =>igor_clk,
			
			md_pad_o_from_the_igor_mac		 =>mdio_out_from_the_igor_mac,
			md_padoe_o_from_the_igor_mac	 =>mdio_oen_from_the_igor_mac,
			mdc_pad_o_from_the_igor_mac	 =>Eth_Mdc,
			mtxd_pad_o_from_the_igor_mac	 =>Eth_tx_data_linux(3 downto 0),
			mtxen_pad_o_from_the_igor_mac	 =>Eth_tx_en_linux,
			--mtxerr_pad_o_from_the_igor_mac =>'-',
			
			--SPI
			MISO_to_the_spi_0              =>'0',
			
			MOSI_from_the_spi_0	          =>spi_mosi,
			SCLK_from_the_spi_0	          =>spi_sclk,
			SS_n_from_the_spi_0	          =>spi_csn,
			
			--EPCS Flash
			data0_to_the_epcs_controller   =>Flash_Do,
			
			dclk_from_the_epcs_controller  =>Flash_Cclk,
			sce_from_the_epcs_controller   =>Flash_Cs_N,
			sdo_from_the_epcs_controller   =>Flash_Di,
			
			--DDR2 Sdram
			--ram_aux_full_rate_clk_out      =>'-',
			--ram_aux_half_rate_clk_out      =>'-',
			--ram_phy_clk_out                =>'-',
			
			global_reset_n_to_the_ram      =>nRst25,
			
			--local_init_done_from_the_ram   =>'-',
			--local_refresh_ack_from_the_ram =>'-',
			--local_wdata_req_from_the_ram   =>'-',
			
			mem_addr_from_the_ram          =>Ddr2_A(12 downto 0),
			mem_ba_from_the_ram            =>Ddr2_Ba(2 downto 0),
			mem_cas_n_from_the_ram         =>Ddr2_Cas_N,
			mem_cke_from_the_ram           =>Ddr2_Cke,
			mem_clk_n_to_and_from_the_ram  =>Ddr2_Clk_N,
			mem_clk_to_and_from_the_ram    =>Ddr2_Clk_P,
			mem_cs_n_from_the_ram          =>Ddr2_Cs_N,
			mem_dm_from_the_ram            =>Ddr2_Dm(1 downto 0),
			mem_dq_to_and_from_the_ram     =>Ddr2_Dq(15 downto 0),
			mem_dqs_to_and_from_the_ram    =>Ddr2_Dqs(1 downto 0),
			mem_odt_from_the_ram           =>Ddr2_Odt,
			mem_ras_n_from_the_ram         =>Ddr2_Ras_N,
			mem_we_n_from_the_ram          =>Ddr2_We_N,
			--reset_phy_clk_n_from_the_ram   =>'-',
			
			--Tx Table
			clock_vhdl_to_the_tx_table     =>clk_10,
			in_Nreset_to_the_tx_table      =>nRst25,
			
			--info_out_from_the_tx_table     =>,
			--irq_from_the_tx_table          =>'-',
			out_data_from_the_tx_table     =>table_nios_data(7 downto 0),
			out_sync_from_the_tx_table     =>table_nios_sync,
			out_valid_from_the_tx_table    =>table_nios_valid
			
		);

		Eth_Mdio <= mdio_out_from_the_igor_mac when (mdio_oen_from_the_igor_mac = '1') else 'Z';
		
		En_out_Mdpx<=sig_en_out_Mdpx;
	   Ddr2_A(13)<='0';
		Eth_Txc<=not(igor_clk);
		Eth_Rst_N<=nRst25;
		Led_N<= "000";
		

end Top_Medipix_arc;
