/* Verilog HDL FILE
--{{{ HEADER
--!@file
--------------------------------------------------------------------------------
--!@brief TOP Asi Mode
--------------------------------------------------------------------------------                                                                      
--! DESCRIPTION:
--!
--! modo da saida ASI pacote ou byte
--!
--! DETAILS:      
--!
--!- Project Name: Top_ASIOutMode.v                       
--!- Module Name: Top_ASIOutMode
--!- Tools: Quartus II 10.0  
--!- Author: Franz Wagner
--!- Company: HK LINEAR
--!- Create Date: 18/06/2013     
--!- Version: 1.0.0 (Jul/2013)  
--------------------------------------------------------------------------------
-- HKLINEAR - 2013
--------------------------------------------------------------------------------
--}}} Header*/


module Top_ASIOutMode (

      //entradas
		input               i_Clk4Mhz,
		input               i_nRst4Mhz,

		input   [7:0]       i_Data,		
		input               i_Valid,
		input               i_Sync,
		
		input               i_Clk27Mhz,
		input               i_nRst27Mhz,
		
		input               i_AsiMode,
		input               i_BtsComp,
		input               i_ReqAlteraModo,

		//saidas
      output  [7:0]       o_Data,
		output              o_Sync,
		output              o_ValidOut,
		output  [7:0]       o_ContaByte,
		output              o_AsiMode

);

   //--------------------------------------------------------------------------------------------
	// tamanho do pacote
	//--------------------------------------------------------------------------------------------
	reg    [7:0]     w_PacketLengthAsiMode;
	reg              w_BtsComp=0;
	reg              w_BtsCompAnt=1;
	reg              w_nreset;
	
   always@(posedge i_Clk27Mhz)
   begin
	// Statements
	        w_BtsComp<=i_BtsComp;
			  
			  if (w_BtsComp==w_BtsCompAnt)
			  begin
			  
			      w_nreset<=1;
					w_BtsCompAnt<=w_BtsComp;
					
			  end
			  else
			  
			      if  (w_BtsComp == 0) 
					begin
								w_PacketLengthAsiMode<=8'd204;
								w_nreset<=0;
								w_BtsCompAnt<=w_BtsComp;
					end
					else  
					begin
								w_PacketLengthAsiMode<=8'd188;
								w_nreset<=0;
								w_BtsCompAnt<=w_BtsComp;
					end
			  begin
			  
			  end
			  
   end
	
   //--------------------------------------------------------------------------------------------
	// Reset
	//--------------------------------------------------------------------------------------------
	wire             w_CtrlRdAsiMode_ValidOut;
	wire             w_Enable;
	
	if (i_AsiMode==1)
	begin
	   //o_ValidOut<=w_CtrlRdAsiMode_ValidOut;
	end
//	else
//	begin
//	   o_ValidOut<=w_Enable;
//	end
	
	//parameter WIDTH = 1;
	
//   busmux u_busmux(
//	
//	         .dataa                                    (w_CtrlRdAsiMode_ValidOut),
//				.datab                                    (w_Enable),
//				.sel                                      (i_AsiMode),
//				
//				.result                                   (o_ValidOut)
//	         
//				);
	
   //--------------------------------------------------------------------------------------------
	// Escrita na Fifo
	//--------------------------------------------------------------------------------------------
	wire   [7:0]     w_CtrlWrAsiMode_data;
	wire             w_CtrlWrAsiMode_valid;
	wire             w_CtrlWrAsiMode_sync;
	
	CtrlWrAsiMode u_CtrlWrAsiMode(

         	.i_Clk                                    (i_Clk4Mhz),
				.i_nRst                                   ((i_nRst4Mhz&w_nreset)),
            .i_Valid                                  (i_Valid),
				.i_Sync                                   (i_Sync),
				.i_Data                                   (i_Data[7:0]),
				.i_PacketLength                           (w_PacketLengthAsiMode),
				
            .o_Data                                   (w_CtrlWrAsiMode_data[7:0]),
				.o_Valid                                  (w_CtrlWrAsiMode_valid),
				.o_Sync                                   (w_CtrlWrAsiMode_sync)
				
            );
						
	//--------------------------------------------------------------------------------------------
	// Fifo
	//--------------------------------------------------------------------------------------------
	wire   [8:0]     w_IP_fifo_512B_WrUsed;
	wire   [8:0]     w_IP_fifo_512B_RdUsed;
	wire             w_CtrlRdAsiMode_EnableRd;
	wire             w_IP_fifo_512B_RdEmpty;
	
	IP_FifoAsiMode u_IP_FifoAsiMode(

         	.data                                     (w_CtrlWrAsiMode_data[7:0]),
            .wrreq                                    (w_CtrlWrAsiMode_valid),
				.wrclk                                    (i_Clk4Mhz),
				.rdreq                                    (w_CtrlRdAsiMode_EnableRd),
	         .rdclk                                    (i_Clk27Mhz),
	         .aclr                                     (~(i_nRst27Mhz&w_nreset)),
				
				.wrfull                                   (),
				.wrusedw                                  (w_IP_fifo_512B_WrUsed[8:0]),
				.q                                        (o_Data[7:0]),
				.rdempty                                  (w_IP_fifo_512B_RdEmpty),
				.rdusedw                                  (w_IP_fifo_512B_RdUsed[8:0])
				
            );
				
	//--------------------------------------------------------------------------------------------
	// Leitura da Fifo
	//--------------------------------------------------------------------------------------------
	wire             w_GeraEnAsiMode_Enable;
			
	CtrlRdAsiMode u_CtrlRdAsiMode(

         	.i_Clk                                    (i_Clk27Mhz),
            .i_nRst                                   ((i_nRst27Mhz&w_nreset)),
				.i_NivelRdFifo                            (w_IP_fifo_512B_RdUsed[8:0]),
				.i_ModoLeitura                            (i_AsiMode),
				.i_PacketLength                           (w_PacketLengthAsiMode),
	         .i_ReqAlteraModo                          (i_ReqAlteraModo),
	         .i_FifoEmpty                              (w_IP_fifo_512B_RdEmpty),
	         .i_EnableRd                               (w_GeraEnAsiMode_Enable),
				
				.o_EnableRd                               (w_CtrlRdAsiMode_EnableRd),
				.o_ValidOut                               (w_CtrlRdAsiMode_ValidOut),
				.o_Sync                                   (o_Sync),
				.o_ContaByte                              (o_ContaByte[7:0]),
				.o_ModoAsi                                (o_AsiMode),
				.o_en                                     (w_Enable)
				
            );
				
	//--------------------------------------------------------------------------------------------
	// Gera Enable
	//--------------------------------------------------------------------------------------------
	GeraEnAsiMode u_GeraEnAsiMode(

         	.i_Clk                                    (i_Clk27Mhz),
            .i_nRst                                   ((i_nRst27Mhz|w_nreset)),
				.i_Amostrar                               (i_Clk4Mhz),
				
				.o_ValidAmostrado                         (w_GeraEnAsiMode_Enable)
				
            );
	

endmodule 
