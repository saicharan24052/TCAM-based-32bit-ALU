`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2024 09:43:35 PM
// Design Name: 
// Module Name: adder_64bit_re
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

module adder_64bit_re(
input bit clk,
input  logic rst, 
  input logic write_en,
  input logic [63:0] a, b,c,
  input logic [1:0] data_add [7:0],
  input logic [4:0] data [127:0],
  output logic [64:0] sum, actual_sum,
  output logic [12:0] final_flag
    );
logic [12:0] address0, address1, address2, address3, address4, address5, 
                 address6, address7, address8, address9, address10;
logic [4:0] sub_sum_0, sub_actual_sum_0;
logic [4:0] sub_sum_1, sub_actual_sum_1;
  logic [4:0] sub_sum_2, sub_actual_sum_2;
  logic [4:0] sub_sum_3, sub_actual_sum_3;
  logic [4:0] sub_sum_4, sub_actual_sum_4;
  logic [4:0] sub_sum_5, sub_actual_sum_5;
  logic [4:0] sub_sum_6, sub_actual_sum_6;
  logic [4:0] sub_sum_7, sub_actual_sum_7;
  logic [4:0] sub_sum_8, sub_actual_sum_8;
  logic [4:0] sub_sum_9, sub_actual_sum_9;
  logic [4:0] sub_sum_10, sub_actual_sum_10;
  logic [4:0] sub_sum_11, sub_actual_sum_11;
  logic [4:0] sub_sum_12, sub_actual_sum_12;
  logic [4:0] sub_sum_13, sub_actual_sum_13;
  logic [4:0] sub_sum_14, sub_actual_sum_14;
  logic [4:0] sub_sum_15, sub_actual_sum_15;
  logic [4:0] sub_sum_16, sub_actual_sum_16;
  logic [4:0] sub_sum_17, sub_actual_sum_17;
  logic final_flag0,final_flag1,final_flag2,final_flag3,final_flag4,final_flag5,final_flag6,final_flag7,final_flag8,final_flag9;
  logic final_flag10,final_flag11,final_flag12,final_flag13,final_flag14,final_flag15,final_flag16,final_flag17;
  
logic [32:0] sum_temp,sum_temp0,sum_temp1,sum_temp2,sum_temp3,sum_temp4;
    
  adder_4bit_re add32_0(clk, 1'b1, a[3:0],   b[3:0],   3'b0, data_add, data, sub_sum_0, sub_actual_sum_0, final_flag0);
  adder_4bit_re add32_1(clk, 1'b1, a[7:4],   b[7:4],   {2'b0, sub_sum_0[4]}, data_add, data, sub_sum_1, sub_actual_sum_1, final_flag1);
  adder_4bit_re add32_2(clk, 1'b1, a[11:8],  b[11:8],  {2'b0, sub_sum_1[4]}, data_add, data, sub_sum_2, sub_actual_sum_2, final_flag2);
  adder_4bit_re add32_3(clk, 1'b1, a[15:12], b[15:12], {2'b0, sub_sum_2[4]}, data_add, data, sub_sum_3, sub_actual_sum_3, final_flag3);
  adder_4bit_re add32_4(clk, 1'b1, a[19:16], b[19:16], {2'b0, sub_sum_3[4]}, data_add, data, sub_sum_4, sub_actual_sum_4, final_flag4);
  adder_4bit_re add32_5(clk, 1'b1, a[23:20], b[23:20], {2'b0, sub_sum_4[4]}, data_add, data, sub_sum_5, sub_actual_sum_5, final_flag5);
  adder_4bit_re add32_6(clk, 1'b1, a[27:24], b[27:24], {2'b0, sub_sum_5[4]}, data_add, data, sub_sum_6, sub_actual_sum_6, final_flag6);
  adder_4bit_re add32_7(clk, 1'b1, a[31:28], b[31:28], {2'b0, sub_sum_6[4]}, data_add, data, sub_sum_7, sub_actual_sum_7, final_flag7); 
  adder_4bit_re add32_8(clk, 1'b1, a[35:32], b[35:32], {2'b0, sub_sum_7[4]}, data_add, data, sub_sum_8, sub_actual_sum_8, final_flag8);
  adder_4bit_re add32_9(clk, 1'b1, a[39:36], b[39:36], {2'b0, sub_sum_8[4]}, data_add, data, sub_sum_9, sub_actual_sum_9, final_flag9);
  adder_4bit_re add32_10(clk, 1'b1, a[43:40], b[43:40], {2'b0, sub_sum_9[4]}, data_add, data, sub_sum_10, sub_actual_sum_10, final_flag10);
  adder_4bit_re add32_11(clk, 1'b1, a[47:44], b[47:44], {2'b0, sub_sum_10[4]}, data_add, data, sub_sum_11, sub_actual_sum_11, final_flag11);
  adder_4bit_re add32_12(clk, 1'b1, a[51:48], b[51:48], {2'b0, sub_sum_11[4]}, data_add, data, sub_sum_12, sub_actual_sum_12, final_flag12);
  adder_4bit_re add32_13(clk, 1'b1, a[55:52], b[55:52], {2'b0, sub_sum_12[4]}, data_add, data, sub_sum_13, sub_actual_sum_13, final_flag13);
  adder_4bit_re add32_14(clk, 1'b1, a[59:56], b[59:56], {2'b0, sub_sum_13[4]}, data_add, data, sub_sum_14, sub_actual_sum_14, final_flag14);
  adder_4bit_re add32_15(clk, 1'b1, a[63:60], b[63:60], {2'b0, sub_sum_14[4]}, data_add, data, sub_sum_15, sub_actual_sum_15, final_flag15);

    

assign final_flag = final_flag7;
always_comb begin
 sum_temp =a+b+c;

end

assign sum = {sub_sum_15, sub_sum_14[3:0], 
              sub_sum_13[3:0], sub_sum_12[3:0], sub_sum_11[3:0], sub_sum_10[3:0], 
              sub_sum_9[3:0], sub_sum_8[3:0], sub_sum_7[3:0], sub_sum_6[3:0], 
              sub_sum_5[3:0], sub_sum_4[3:0], sub_sum_3[3:0], sub_sum_2[3:0], 
              sub_sum_1[3:0], sub_sum_0[3:0]};

/*
  ff sai0(clk,rst,sum_temp,sum_temp0);
   ff sai1(clk,rst,sum_temp0,sum_temp1);
     ff sai2(clk,rst,sum_temp1,sum_temp2);
       ff sai3(clk,rst,sum_temp2,sum_temp3); 
      //   ff sai4(clk,rst,sum_temp3,sum_temp4);

 always_comb begin
actual_sum =sum_temp3;
  
 end

assign sum = {sub_sum_7,sub_sum_6[3:0], sub_sum_5[3:0], sub_sum_4[3:0], sub_sum_3[3:0],sub_sum_2[3:0], sub_sum_1[3:0], sub_sum_0[3:0]};
*/
endmodule

