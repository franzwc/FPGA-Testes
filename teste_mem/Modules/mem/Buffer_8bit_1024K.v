module	Buffer_8bit_1024K(	
										//Host Data
										oDATA,
										iDATA,
										iADDR,
										iWE_N,
										iOE_N,
				                  iCLK,
				                  //SRAM
										Buffer_DQ,
										Buffer_ADDR,
										Buffer_WE_N,
										Buffer_OE_N
								);
//	Host Side
input	   [7:0]	iDATA;
output	[7:0]	oDATA;
input	   [9:0]	iADDR;
input		      iWE_N;
input          iOE_N;
input		      iCLK;
//	SRAM Side
inout 	[7:0]	Buffer_DQ;
output	[9:0]	Buffer_ADDR;
output		   Buffer_WE_N;
output   		Buffer_OE_N;

assign	Buffer_DQ 	=	Buffer_WE_N ? 8'bzzzzzzzz : iDATA;
assign	oDATA		=	Buffer_DQ;
assign	Buffer_ADDR	=	iADDR;
assign	Buffer_WE_N	=	iWE_N;
assign	Buffer_OE_N	=	iOE_N;

endmodule
