  //Example instantiation for system 'Medipix_sopc'
  Medipix_sopc Medipix_sopc_inst
    (
      .Buffer_ADDR_from_the_Buffer_8bit_1024K_0      (Buffer_ADDR_from_the_Buffer_8bit_1024K_0),
      .Buffer_DQ_to_and_from_the_Buffer_8bit_1024K_0 (Buffer_DQ_to_and_from_the_Buffer_8bit_1024K_0),
      .Buffer_OE_N_from_the_Buffer_8bit_1024K_0      (Buffer_OE_N_from_the_Buffer_8bit_1024K_0),
      .Buffer_WE_N_from_the_Buffer_8bit_1024K_0      (Buffer_WE_N_from_the_Buffer_8bit_1024K_0),
      .MISO_to_the_spi_0                             (MISO_to_the_spi_0),
      .MOSI_from_the_spi_0                           (MOSI_from_the_spi_0),
      .SCLK_from_the_spi_0                           (SCLK_from_the_spi_0),
      .SS_n_from_the_spi_0                           (SS_n_from_the_spi_0),
      .clk_125                                       (clk_125),
      .clock_vhdl_to_the_tx_table                    (clock_vhdl_to_the_tx_table),
      .data0_to_the_epcs_controller                  (data0_to_the_epcs_controller),
      .dclk_from_the_epcs_controller                 (dclk_from_the_epcs_controller),
      .global_reset_n_to_the_ram                     (global_reset_n_to_the_ram),
      .in_Nreset_to_the_tx_table                     (in_Nreset_to_the_tx_table),
      .info_out_from_the_tx_table                    (info_out_from_the_tx_table),
      .irq_from_the_tx_table                         (irq_from_the_tx_table),
      .local_init_done_from_the_ram                  (local_init_done_from_the_ram),
      .local_refresh_ack_from_the_ram                (local_refresh_ack_from_the_ram),
      .local_wdata_req_from_the_ram                  (local_wdata_req_from_the_ram),
      .mcoll_pad_i_to_the_igor_mac                   (mcoll_pad_i_to_the_igor_mac),
      .mcrs_pad_i_to_the_igor_mac                    (mcrs_pad_i_to_the_igor_mac),
      .md_pad_i_to_the_igor_mac                      (md_pad_i_to_the_igor_mac),
      .md_pad_o_from_the_igor_mac                    (md_pad_o_from_the_igor_mac),
      .md_padoe_o_from_the_igor_mac                  (md_padoe_o_from_the_igor_mac),
      .mdc_pad_o_from_the_igor_mac                   (mdc_pad_o_from_the_igor_mac),
      .mem_addr_from_the_ram                         (mem_addr_from_the_ram),
      .mem_ba_from_the_ram                           (mem_ba_from_the_ram),
      .mem_cas_n_from_the_ram                        (mem_cas_n_from_the_ram),
      .mem_cke_from_the_ram                          (mem_cke_from_the_ram),
      .mem_clk_n_to_and_from_the_ram                 (mem_clk_n_to_and_from_the_ram),
      .mem_clk_to_and_from_the_ram                   (mem_clk_to_and_from_the_ram),
      .mem_cs_n_from_the_ram                         (mem_cs_n_from_the_ram),
      .mem_dm_from_the_ram                           (mem_dm_from_the_ram),
      .mem_dq_to_and_from_the_ram                    (mem_dq_to_and_from_the_ram),
      .mem_dqs_to_and_from_the_ram                   (mem_dqs_to_and_from_the_ram),
      .mem_odt_from_the_ram                          (mem_odt_from_the_ram),
      .mem_ras_n_from_the_ram                        (mem_ras_n_from_the_ram),
      .mem_we_n_from_the_ram                         (mem_we_n_from_the_ram),
      .mrx_clk_pad_i_to_the_igor_mac                 (mrx_clk_pad_i_to_the_igor_mac),
      .mrxd_pad_i_to_the_igor_mac                    (mrxd_pad_i_to_the_igor_mac),
      .mrxdv_pad_i_to_the_igor_mac                   (mrxdv_pad_i_to_the_igor_mac),
      .mrxerr_pad_i_to_the_igor_mac                  (mrxerr_pad_i_to_the_igor_mac),
      .mtx_clk_pad_i_to_the_igor_mac                 (mtx_clk_pad_i_to_the_igor_mac),
      .mtxd_pad_o_from_the_igor_mac                  (mtxd_pad_o_from_the_igor_mac),
      .mtxen_pad_o_from_the_igor_mac                 (mtxen_pad_o_from_the_igor_mac),
      .mtxerr_pad_o_from_the_igor_mac                (mtxerr_pad_o_from_the_igor_mac),
      .out_data_from_the_tx_table                    (out_data_from_the_tx_table),
      .out_sync_from_the_tx_table                    (out_sync_from_the_tx_table),
      .out_valid_from_the_tx_table                   (out_valid_from_the_tx_table),
      .ram_aux_full_rate_clk_out                     (ram_aux_full_rate_clk_out),
      .ram_aux_half_rate_clk_out                     (ram_aux_half_rate_clk_out),
      .ram_phy_clk_out                               (ram_phy_clk_out),
      .reset_n                                       (reset_n),
      .reset_phy_clk_n_from_the_ram                  (reset_phy_clk_n_from_the_ram),
      .rxd_to_the_uart_0                             (rxd_to_the_uart_0),
      .sce_from_the_epcs_controller                  (sce_from_the_epcs_controller),
      .sdo_from_the_epcs_controller                  (sdo_from_the_epcs_controller),
      .txd_from_the_uart_0                           (txd_from_the_uart_0)
    );

