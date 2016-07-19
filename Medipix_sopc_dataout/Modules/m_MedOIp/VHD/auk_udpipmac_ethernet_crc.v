//--------------------------------------------------------------------------------------------------
// (c)2004 Altera Corporation. All rights reserved.
//
// Altera products are protected under numerous U.S. and foreign patents,
// maskwork rights, copyrights and other intellectual property laws.
//
// This reference design file, and your use thereof, is subject to and governed
// by the terms and conditions of the applicable Altera Reference Design License
// Agreement (either as signed by you or found at www.altera.com).  By using
// this reference design file, you indicate your acceptance of such terms and
// conditions between you and Altera Corporation.  In the event that you do not
// agree with such terms and conditions, you may not use the reference design
// file and please promptly destroy any copies you have made.
//
// This reference design file is being provided on an “as-is” basis and as an
// accommodation and therefore all warranties, representations or guarantees of
// any kind (whether express, implied or statutory) including, without
// limitation, warranties of merchantability, non-infringement, or fitness for
// a particular purpose, are specifically disclaimed.  By making this reference
// design file available, Altera expressly does not recommend, suggest or
// require that this reference design file be used in combination with any
// other product not provided by Altera.
//--------------------------------------------------------------------------------------------------
// File          : $RCSfile: auk_udpipmac_ethernet_crc.v,v $
// Last modified : $Date: 2007/10/30 $
// Author        : JT
//--------------------------------------------------------------------------------------------------
//
// Calculate/check Ethernet FCS
//
// 1 + x1 + x2 + x4 + x5 + x7 + x8 + x10 + x11 + x12 + x16 + x22 + x23 + x26 + x32
//
//--------------------------------------------------------------------------------------------------

//altera message_off 10271
//altera message_off 10270
//altera message_off 10230
//altera message_off 10268

module auk_udpipmac_ethernet_crc (
  input              clk,
  input              rst,
  input        [7:0] din,
  input              din_valid,
  input              clear_crc,
  output reg  [31:0] crc,
  output wire        crc_error
  );

reg [31:0] t_crc;
integer i;
reg feedback;

always @ (posedge clk or posedge rst)
begin
  if (rst) begin
    crc <= 32'hFFFFFFFF;
  end
  else if (clear_crc) begin
    crc <= 32'hFFFFFFFF;
  end
  else if (din_valid) begin

    t_crc = crc;
    for (i=0; i<8; i=i+1) begin
      // 1 + x1 + x2 + x4 + x5 + x7 + x8 + x10 + x11 + x12 + x16 + x22 + x23 + x26 + x32
      feedback = t_crc[31] ^ din[i];
      t_crc[31] = t_crc[30];
      t_crc[30] = t_crc[29];
      t_crc[29] = t_crc[28];
      t_crc[28] = t_crc[27];
      t_crc[27] = t_crc[26];
      t_crc[26] = t_crc[25] ^ feedback;
      t_crc[25] = t_crc[24];
      t_crc[24] = t_crc[23];
      t_crc[23] = t_crc[22] ^ feedback;
      t_crc[22] = t_crc[21] ^ feedback;
      t_crc[21] = t_crc[20];
      t_crc[20] = t_crc[19];
      t_crc[19] = t_crc[18];
      t_crc[18] = t_crc[17];
      t_crc[17] = t_crc[16];
      t_crc[16] = t_crc[15] ^ feedback;
      t_crc[15] = t_crc[14];
      t_crc[14] = t_crc[13];
      t_crc[13] = t_crc[12];
      t_crc[12] = t_crc[11] ^ feedback;
      t_crc[11] = t_crc[10] ^ feedback;
      t_crc[10] = t_crc[9]  ^ feedback;
      t_crc[9]  = t_crc[8];
      t_crc[8]  = t_crc[7]  ^ feedback;
      t_crc[7]  = t_crc[6]  ^ feedback;
      t_crc[6]  = t_crc[5];
      t_crc[5]  = t_crc[4]  ^ feedback;
      t_crc[4]  = t_crc[3]  ^ feedback;
      t_crc[3]  = t_crc[2];
      t_crc[2]  = t_crc[1]  ^ feedback;
      t_crc[1]  = t_crc[0]  ^ feedback;
      t_crc[0]  = feedback;
    end
    crc <= t_crc;

  end
end

assign crc_error = (crc!=32'hc704dd7b);

endmodule


//altera message_on 10271
//altera message_on 10270
//altera message_on 10230
//altera message_on 10268
