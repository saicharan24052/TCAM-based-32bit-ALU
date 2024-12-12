`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/04/2024 01:53:32 PM
// Design Name: 
// Module Name: adder_8bit_re
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


module adder_8bit_re(
input bit clk,
  input logic write_en,
  input logic [7:0] a, b,c,
  input logic [1:0] data_add [7:0],
  input logic [4:0] data [127:0],
  output logic [9:0] sum, actual_sum,
  output logic [12:0] address
    );
    logic [12:0] address0,address1;
   logic [5:0] sub_sum8_1,sub_actual_sum8_1;
   logic [5:0] sub_sum8_2,sub_actual_sum8_2;
    
    
    adder_4bit_re add8_1(clk,1'b1,a[3:0],b[3:0],4'b0,data_add,data,sub_sum8_1, sub_actual_sum8_1,address0);
    adder_4bit_re add8_2(clk,1'b1,a[7:4],b[7:4],{3'b0,sub_sum8_1[5]},data_add,data,sub_sum8_2, sub_actual_sum8_2,address1);
    
    assign sum = {sub_sum8_2,sub_sum8_1[3:0]};
    
    
    
    
endmodule
