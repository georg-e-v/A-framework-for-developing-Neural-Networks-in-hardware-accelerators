// ==============================================================
// File generated on Tue Jun 02 21:19:38 EEST 2020
// Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
// SW Build 2405991 on Thu Dec  6 23:36:41 MST 2018
// IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// ==============================================================
`timescale 1 ns / 1 ps
(* rom_style = "distributed" *) module conv_layer2_conv_2_weights_V_0_2_rom (
addr0, ce0, q0, clk);

parameter DWIDTH = 4;
parameter AWIDTH = 7;
parameter MEM_SIZE = 96;

input[AWIDTH-1:0] addr0;
input ce0;
output reg[DWIDTH-1:0] q0;
input clk;

(* ram_style = "distributed" *)reg [DWIDTH-1:0] ram[0:MEM_SIZE-1];

initial begin
    $readmemh("./conv_layer2_conv_2_weights_V_0_2_rom.dat", ram);
end



always @(posedge clk)  
begin 
    if (ce0) 
    begin
        q0 <= ram[addr0];
    end
end



endmodule

`timescale 1 ns / 1 ps
module conv_layer2_conv_2_weights_V_0_2(
    reset,
    clk,
    address0,
    ce0,
    q0);

parameter DataWidth = 32'd4;
parameter AddressRange = 32'd96;
parameter AddressWidth = 32'd7;
input reset;
input clk;
input[AddressWidth - 1:0] address0;
input ce0;
output[DataWidth - 1:0] q0;



conv_layer2_conv_2_weights_V_0_2_rom conv_layer2_conv_2_weights_V_0_2_rom_U(
    .clk( clk ),
    .addr0( address0 ),
    .ce0( ce0 ),
    .q0( q0 ));

endmodule

