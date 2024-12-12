`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 04:27:59 PM
// Design Name: 
// Module Name: adder_16bit_re
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module adder_16bit_re(
input bit clk,
  input logic write_en,
  input logic [15:0] a, b,c,
  input logic [1:0] data_add [7:0],
  input logic [4:0] data [127:0],
  output logic [16:0] sum, actual_sum,
  output logic [12:0] address
    );
  logic [12:0] address0,address1;
      logic [8:0] sub_sum16_1,sub_actual_sum16_1;
      logic [8:0] sub_sum16_2,sub_actual_sum16_2;   
adder_8bit_re add16_1(clk,1'b1,a[7:0],b[7:0],8'b0,data_add,data,sub_sum16_1, sub_actual_sum16_1,address0);
adder_8bit_re add16_2(clk,1'b1,a[15:8],b[15:8],{7'b0,sub_sum16_1[8]},data_add,data,sub_sum16_2, sub_actual_sum16_2,address1);  
    
    
        assign sum = {sub_sum16_2,sub_sum16_1[7:0]};


endmodule
