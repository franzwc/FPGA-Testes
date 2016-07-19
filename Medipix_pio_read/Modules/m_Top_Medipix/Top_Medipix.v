/*! Verilog HDL FILE
  @file
--------------------------------------------------------------------------------
  @brief Top Medipix
--------------------------------------------------------------------------------
 Topo de Hierarquia do projeto Top Medipix.

 Ele instancia todos os outros blocos.

 Project Name: TOP_Medipix.v

 Tools: Quartus II 10.0 SP1

 @name TOP_Medipix
 @author Franz Wagner
 @copyright LABORATORIO NACIONAL DE LUZ SINCROTRON - GRUPO DETECTORES
 @date 30/10/2013
 @version 1.0.0 (Nov/2013)

--------------------------------------------------------------------------------*/

module Top_Medipix (

      //--------------------------------------------------------------------------------------------
		//-- input clocks
		//--------------------------------------------------------------------------------------------

      input               Clk25,
		input               Clk125,
		
		//--------------------------------------------------------------------------------------------
		//-- ddr2 sdram (1.8V)
		//--------------------------------------------------------------------------------------------
		
		output  [13:0]       Ddr2_A,
		output  [2:0]        Ddr2_Ba,
		output               Ddr2_Cas_N,
		output               Ddr2_Cke,
		inout                Ddr2_Clk_P,
		inout                Ddr2_Clk_N,
		output               Ddr2_Cs_N,
		inout   [1:0]        Ddr2_Dm,
		inout   [15:0]       Ddr2_Dq,
		inout   [1:0]        Ddr2_Dqs,
		output               Ddr2_Odt,
		output               Ddr2_Ras_N,
		output               Ddr2_We_N,
  
		//--------------------------------------------------------------------------------------------
		//-- gigabit ethernet phy rgmii interface (3.3V)
		//--------------------------------------------------------------------------------------------
		
		output               Eth_Txc,
		output               Eth_TxCtl,
		output  [3:0]        Eth_Txd,
		input                Eth_Rxc,
		input                Eth_RxCtl,
		input   [3:0]        Eth_Rxd,
		output               Eth_Mdc,
		inout                Eth_Mdio,
		output               Eth_Rst_N,
		//input                Eth_Int_N,
		
		//--------------------------------------------------------------------------------------------
		//-- spi flash (3.3V)
		//--------------------------------------------------------------------------------------------

		input                Flash_Do,
		output               Flash_Cclk,
		output               Flash_Cs_N,
		output               Flash_Di,
		
		//--------------------------------------------------------------------------------------------
		//-- led (1.8V)
		//--------------------------------------------------------------------------------------------
		
		output   [2:0]       Led_N,
		
		//--------------------------------------------------------------------------------------------
		//-- Controles A/D e D/A
		//--------------------------------------------------------------------------------------------
		
		output               ADC_Sclk,
		output               ADC_Csn,
		input                ADC_Dout,
		output               ADC_Din,
		
		output               DAC_Sclk,
		output               DAC_Csn,
      output               DAC_Sdi,
		
		//--------------------------------------------------------------------------------------------
		//-- Controles Medipix
		//--------------------------------------------------------------------------------------------
		
		output               Reset_out_Mdpx,
		output               Clk_out_Mdpx,
		output               Data_out_Mdpx,
		output               En_out_Mdpx,
		output               Shutter_out_Mdpx,
		output               Cont_sel_out_Mdpx,
      output               MtxClr_out_Mdpx,
		output               TPSWT_out_Mdpx,
		
		//--------------------------------------------------------------------------------------------
		//-- Dados Medipix
		//--------------------------------------------------------------------------------------------
		
      input                Clk_in_Mdpx,
		input                En_in_Mdpx,
		input  [7:0]         Data_in_Mdpx

);

	   wire                 Rst25;
		wire                 nRst25;
		wire                 Clk_125;
		wire                 igor_clk;
		wire                 Clk_62;
		wire                 clk_10;
		wire                 clk_20;
		wire                 clk_shutter;
		
		wire   [7:0]         table_nios_data;
		wire                 table_nios_sync;
		wire                 table_nios_valid;
		
		wire   [2:0]         w_M;
		
		wire                 spi_sclk;
		wire                 spi_csn1;
		wire                 spi_csn2;
		wire                 spi_mosi;
		wire                 spi_miso;
		
		wire   [10:0]        reg_addr_a;
		wire                 reg_oen_a;
		

		

		
		assign   Led_N = 3'b0;
		
		//--------------------------------------------------------------------------------------------
		//--tamanho do payload do pacote ETH
		//--------------------------------------------------------------------------------------------
		parameter  Packet_Length=1024;//!< Tamanho do Payload
		//--------------------------------------------------------------------------------------------
		//--sincronisa reset
		//--------------------------------------------------------------------------------------------
		Rst_Syncronizer u_Rst_Syncronizer (
            .In_nRst                                      (1'b1),       // pb0
            .In_Clk                                       (Clk25),      // clk 25
				
            .Out_rst                                      (Rst25),      // rst
				.Out_nrst                                     (nRst25)
            );
		//--------------------------------------------------------------------------------------------
		//--Master PLL
		//--------------------------------------------------------------------------------------------		
		cpu_pll u_cpu_pll (
            .inclk0                                       (Clk25),      // 25MHz
            .areset                                       (Rst25),
				
            .c0                                           (Clk_125),    // 125MHz 
				.c1                                           (igor_clk),   // 25MHz
            .c2                                           (clk_10),     // 10MHz
				.c3                                           (clk_20),     // 20MHz
				.c4                                           () 				// 50MHz
            );
		//--------------------------------------------------------------------------------------------
		//--Medipix Bridge
		//--------------------------------------------------------------------------------------------	
		Medipix_Bridge u_Medipix_Bridge(
		      .In_Reset                                     (Rst25),
				.In_Clk_nios                                  (clk_10),
				.In_Clk                                       (clk_20),
				.In_En_nios                                   (table_nios_valid),
		      .In_Sync_nios                                 (table_nios_sync),  
		      .In_Data_nios                                 (table_nios_data[7:0]),
				
				.Out_TPSWT_Mdpx                               (spi_sclk)
				);


		//--------------------------------------------------------------------------------------------------
		//--SOPC Builder generated system
		//--------------------------------------------------------------------------------------------------
      wire        mdio_oen_from_the_igor_mac;
		wire        mdio_out_from_the_igor_mac;

		// Ethernet interface assignments
		assign Eth_Mdio    =   (mdio_oen_from_the_igor_mac) ? (mdio_out_from_the_igor_mac) : (1'bz);


		Medipix_sopc u_Medipix_sopc (
				 //global signals:
				 .clk_125                                    (Clk_125),
				 .reset_n                                    (nRst25),
  
				 //the_igor_mac
				 .mcoll_pad_i_to_the_igor_mac                (),
				 .mcrs_pad_i_to_the_igor_mac                 (),
				 .md_pad_i_to_the_igor_mac                   (Eth_Mdio),
				 .mrx_clk_pad_i_to_the_igor_mac              (~Eth_Rxc),
				 .mrxd_pad_i_to_the_igor_mac                 (Eth_Rxd[3:0]),
				 .mrxdv_pad_i_to_the_igor_mac                (Eth_RxCtl),
				 .mrxerr_pad_i_to_the_igor_mac               (),
				 .mtx_clk_pad_i_to_the_igor_mac              (igor_clk),
   
				 .md_pad_o_from_the_igor_mac                 (mdio_out_from_the_igor_mac),
				 .md_padoe_o_from_the_igor_mac               (mdio_oen_from_the_igor_mac),
				 .mdc_pad_o_from_the_igor_mac                (Eth_Mdc),
				 .mtxd_pad_o_from_the_igor_mac               (),
				 .mtxen_pad_o_from_the_igor_mac              (),
				 .mtxerr_pad_o_from_the_igor_mac             (),
				 
				 //pio
				 .in_port_to_the_pio_chip_busy               (spi_sclk),
  		
				 //spi
				 .MISO_to_the_spi_0                          (),
				 .MOSI_from_the_spi_0                        (),
				 .SCLK_from_the_spi_0                        (),
				 .SS_n_from_the_spi_0                        (),
  
				 //epcs flash
				 .data0_to_the_epcs_controller               (Flash_Do),
				 .dclk_from_the_epcs_controller              (Flash_Cclk),
				 .sce_from_the_epcs_controller               (Flash_Cs_N),
				 .sdo_from_the_epcs_controller               (Flash_Di),
  
				 //ddr2 ram 
				 .ram_aux_full_rate_clk_out                  (),
				 .ram_aux_half_rate_clk_out                  (Clk_62),
				 .ram_phy_clk_out                            (),

				 .global_reset_n_to_the_ram                  (nRst25),
				 .local_init_done_from_the_ram               (),
				 .local_refresh_ack_from_the_ram             (),
				 .local_wdata_req_from_the_ram               (),
	  	
				 .mem_addr_from_the_ram                      (Ddr2_A),
				 .mem_ba_from_the_ram                        (Ddr2_Ba),
				 .mem_cas_n_from_the_ram                     (Ddr2_Cas_N),
				 .mem_cke_from_the_ram                       (Ddr2_Cke),
				 .mem_clk_n_to_and_from_the_ram              (Ddr2_Clk_N),
				 .mem_clk_to_and_from_the_ram                (Ddr2_Clk_P),
				 .mem_cs_n_from_the_ram                      (Ddr2_Cs_N),  
				 .mem_dm_from_the_ram                        (Ddr2_Dm),
				 .mem_dq_to_and_from_the_ram                 (Ddr2_Dq),
				 .mem_dqs_to_and_from_the_ram                (Ddr2_Dqs),
				 .mem_odt_from_the_ram                       (Ddr2_Odt),
				 .mem_ras_n_from_the_ram                     (Ddr2_Ras_N),
				 .mem_we_n_from_the_ram                      (Ddr2_We_N),
				 .reset_phy_clk_n_from_the_ram               (),
		
				 .clock_vhdl_to_the_tx_table                 (clk_10),
				 .in_Nreset_to_the_tx_table                  (nRst25),
		
				 .info_out_from_the_tx_table                 (),
				 .irq_from_the_tx_table                      (),
				 .info_out_from_the_tx_table                 (),
				 .out_data_from_the_tx_table                 (table_nios_data[7:0]),
				 .out_sync_from_the_tx_table                 (table_nios_sync),
				 .out_valid_from_the_tx_table                (table_nios_valid)
				 );
		
      assign Ddr2_A[13] = 0;
		assign Eth_Txc    = ~igor_clk;
		assign Eth_Rst_N  = ~Rst25;		
		
endmodule