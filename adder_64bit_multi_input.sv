`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2024 11:28:18 AM
// Design Name: 
// Module Name: adder_mul_64bit_re
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


module adder_4bit_re(
input bit clk,
  input logic write_en,
  input logic [3:0] a, b, c,
  input logic [2:0] data_add [63:0],
  input logic [4:0] data_unq [127:0],
  output logic [5:0] sum, actual_sum,
  output logic [12:0] address

    );
    
 logic [4:0] cam_mem [127:0]; // CAM cell 
  logic [2:0] cam_mem_add [63:0]; // CAM cell 
      logic match_flag_0, match_flag_1, match_flag_2, match_flag_3,match_flag_4;
      logic match_flag_carry_1, match_flag_carry_2, match_flag_carry_3,match_flag_carry_4;
      logic data_flag,data_flag_1, sum_flag; 
      int i,i1, j, k, l, m, n, o, p, q, r;
      int addr_0, addr_1, addr_2, addr_3, pp1;
      logic [5:0] sum_reg;
      logic [5:0] late_0,late_1,late_2;
      
      
      /////////   writing data into cam_mem ///////////////////////
       always_ff @(posedge clk) begin 
         if (write_en) begin
           for (i = 0; i < 128; i++) begin
             cam_mem[i] = data_unq[i];
            
           end
           data_flag = 1'b1;
         end 
       end
       
             always_ff @(posedge clk) begin 
         if (write_en) begin
           for (i1 = 0; i1 < 8; i1++) begin
             cam_mem_add[i1] = data_add[i1];
            
           end
           data_flag_1 = 1'b1;
         end 
       end 
       
     //////  end    //////////////////////////////////  
     
     
     
 ///////////////  stage 1   /////////////////////    
     always_ff @(posedge clk) begin 
         if (data_flag) begin 
           match_flag_0 = 1'b0;
           addr_0 = 3'b0;
           
           for (j = 0; j < 8; j++ ) begin  
             if ({a[0], b[0], c[0]} == j[2:0]) begin
               match_flag_0 = 1'b1;
               addr_0 = j[2:0];
               break; // exit the loop once a match is found
             end
           end
         end 
       end       
         
       always_ff @(posedge clk) begin 
         if (data_flag) begin 
           match_flag_1 = 1'b0;
           addr_1 = 3'b0;
           
           for (k = 0; k < 8; k++ ) begin  
             if ({a[1], b[1], c[1]} == k[2:0]) begin
               match_flag_1 = 1'b1;
               addr_1 = k[2:0];
               break; // exit the loop once a match is found
             end
           end
         end 
       end       
     
       always_ff @(posedge clk) begin 
         if (data_flag) begin 
           match_flag_2 = 1'b0;
           addr_2 = 3'b0;
           
           for (l = 0; l < 8; l++ ) begin  
             if ({a[2], b[2], c[2]} == l[2:0]) begin
               match_flag_2 = 1'b1;
               addr_2 = l[2:0];
               break; // exit the loop once a match is found
             end
           end
         end 
       end   
       
       always_ff @(posedge clk) begin 
         if (data_flag) begin 
           match_flag_3 = 1'b0;
           addr_3 = 3'b0;
           
           for (m = 0; m < 8; m++ ) begin  
             if ({a[3], b[3], c[3]} == m[2:0]) begin
               match_flag_3 = 1'b1;
               addr_3 = m[2:0];
               break; // exit the loop once a match is found
             end
           end
         end 
       end   
       
  ///////////////  end  of  stage 1   /////////////////////          
  
  
  always_comb begin
    sum_flag = 1'b0;
    if (match_flag_0 && match_flag_1 && match_flag_2 && match_flag_3) begin
      sum_flag = 1'b1;
    end
  end
  
  
  ///////////////  stage 2   /////////////////////        
  
    always_ff @(posedge clk) begin 
    if (sum_flag) begin 
      match_flag_carry_1 = 1'b0;
      match_flag_carry_2 = 1'b0;
      match_flag_carry_3 = 1'b0;
      match_flag_carry_4 = 1'b0;
      pp1 = 3'b0;
      
     if( {cam_mem_add[addr_3][0], cam_mem_add[addr_2][0]} == 2'b00) begin
          for (n = 0; n < 32; n = n + 1) begin  
              if ({cam_mem_add[addr_1][0], cam_mem_add[addr_3][1], cam_mem_add[addr_2][1], cam_mem_add[addr_1][1], cam_mem_add[addr_0][1]} ==  n[4:0]) begin
                  match_flag_carry_1 = 1'b1;
                  pp1 = {2'b00, n[4:0]};
                  break; // exit the loop once a match is found
              end
          end
      end
      
      if( {cam_mem_add[addr_3][0], cam_mem_add[addr_2][0]} == 2'b01) begin
          for (o = 0; o < 32; o = o + 1) begin  
              if ({cam_mem_add[addr_1][0], cam_mem_add[addr_3][1], cam_mem_add[addr_2][1], cam_mem_add[addr_1][1], cam_mem_add[addr_0][1]} ==  o[4:0]) begin
                  match_flag_carry_2 = 1'b1;
                  pp1 = {2'b01, o[4:0]};
                  break; // exit the loop once a match is found
              end
          end
      end
      
      if( {cam_mem_add[addr_3][0], cam_mem_add[addr_2][0]} == 2'b10) begin
          for (p = 0; p < 32; p = p + 1) begin  
              if ({cam_mem_add[addr_1][0], cam_mem_add[addr_3][1], cam_mem_add[addr_2][1], cam_mem_add[addr_1][1], cam_mem_add[addr_0][1]} ==  p[4:0]) begin
                  match_flag_carry_3 = 1'b1;
                  pp1 = {2'b10, p[4:0]};
                  break; // exit the loop once a match is found
              end
          end
      end
      
      if( {cam_mem_add[addr_3][0], cam_mem_add[addr_2][0]} == 2'b11) begin
          for (q = 0; q < 32; q = q + 1) begin  
              if ({cam_mem_add[addr_1][0], cam_mem_add[addr_3][1], cam_mem_add[addr_2][1], cam_mem_add[addr_1][1], cam_mem_add[addr_0][1]} ==  q[4:0]) begin
                  match_flag_carry_4 = 1'b1;
                  pp1 = {2'b11, q[4:0]};
                  break; // exit the loop once a match is found
              end
          end
      end
    

  end 
 end
 

  
  assign actual_sum = a+b+c;
  assign sum = {cam_mem[pp1],cam_mem_add[addr_0][0] };
         
endmodule

module adder_64bit_re(
input bit clk,
input  logic rst, 
  input logic write_en,
  input logic [63:0] a, b,c,
  input logic [2:0] data_add [63:0],
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
    
  adder_4bit_re add32_0(clk, 1'b1, a[3:0],   b[3:0],   4'b0, data_add, data, sub_sum_0, sub_actual_sum_0, final_flag0);
adder_4bit_re add32_1(clk, 1'b1, a[7:4],   b[7:4],   {3'b0, sub_sum_0[4]}, data_add, data, sub_sum_1, sub_actual_sum_1, final_flag1);
adder_4bit_re add32_2(clk, 1'b1, a[11:8],  b[11:8],  {3'b0, sub_sum_1[4]}, data_add, data, sub_sum_2, sub_actual_sum_2, final_flag2);
adder_4bit_re add32_3(clk, 1'b1, a[15:12], b[15:12], {3'b0, sub_sum_2[4]}, data_add, data, sub_sum_3, sub_actual_sum_3, final_flag3);
adder_4bit_re add32_4(clk, 1'b1, a[19:16], b[19:16], {3'b0, sub_sum_3[4]}, data_add, data, sub_sum_4, sub_actual_sum_4, final_flag4);
adder_4bit_re add32_5(clk, 1'b1, a[23:20], b[23:20], {3'b0, sub_sum_4[4]}, data_add, data, sub_sum_5, sub_actual_sum_5, final_flag5);
adder_4bit_re add32_6(clk, 1'b1, a[27:24], b[27:24], {3'b0, sub_sum_5[4]}, data_add, data, sub_sum_6, sub_actual_sum_6, final_flag6);
adder_4bit_re add32_7(clk, 1'b1, a[31:28], b[31:28], {3'b0, sub_sum_6[4]}, data_add, data, sub_sum_7, sub_actual_sum_7, final_flag7); 
adder_4bit_re add32_8(clk, 1'b1, a[35:32], b[35:32], {3'b0, sub_sum_7[4]}, data_add, data, sub_sum_8, sub_actual_sum_8, final_flag8);
adder_4bit_re add32_9(clk, 1'b1, a[39:36], b[39:36], {3'b0, sub_sum_8[4]}, data_add, data, sub_sum_9, sub_actual_sum_9, final_flag9);
adder_4bit_re add32_10(clk, 1'b1, a[43:40], b[43:40], {3'b0, sub_sum_9[4]}, data_add, data, sub_sum_10, sub_actual_sum_10, final_flag10);
adder_4bit_re add32_11(clk, 1'b1, a[47:44], b[47:44], {3'b0, sub_sum_10[4]}, data_add, data, sub_sum_11, sub_actual_sum_11, final_flag11);
adder_4bit_re add32_12(clk, 1'b1, a[51:48], b[51:48], {3'b0, sub_sum_11[4]}, data_add, data, sub_sum_12, sub_actual_sum_12, final_flag12);
adder_4bit_re add32_13(clk, 1'b1, a[55:52], b[55:52], {3'b0, sub_sum_12[4]}, data_add, data, sub_sum_13, sub_actual_sum_13, final_flag13);
adder_4bit_re add32_14(clk, 1'b1, a[59:56], b[59:56], {3'b0, sub_sum_13[4]}, data_add, data, sub_sum_14, sub_actual_sum_14, final_flag14);
adder_4bit_re add32_15(clk, 1'b1, a[63:60], b[63:60], {3'b0, sub_sum_14[4]}, data_add, data, sub_sum_15, sub_actual_sum_15, final_flag15);

    
assign actual_sum = a+b;
assign final_flag = final_flag7;
always_comb begin
 sum_temp =a+b+c;

end

assign sum = { sub_sum_15, sub_sum_14[3:0], 
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


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module adder_68bit_re(
input bit clk,
input  logic rst, 
  input logic write_en,
  input logic [67:0] a, b,c,
  input logic [2:0] data_add [63:0],
  input logic [4:0] data [127:0],
  output logic [68:0] sum, actual_sum,
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
    
  adder_4bit_re add32_0(clk, 1'b1, a[3:0],   b[3:0],   4'b0, data_add, data, sub_sum_0, sub_actual_sum_0, final_flag0);
adder_4bit_re add32_1(clk, 1'b1, a[7:4],   b[7:4],   {3'b0, sub_sum_0[4]}, data_add, data, sub_sum_1, sub_actual_sum_1, final_flag1);
adder_4bit_re add32_2(clk, 1'b1, a[11:8],  b[11:8],  {3'b0, sub_sum_1[4]}, data_add, data, sub_sum_2, sub_actual_sum_2, final_flag2);
adder_4bit_re add32_3(clk, 1'b1, a[15:12], b[15:12], {3'b0, sub_sum_2[4]}, data_add, data, sub_sum_3, sub_actual_sum_3, final_flag3);
adder_4bit_re add32_4(clk, 1'b1, a[19:16], b[19:16], {3'b0, sub_sum_3[4]}, data_add, data, sub_sum_4, sub_actual_sum_4, final_flag4);
adder_4bit_re add32_5(clk, 1'b1, a[23:20], b[23:20], {3'b0, sub_sum_4[4]}, data_add, data, sub_sum_5, sub_actual_sum_5, final_flag5);
adder_4bit_re add32_6(clk, 1'b1, a[27:24], b[27:24], {3'b0, sub_sum_5[4]}, data_add, data, sub_sum_6, sub_actual_sum_6, final_flag6);
adder_4bit_re add32_7(clk, 1'b1, a[31:28], b[31:28], {3'b0, sub_sum_6[4]}, data_add, data, sub_sum_7, sub_actual_sum_7, final_flag7); 
adder_4bit_re add32_8(clk, 1'b1, a[35:32], b[35:32], {3'b0, sub_sum_7[4]}, data_add, data, sub_sum_8, sub_actual_sum_8, final_flag8);
adder_4bit_re add32_9(clk, 1'b1, a[39:36], b[39:36], {3'b0, sub_sum_8[4]}, data_add, data, sub_sum_9, sub_actual_sum_9, final_flag9);
adder_4bit_re add32_10(clk, 1'b1, a[43:40], b[43:40], {3'b0, sub_sum_9[4]}, data_add, data, sub_sum_10, sub_actual_sum_10, final_flag10);
adder_4bit_re add32_11(clk, 1'b1, a[47:44], b[47:44], {3'b0, sub_sum_10[4]}, data_add, data, sub_sum_11, sub_actual_sum_11, final_flag11);
adder_4bit_re add32_12(clk, 1'b1, a[51:48], b[51:48], {3'b0, sub_sum_11[4]}, data_add, data, sub_sum_12, sub_actual_sum_12, final_flag12);
adder_4bit_re add32_13(clk, 1'b1, a[55:52], b[55:52], {3'b0, sub_sum_12[4]}, data_add, data, sub_sum_13, sub_actual_sum_13, final_flag13);
adder_4bit_re add32_14(clk, 1'b1, a[59:56], b[59:56], {3'b0, sub_sum_13[4]}, data_add, data, sub_sum_14, sub_actual_sum_14, final_flag14);
adder_4bit_re add32_15(clk, 1'b1, a[63:60], b[63:60], {3'b0, sub_sum_14[4]}, data_add, data, sub_sum_15, sub_actual_sum_15, final_flag15);
adder_4bit_re add32_16(clk, 1'b1, a[67:64], b[67:64], {3'b0, sub_sum_15[4]}, data_add, data, sub_sum_16, sub_actual_sum_16, final_flag16);

    
assign actual_sum = a+b;
assign final_flag = final_flag7;
always_comb begin
 sum_temp =a+b+c;

end

assign sum = { sub_sum_16, sub_sum_15[3:0], sub_sum_14[3:0], 
              sub_sum_13[3:0], sub_sum_12[3:0], sub_sum_11[3:0], sub_sum_10[3:0], 
              sub_sum_9[3:0], sub_sum_8[3:0], sub_sum_7[3:0], sub_sum_6[3:0], 
              sub_sum_5[3:0], sub_sum_4[3:0], sub_sum_3[3:0], sub_sum_2[3:0], 
              sub_sum_1[3:0], sub_sum_0[3:0]};


endmodule

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module adder_72bit_re(
input bit clk,
input  logic rst, 
  input logic write_en,
  input logic [71:0] a, b,c,
  input logic [2:0] data_add [63:0],
  input logic [4:0] data [127:0],
  output logic [72:0] sum, actual_sum,
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
    
  adder_4bit_re add32_0(clk, 1'b1, a[3:0],   b[3:0],   4'b0, data_add, data, sub_sum_0, sub_actual_sum_0, final_flag0);
  adder_4bit_re add32_1(clk, 1'b1, a[7:4],   b[7:4],   {3'b0, sub_sum_0[4]}, data_add, data, sub_sum_1, sub_actual_sum_1, final_flag1);
  adder_4bit_re add32_2(clk, 1'b1, a[11:8],  b[11:8],  {3'b0, sub_sum_1[4]}, data_add, data, sub_sum_2, sub_actual_sum_2, final_flag2);
  adder_4bit_re add32_3(clk, 1'b1, a[15:12], b[15:12], {3'b0, sub_sum_2[4]}, data_add, data, sub_sum_3, sub_actual_sum_3, final_flag3);
  adder_4bit_re add32_4(clk, 1'b1, a[19:16], b[19:16], {3'b0, sub_sum_3[4]}, data_add, data, sub_sum_4, sub_actual_sum_4, final_flag4);
  adder_4bit_re add32_5(clk, 1'b1, a[23:20], b[23:20], {3'b0, sub_sum_4[4]}, data_add, data, sub_sum_5, sub_actual_sum_5, final_flag5);
  adder_4bit_re add32_6(clk, 1'b1, a[27:24], b[27:24], {3'b0, sub_sum_5[4]}, data_add, data, sub_sum_6, sub_actual_sum_6, final_flag6);
  adder_4bit_re add32_7(clk, 1'b1, a[31:28], b[31:28], {3'b0, sub_sum_6[4]}, data_add, data, sub_sum_7, sub_actual_sum_7, final_flag7); 
  adder_4bit_re add32_8(clk, 1'b1, a[35:32], b[35:32], {3'b0, sub_sum_7[4]}, data_add, data, sub_sum_8, sub_actual_sum_8, final_flag8);
  adder_4bit_re add32_9(clk, 1'b1, a[39:36], b[39:36], {3'b0, sub_sum_8[4]}, data_add, data, sub_sum_9, sub_actual_sum_9, final_flag9);
  adder_4bit_re add32_10(clk, 1'b1, a[43:40], b[43:40], {3'b0, sub_sum_9[4]}, data_add, data, sub_sum_10, sub_actual_sum_10, final_flag10);
  adder_4bit_re add32_11(clk, 1'b1, a[47:44], b[47:44], {3'b0, sub_sum_10[4]}, data_add, data, sub_sum_11, sub_actual_sum_11, final_flag11);
  adder_4bit_re add32_12(clk, 1'b1, a[51:48], b[51:48], {3'b0, sub_sum_11[4]}, data_add, data, sub_sum_12, sub_actual_sum_12, final_flag12);
  adder_4bit_re add32_13(clk, 1'b1, a[55:52], b[55:52], {3'b0, sub_sum_12[4]}, data_add, data, sub_sum_13, sub_actual_sum_13, final_flag13);
  adder_4bit_re add32_14(clk, 1'b1, a[59:56], b[59:56], {3'b0, sub_sum_13[4]}, data_add, data, sub_sum_14, sub_actual_sum_14, final_flag14);
  adder_4bit_re add32_15(clk, 1'b1, a[63:60], b[63:60], {3'b0, sub_sum_14[4]}, data_add, data, sub_sum_15, sub_actual_sum_15, final_flag15);
  adder_4bit_re add32_16(clk, 1'b1, a[67:64], b[67:64], {3'b0, sub_sum_15[4]}, data_add, data, sub_sum_16, sub_actual_sum_16, final_flag16);
  adder_4bit_re add32_17(clk, 1'b1, a[71:68], b[71:68], {3'b0, sub_sum_16[4]}, data_add, data, sub_sum_17, sub_actual_sum_17, final_flag17);


    
assign actual_sum = a+b;
assign final_flag = final_flag7;
always_comb begin
 sum_temp =a+b+c;

end

assign sum = { sub_sum_17,sub_sum_16[3:0], sub_sum_15[3:0], sub_sum_14[3:0], 
              sub_sum_13[3:0], sub_sum_12[3:0], sub_sum_11[3:0], sub_sum_10[3:0], 
              sub_sum_9[3:0], sub_sum_8[3:0], sub_sum_7[3:0], sub_sum_6[3:0], 
              sub_sum_5[3:0], sub_sum_4[3:0], sub_sum_3[3:0], sub_sum_2[3:0], 
              sub_sum_1[3:0], sub_sum_0[3:0]};


endmodule











///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// count ones in coloum of 7 length
//seems no chnages requried || change in data
module count_ones_sub(
input logic a,b,c,d,e,f,
input logic [2:0] data [63:0],
output logic [2:0] sub_out // 3 bit output 1+1+1+1+1+1= 110
    );

  logic [2:0] sub_out0,sub_out1,sub_out2; // 3 bit output 1+1+1+1 = 100
  logic out0_flag,out1_flag,out2_flag;
  logic [2:0] add [63:0];
  int j,k,l,u;
  logic [3:0] sub_sum;
  logic data_flag;
  logic [3:0] sub_out_actual;
  assign sub_out_actual = a+b+c+d+e+f;
  
  
    always_comb begin 
    for (u = 0; u< 64; u++) begin
      add[u] = data[u];  // Only assign the lower 2 bits to `add`
    end
    data_flag = 1'b1;
  end

always_comb begin 
sub_out0 = 2'b0;
out0_flag = 1'b0;
if (data_flag) begin
  for(l=0; l<64;l++) begin
    if({a,b,c,d,e,f} == l[5:0]) begin
      sub_out0 = add[l[5:0]]; // add[111111]
      out0_flag = 1'b1;
  break;
end
end
end
end

assign sub_out = sub_out0;

endmodule


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//8 cycles
module count_mul_v2(
input logic p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31,
input logic [2:0] data [63:0],
input logic [4:0] data_unq [127:0],
input logic clk,
output logic [5:0] out //7 bit output becaus 32 x1  = 32 
    );
    
  logic [2:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10,out11,out12; // adding 5 single bits  = 3 bit output
  logic out0_flag, out1_flag, out2_flag, out3_flag, out4_flag, out5_flag, out6_flag, out7_flag, out8_flag, out9_flag, out10_flag,out11_flag,out12_flag;
  logic [2:0] add [63:0];
  int loop_0, loop_1, loop_2, loop_3, loop_4, loop_5, loop_6, loop_7, loop_8, loop_9, loop_10,loop_11,loop_12,loop_data,loop_data1;
  logic [5:0] sum;
  logic [5:0] actual_sum_v2;
  logic [2:0] sum0,sum1,sum2;
  logic data_flag,data_flag1;

   logic [12:0] address_v2;
   logic  [4:0] cam_mem_unq [127:0]; // CAM cell 
  
  
  
   always_ff @(posedge clk) begin 
    for (loop_data = 0; loop_data< 64; loop_data++) begin
      add[loop_data] = data[loop_data];  // Only assign the lower 2 bits to `add`
    end
    data_flag1 = 1'b1;
  end
    
   always_ff @(posedge clk) begin 
    for (loop_data1 = 0; loop_data1< 128; loop_data1++) begin
      cam_mem_unq[loop_data1] = data_unq[loop_data1];  // Only assign the lower 2 bits to `add`
    end
    data_flag = 1'b1;
  end

  

 always_ff @(posedge clk) begin
  out0 = 3'b0;
    out0_flag = 1'b0;
    if (data_flag) begin
     for(loop_0=0; loop_0<64;loop_0++) begin
        if({p0,p1,p2,p3,p4,p5} == loop_0[5:0]) begin
     out0 = add[loop_0[5:0]];
      out0_flag = 1'b1;
      break;
    end
  end
  end
end
 always_ff @(posedge clk) begin
  out1 = 3'b0;
    out1_flag = 1'b0;
    if (data_flag) begin
     for(loop_1=0; loop_1<64;loop_1++) begin
        if({p6,p7,p8,p9,p10,p11} == loop_1[5:0]) begin
     out1 = add[loop_1[5:0]];
      out1_flag = 1'b1;
      break;
    end
  end
  end
end
 always_ff @(posedge clk) begin
  out2 = 3'b0;
    out2_flag = 1'b0;
    if (data_flag) begin
     for(loop_2=0; loop_2<64;loop_2++) begin
        if({p12,p13,p14,p15,p16,p17} == loop_2[5:0]) begin
     out2 = add[loop_2[5:0]];
      out2_flag = 1'b1;
      break;
    end
  end
  end
end
 always_ff @(posedge clk) begin
  out3 = 3'b0;
    out3_flag = 1'b0;
    if (data_flag) begin
     for(loop_3=0; loop_3<64;loop_3++) begin
        if({p18,p19,p20,p21,p22,p23} == loop_3[5:0]) begin
     out3 = add[loop_3[5:0]];
      out3_flag = 1'b1;
      break;
    end
  end
  end
end
 always_ff @(posedge clk) begin
  out4 = 3'b0;
    out4_flag = 1'b0;
    if (data_flag) begin
     for(loop_4=0; loop_4<64;loop_4++) begin
        if({p24,p25,p26,p27,p28,p29} == loop_4[5:0]) begin
     out4 = add[loop_4[5:0]];
      out4_flag = 1'b1;
      break;
    end
  end
  end
end
 always_ff @(posedge clk) begin
  out5 = 3'b0;
    out5_flag = 1'b0;
    if (data_flag) begin
     for(loop_5=0; loop_5<64;loop_5++) begin
        if({1'b0,1'b0,1'b0,1'b0,p30,p31} == loop_5[5:0]) begin
     out5 = add[loop_5[5:0]];
      out5_flag = 1'b1;
      break;
    end
  end
  end
end

//////////////////////////////////////////////////////////////////////////////////////////
// count the all 7 3bit number columns
//////////////////////////////////////////////////////////////////////////////////////////
count_ones_sub sub0(
    .a(out0[0]),
    .b(out1[0]),
    .c(out2[0]),
    .d(out3[0]),
    .e(out4[0]),
    .f(out5[0]),
    .data(add),
    .sub_out(sum0)
);

count_ones_sub sub1(
    .a(out0[1]),
    .b(out1[1]),
    .c(out2[1]),
    .d(out3[1]),
    .e(out4[1]),
    .f(out5[1]),
    .data(add),
    .sub_out(sum1)
);

count_ones_sub sub2(
    .a(out0[2]),
    .b(out1[2]),
    .c(out2[2]),
    .d(out3[2]),
    .e(out4[2]),
    .f(out5[2]),
    .data(add),
    .sub_out(sum2)
);

 

  adder_4bit_re s1(
    .clk(clk),
    .write_en(1'b1),
    .a({1'b0,1'b0,sum0[2:1]}),
    .b({1'b0,sum1}),
    .c({sum2,1'b0}),
    .data_add(add),
    .data_unq(cam_mem_unq),
    .sum(sum),
    .actual_sum(actual_sum_v2),
    .address(address_v2)
  );

assign out = {sum,sum0[0]};

endmodule


module adder_mul_64bit_re(
input logic clk,
input logic rst,
  input logic write_en,
  input logic [63:0] p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15,
        p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31,
  input logic  [2:0] data [63:0],
  input logic [4:0] data_unq [127:0],
  output logic [72:0] sum, actual_sum,
  output logic [12:0] address

    );
   
   logic [72:0] actualsum_pps, actualsum_pps01_23_45;
   logic [64:0] sum_pps45,sum_pps23,sum_pps01;
    logic [64:0] actual_sum23,actual_sum01,actual_sum45;
    
      logic [68:0]  actual_sum0123,sum_pps0123;
      logic [72:0] sum_pps012345,actual_sum012345;

   
   logic [5:0] count0, count1, count2, count3, count4, count5, count6, count7, 
                count8, count9, count10, count11, count12, count13, count14, count15,
                count16, count17, count18, count19, count20, count21, 
                count22, count23, count24, count25, count26,count27, count28, count29, count30, 
                count31, count32, count33, count34, count35, count36, count37, count38, count39, 
                count40, count41, count42, count43, count44, count45, count46, count47, count48, 
                count49, count50, count51, count52, count53, count54, count55, count56, count57, 
                count58, count59, count60, count61, count62, count63;
   
                


logic final_flag,final_flag01,final_flag23,final_flag45,final_flag012345,final_flag0123;
logic [68:0] pps0, pps1, pps2, pps3,pps4,pps5;



    
 assign actual_sum =p0 + p1 + p2 + p3 + p4 + p5 + p6 + p7 + p8 + p9 + p10 + p11 + p12 + p13 + p14 + p15 + p16 + p17 + p18 + p19 + p20 + p21 + p22 + p23 + p24 + p25 + p26 + p27 + p28 + p29 + p30 + p31;
   
count_mul_v2 x10(p0[0], p1[0], p2[0], p3[0], p4[0], p5[0], p6[0], p7[0], p8[0], p9[0], p10[0], p11[0], p12[0], p13[0], p14[0], p15[0], p16[0], p17[0], p18[0], p19[0], p20[0], p21[0], p22[0], p23[0], p24[0], p25[0], p26[0], p27[0],  p28[0], p29[0], p30[0], p31[0], data,data_unq,clk, count0); 
 count_mul_v2 x11(p0[1], p1[1], p2[1], p3[1], p4[1], p5[1], p6[1], p7[1], p8[1], p9[1], p10[1], p11[1], p12[1], p13[1], p14[1], p15[1], p16[1], p17[1], p18[1], p19[1], p20[1], p21[1], p22[1], p23[1], p24[1], p25[1], p26[1], p27[1], 
 p28[1], p29[1], p30[1], p31[1], data,data_unq,clk, count1); 
 count_mul_v2 x12(p0[2], p1[2], p2[2], p3[2], p4[2], p5[2], p6[2], p7[2], p8[2], p9[2], p10[2], p11[2], p12[2], p13[2], p14[2], p15[2], p16[2], p17[2], p18[2], p19[2], p20[2], p21[2], p22[2], p23[2], p24[2], p25[2], p26[2], p27[2], 
 p28[2], p29[2], p30[2], p31[2], data,data_unq,clk, count2); 
 count_mul_v2 x13(p0[3], p1[3], p2[3], p3[3], p4[3], p5[3], p6[3], p7[3], p8[3], p9[3], p10[3], p11[3], p12[3], p13[3], p14[3], p15[3], p16[3], p17[3], p18[3], p19[3], p20[3], p21[3], p22[3], p23[3], p24[3], p25[3], p26[3], p27[3], 
 p28[3], p29[3], p30[3], p31[3], data,data_unq,clk, count3); 
 count_mul_v2 x14(p0[4], p1[4], p2[4], p3[4], p4[4], p5[4], p6[4], p7[4], p8[4], p9[4], p10[4], p11[4], p12[4], p13[4], p14[4], p15[4], p16[4], p17[4], p18[4], p19[4], p20[4], p21[4], p22[4], p23[4], p24[4], p25[4], p26[4], p27[4], 
 p28[4], p29[4], p30[4], p31[4], data,data_unq,clk, count4); 
 count_mul_v2 x15(p0[5], p1[5], p2[5], p3[5], p4[5], p5[5], p6[5], p7[5], p8[5], p9[5], p10[5], p11[5], p12[5], p13[5], p14[5], p15[5], p16[5], p17[5], p18[5], p19[5], p20[5], p21[5], p22[5], p23[5], p24[5], p25[5], p26[5], p27[5], 
 p28[5], p29[5], p30[5], p31[5], data,data_unq,clk, count5); 
 count_mul_v2 x16(p0[6], p1[6], p2[6], p3[6], p4[6], p5[6], p6[6], p7[6], p8[6], p9[6], p10[6], p11[6], p12[6], p13[6], p14[6], p15[6], p16[6], p17[6], p18[6], p19[6], p20[6], p21[6], p22[6], p23[6], p24[6], p25[6], p26[6], p27[6], 
 p28[6], p29[6], p30[6], p31[6], data,data_unq,clk, count6); 
 count_mul_v2 x17(p0[7], p1[7], p2[7], p3[7], p4[7], p5[7], p6[7], p7[7], p8[7], p9[7], p10[7], p11[7], p12[7], p13[7], p14[7], p15[7], p16[7], p17[7], p18[7], p19[7], p20[7], p21[7], p22[7], p23[7], p24[7], p25[7], p26[7], p27[7], 
 p28[7], p29[7], p30[7], p31[7], data,data_unq,clk, count7); 
 count_mul_v2 x18(p0[8], p1[8], p2[8], p3[8], p4[8], p5[8], p6[8], p7[8], p8[8], p9[8], p10[8], p11[8], p12[8], p13[8], p14[8], p15[8], p16[8], p17[8], p18[8], p19[8], p20[8], p21[8], p22[8], p23[8], p24[8], p25[8], p26[8], p27[8], 
 p28[8], p29[8], p30[8], p31[8], data,data_unq,clk, count8); 
 count_mul_v2 x19(p0[9], p1[9], p2[9], p3[9], p4[9], p5[9], p6[9], p7[9], p8[9], p9[9], p10[9], p11[9], p12[9], p13[9], p14[9], p15[9], p16[9], p17[9], p18[9], p19[9], p20[9], p21[9], p22[9], p23[9], p24[9], p25[9], p26[9], p27[9], 
 p28[9], p29[9], p30[9], p31[9], data,data_unq,clk, count9); 
 count_mul_v2 x20(p0[10], p1[10], p2[10], p3[10], p4[10], p5[10], p6[10], p7[10], p8[10], p9[10], p10[10], p11[10], p12[10], p13[10], p14[10], p15[10], p16[10], p17[10], p18[10], p19[10], p20[10], p21[10], p22[10], p23[10], p24[10], p25[10], p26[10], p27[10], p28[10], p29[10], p30[10], p31[10], data,data_unq,clk, count10); 
 count_mul_v2 x21(p0[11], p1[11], p2[11], p3[11], p4[11], p5[11], p6[11], p7[11], p8[11], p9[11], p10[11], p11[11], p12[11], p13[11], p14[11], p15[11], p16[11], p17[11], p18[11], p19[11], p20[11], p21[11], p22[11], p23[11], p24[11], p25[11], p26[11], p27[11], p28[11], p29[11], p30[11], p31[11], data,data_unq,clk, count11); 
 count_mul_v2 x22(p0[12], p1[12], p2[12], p3[12], p4[12], p5[12], p6[12], p7[12], p8[12], p9[12], p10[12], p11[12], p12[12], p13[12], p14[12], p15[12], p16[12], p17[12], p18[12], p19[12], p20[12], p21[12], p22[12], p23[12], p24[12], p25[12], p26[12], p27[12], p28[12], p29[12], p30[12], p31[12], data,data_unq,clk, count12);
 count_mul_v2 x23(p0[13], p1[13], p2[13], p3[13], p4[13], p5[13], p6[13], p7[13], p8[13], p9[13], p10[13], p11[13], p12[13], p13[13], p14[13], p15[13], p16[13], p17[13], p18[13], p19[13], p20[13], p21[13], p22[13], p23[13], p24[13], p25[13], p26[13], p27[13], p28[13], p29[13], p30[13], p31[13], data,data_unq,clk, count13);
 count_mul_v2 x24(p0[14], p1[14], p2[14], p3[14], p4[14], p5[14], p6[14], p7[14], p8[14], p9[14], p10[14], p11[14], p12[14], p13[14], p14[14], p15[14], p16[14], p17[14], p18[14], p19[14], p20[14], p21[14], p22[14], p23[14], p24[14], p25[14], p26[14], p27[14], p28[14], p29[14], p30[14], p31[14], data,data_unq,clk, count14);
 count_mul_v2 x25(p0[15], p1[15], p2[15], p3[15], p4[15], p5[15], p6[15], p7[15], p8[15], p9[15], p10[15], p11[15], p12[15], p13[15], p14[15], p15[15], p16[15], p17[15], p18[15], p19[15], p20[15], p21[15], p22[15], p23[15], p24[15], p25[15], p26[15], p27[15], p28[15], p29[15], p30[15], p31[15], data,data_unq,clk, count15);
 count_mul_v2 x26(p0[16], p1[16], p2[16], p3[16], p4[16], p5[16], p6[16], p7[16], p8[16], p9[16], p10[16], p11[16], p12[16], p13[16], p14[16], p15[16], p16[16], p17[16], p18[16], p19[16], p20[16], p21[16], p22[16], p23[16], p24[16], p25[16], p26[16], p27[16], p28[16], p29[16], p30[16], p31[16], data,data_unq,clk, count16);
 count_mul_v2 x27(p0[17], p1[17], p2[17], p3[17], p4[17], p5[17], p6[17], p7[17], p8[17], p9[17], p10[17], p11[17], p12[17], p13[17], p14[17], p15[17], p16[17], p17[17], p18[17], p19[17], p20[17], p21[17], p22[17], p23[17], p24[17], p25[17], p26[17], p27[17], p28[17], p29[17], p30[17], p31[17], data,data_unq,clk, count17);
 count_mul_v2 x28(p0[18], p1[18], p2[18], p3[18], p4[18], p5[18], p6[18], p7[18], p8[18], p9[18], p10[18], p11[18], p12[18], p13[18], p14[18], p15[18], p16[18], p17[18], p18[18], p19[18], p20[18], p21[18], p22[18], p23[18], p24[18], p25[18], p26[18], p27[18], p28[18], p29[18], p30[18], p31[18], data,data_unq,clk, count18);
 count_mul_v2 x29(p0[19], p1[19], p2[19], p3[19], p4[19], p5[19], p6[19], p7[19], p8[19], p9[19], p10[19], p11[19], p12[19], p13[19], p14[19], p15[19], p16[19], p17[19], p18[19], p19[19], p20[19], p21[19], p22[19], p23[19], p24[19], p25[19], p26[19], p27[19], p28[19], p29[19], p30[19], p31[19], data,data_unq,clk, count19);
 count_mul_v2 x30(p0[20], p1[20], p2[20], p3[20], p4[20], p5[20], p6[20], p7[20], p8[20], p9[20], p10[20], p11[20], p12[20], p13[20], p14[20], p15[20], p16[20], p17[20], p18[20], p19[20], p20[20], p21[20], p22[20], p23[20], p24[20], p25[20], p26[20], p27[20], p28[20], p29[20], p30[20], p31[20], data,data_unq,clk, count20);
 count_mul_v2 x31(p0[21], p1[21], p2[21], p3[21], p4[21], p5[21], p6[21], p7[21], p8[21], p9[21], p10[21], p11[21], p12[21], p13[21], p14[21], p15[21], p16[21], p17[21], p18[21], p19[21], p20[21], p21[21], p22[21], p23[21], p24[21], p25[21], p26[21], p27[21], p28[21], p29[21], p30[21], p31[21], data,data_unq,clk, count21);
 count_mul_v2 x32(p0[22], p1[22], p2[22], p3[22], p4[22], p5[22], p6[22], p7[22], p8[22], p9[22], p10[22], p11[22], p12[22], p13[22], p14[22], p15[22], p16[22], p17[22], p18[22], p19[22], p20[22], p21[22], p22[22], p23[22], p24[22], p25[22], p26[22], p27[22], p28[22], p29[22], p30[22], p31[22], data,data_unq,clk, count22);
 count_mul_v2 x33(p0[23], p1[23], p2[23], p3[23], p4[23], p5[23], p6[23], p7[23], p8[23], p9[23], p10[23], p11[23], p12[23], p13[23], p14[23], p15[23], p16[23], p17[23], p18[23], p19[23], p20[23], p21[23], p22[23], p23[23], p24[23], p25[23], p26[23], p27[23], p28[23], p29[23], p30[23], p31[23], data,data_unq,clk, count23);
 count_mul_v2 x34(p0[24], p1[24], p2[24], p3[24], p4[24], p5[24], p6[24], p7[24], p8[24], p9[24], p10[24], p11[24], p12[24], p13[24], p14[24], p15[24], p16[24], p17[24], p18[24], p19[24], p20[24], p21[24], p22[24], p23[24], p24[24], p25[24], p26[24], p27[24], p28[24], p29[24], p30[24], p31[24], data,data_unq,clk, count24);
 count_mul_v2 x35(p0[25], p1[25], p2[25], p3[25], p4[25], p5[25], p6[25], p7[25], p8[25], p9[25], p10[25], p11[25], p12[25], p13[25], p14[25], p15[25], p16[25], p17[25], p18[25], p19[25], p20[25], p21[25], p22[25], p23[25], p24[25], p25[25], p26[25], p27[25], p28[25], p29[25], p30[25], p31[25], data,data_unq,clk, count25);
 count_mul_v2 x36(p0[26], p1[26], p2[26], p3[26], p4[26], p5[26], p6[26], p7[26], p8[26], p9[26], p10[26], p11[26], p12[26], p13[26], p14[26], p15[26], p16[26], p17[26], p18[26], p19[26], p20[26], p21[26], p22[26], p23[26], p24[26], p25[26], p26[26], p27[26], p28[26], p29[26], p30[26], p31[26], data,data_unq,clk, count26);
 count_mul_v2 x37(p0[27], p1[27], p2[27], p3[27], p4[27], p5[27], p6[27], p7[27], p8[27], p9[27], p10[27], p11[27], p12[27], p13[27], p14[27], p15[27], p16[27], p17[27], p18[27], p19[27], p20[27], p21[27], p22[27], p23[27], p24[27], p25[27], p26[27], p27[27], p28[27], p29[27], p30[27], p31[27], data,data_unq,clk, count27);
 count_mul_v2 x38(p0[28], p1[28], p2[28], p3[28], p4[28], p5[28], p6[28], p7[28], p8[28], p9[28], p10[28], p11[28], p12[28], p13[28], p14[28], p15[28], p16[28], p17[28], p18[28], p19[28], p20[28], p21[28], p22[28], p23[28], p24[28], p25[28], p26[28], p27[28], p28[28], p29[28], p30[28], p31[28], data,data_unq,clk, count28);
 count_mul_v2 x39(p0[29], p1[29], p2[29], p3[29], p4[29], p5[29], p6[29], p7[29], p8[29], p9[29], p10[29], p11[29], p12[29], p13[29], p14[29], p15[29], p16[29], p17[29], p18[29], p19[29], p20[29], p21[29], p22[29], p23[29], p24[29], p25[29], p26[29], p27[29], p28[29], p29[29], p30[29], p31[29], data,data_unq,clk, count29);
 count_mul_v2 x40(p0[30], p1[30], p2[30], p3[30], p4[30], p5[30], p6[30], p7[30], p8[30], p9[30], p10[30], p11[30], p12[30], p13[30], p14[30], p15[30], p16[30], p17[30], p18[30], p19[30], p20[30], p21[30], p22[30], p23[30], p24[30], p25[30], p26[30], p27[30], p28[30], p29[30], p30[30], p31[30], data,data_unq,clk, count30);
 count_mul_v2 x41(p0[31], p1[31], p2[31], p3[31], p4[31], p5[31], p6[31], p7[31], p8[31], p9[31], p10[31], p11[31], p12[31], p13[31], p14[31], p15[31], p16[31], p17[31], p18[31], p19[31], p20[31], p21[31], p22[31], p23[31], p24[31], p25[31], p26[31], p27[31], p28[31], p29[31], p30[31], p31[31], data,data_unq,clk, count31);
 count_mul_v2 x42(p0[32], p1[32], p2[32], p3[32], p4[32], p5[32], p6[32], p7[32], p8[32], p9[32], p10[32], p11[32], p12[32], p13[32], p14[32], p15[32], p16[32], p17[32], p18[32], p19[32], p20[32], p21[32], p22[32], p23[32], p24[32], p25[32], p26[32], p27[32], p28[32], p29[32], p30[32], p31[32], data,data_unq,clk, count32);
 count_mul_v2 x43(p0[33], p1[33], p2[33], p3[33], p4[33], p5[33], p6[33], p7[33], p8[33], p9[33], p10[33], p11[33], p12[33], p13[33], p14[33], p15[33], p16[33], p17[33], p18[33], p19[33], p20[33], p21[33], p22[33], p23[33], p24[33], p25[33], p26[33], p27[33], p28[33], p29[33], p30[33], p31[33], data,data_unq,clk, count33);
 count_mul_v2 x44(p0[34], p1[34], p2[34], p3[34], p4[34], p5[34], p6[34], p7[34], p8[34], p9[34], p10[34], p11[34], p12[34], p13[34], p14[34], p15[34], p16[34], p17[34], p18[34], p19[34], p20[34], p21[34], p22[34], p23[34], p24[34], p25[34], p26[34], p27[34], p28[34], p29[34], p30[34], p31[34], data,data_unq,clk, count34);
 count_mul_v2 x45(p0[35], p1[35], p2[35], p3[35], p4[35], p5[35], p6[35], p7[35], p8[35], p9[35], p10[35], p11[35], p12[35], p13[35], p14[35], p15[35], p16[35], p17[35], p18[35], p19[35], p20[35], p21[35], p22[35], p23[35], p24[35], p25[35], p26[35], p27[35], p28[35], p29[35], p30[35], p31[35], data,data_unq,clk, count35);
 count_mul_v2 x46(p0[36], p1[36], p2[36], p3[36], p4[36], p5[36], p6[36], p7[36], p8[36], p9[36], p10[36], p11[36], p12[36], p13[36], p14[36], p15[36], p16[36], p17[36], p18[36], p19[36], p20[36], p21[36], p22[36], p23[36], p24[36], p25[36], p26[36], p27[36], p28[36], p29[36], p30[36], p31[36], data,data_unq,clk, count36);
 count_mul_v2 x47(p0[37], p1[37], p2[37], p3[37], p4[37], p5[37], p6[37], p7[37], p8[37], p9[37], p10[37], p11[37], p12[37], p13[37], p14[37], p15[37], p16[37], p17[37], p18[37], p19[37], p20[37], p21[37], p22[37], p23[37], p24[37], p25[37], p26[37], p27[37], p28[37], p29[37], p30[37], p31[37], data,data_unq,clk, count37);
 count_mul_v2 x48(p0[38], p1[38], p2[38], p3[38], p4[38], p5[38], p6[38], p7[38], p8[38], p9[38], p10[38], p11[38], p12[38], p13[38], p14[38], p15[38], p16[38], p17[38], p18[38], p19[38], p20[38], p21[38], p22[38], p23[38], p24[38], p25[38], p26[38], p27[38], p28[38], p29[38], p30[38], p31[38], data,data_unq,clk, count38);
 count_mul_v2 x49(p0[39], p1[39], p2[39], p3[39], p4[39], p5[39], p6[39], p7[39], p8[39], p9[39], p10[39], p11[39], p12[39], p13[39], p14[39], p15[39], p16[39], p17[39], p18[39], p19[39], p20[39], p21[39], p22[39], p23[39], p24[39], p25[39], p26[39], p27[39], p28[39], p29[39], p30[39], p31[39], data,data_unq,clk, count39);
 count_mul_v2 x50(p0[40], p1[40], p2[40], p3[40], p4[40], p5[40], p6[40], p7[40], p8[40], p9[40], p10[40], p11[40], p12[40], p13[40], p14[40], p15[40], p16[40], p17[40], p18[40], p19[40], p20[40], p21[40], p22[40], p23[40], p24[40], p25[40], p26[40], p27[40], p28[40], p29[40], p30[40], p31[40], data,data_unq,clk, count40);
 count_mul_v2 x51(p0[41], p1[41], p2[41], p3[41], p4[41], p5[41], p6[41], p7[41], p8[41], p9[41], p10[41], p11[41], p12[41], p13[41], p14[41], p15[41], p16[41], p17[41], p18[41], p19[41], p20[41], p21[41], p22[41], p23[41], p24[41], p25[41], p26[41], p27[41], p28[41], p29[41], p30[41], p31[41], data,data_unq,clk, count41);
 count_mul_v2 x52(p0[42], p1[42], p2[42], p3[42], p4[42], p5[42], p6[42], p7[42], p8[42], p9[42], p10[42], p11[42], p12[42], p13[42], p14[42], p15[42], p16[42], p17[42], p18[42], p19[42], p20[42], p21[42], p22[42], p23[42], p24[42], p25[42], p26[42], p27[42], p28[42], p29[42], p30[42], p31[42], data,data_unq,clk, count42);
 count_mul_v2 x53(p0[43], p1[43], p2[43], p3[43], p4[43], p5[43], p6[43], p7[43], p8[43], p9[43], p10[43], p11[43], p12[43], p13[43], p14[43], p15[43], p16[43], p17[43], p18[43], p19[43], p20[43], p21[43], p22[43], p23[43], p24[43], p25[43], p26[43], p27[43], p28[43], p29[43], p30[43], p31[43], data,data_unq,clk, count43);
 count_mul_v2 x54(p0[44], p1[44], p2[44], p3[44], p4[44], p5[44], p6[44], p7[44], p8[44], p9[44], p10[44], p11[44], p12[44], p13[44], p14[44], p15[44], p16[44], p17[44], p18[44], p19[44], p20[44], p21[44], p22[44], p23[44], p24[44], p25[44], p26[44], p27[44], p28[44], p29[44], p30[44], p31[44], data,data_unq,clk, count44);
 count_mul_v2 x55(p0[45], p1[45], p2[45], p3[45], p4[45], p5[45], p6[45], p7[45], p8[45], p9[45], p10[45], p11[45], p12[45], p13[45], p14[45], p15[45], p16[45], p17[45], p18[45], p19[45], p20[45], p21[45], p22[45], p23[45], p24[45], p25[45], p26[45], p27[45], p28[45], p29[45], p30[45], p31[45], data,data_unq,clk, count45);
 count_mul_v2 x56(p0[46], p1[46], p2[46], p3[46], p4[46], p5[46], p6[46], p7[46], p8[46], p9[46], p10[46], p11[46], p12[46], p13[46], p14[46], p15[46], p16[46], p17[46], p18[46], p19[46], p20[46], p21[46], p22[46], p23[46], p24[46], p25[46], p26[46], p27[46], p28[46], p29[46], p30[46], p31[46], data,data_unq,clk, count46);
 count_mul_v2 x57(p0[47], p1[47], p2[47], p3[47], p4[47], p5[47], p6[47], p7[47], p8[47], p9[47], p10[47], p11[47], p12[47], p13[47], p14[47], p15[47], p16[47], p17[47], p18[47], p19[47], p20[47], p21[47], p22[47], p23[47], p24[47], p25[47], p26[47], p27[47], p28[47], p29[47], p30[47], p31[47], data,data_unq,clk, count47);
 count_mul_v2 x58(p0[48], p1[48], p2[48], p3[48], p4[48], p5[48], p6[48], p7[48], p8[48], p9[48], p10[48], p11[48], p12[48], p13[48], p14[48], p15[48], p16[48], p17[48], p18[48], p19[48], p20[48], p21[48], p22[48], p23[48], p24[48], p25[48], p26[48], p27[48], p28[48], p29[48], p30[48], p31[48], data,data_unq,clk, count48);
 count_mul_v2 x59(p0[49], p1[49], p2[49], p3[49], p4[49], p5[49], p6[49], p7[49], p8[49], p9[49], p10[49], p11[49], p12[49], p13[49], p14[49], p15[49], p16[49], p17[49], p18[49], p19[49], p20[49], p21[49], p22[49], p23[49], p24[49], p25[49], p26[49], p27[49], p28[49], p29[49], p30[49], p31[49], data,data_unq,clk, count49);
 count_mul_v2 x60(p0[50], p1[50], p2[50], p3[50], p4[50], p5[50], p6[50], p7[50], p8[50], p9[50], p10[50], p11[50], p12[50], p13[50], p14[50], p15[50], p16[50], p17[50], p18[50], p19[50], p20[50], p21[50], p22[50], p23[50], p24[50], p25[50], p26[50], p27[50], p28[50], p29[50], p30[50], p31[50], data,data_unq,clk, count50);
 count_mul_v2 x61(p0[51], p1[51], p2[51], p3[51], p4[51], p5[51], p6[51], p7[51], p8[51], p9[51], p10[51], p11[51], p12[51], p13[51], p14[51], p15[51], p16[51], p17[51], p18[51], p19[51], p20[51], p21[51], p22[51], p23[51], p24[51], p25[51], p26[51], p27[51], p28[51], p29[51], p30[51], p31[51], data,data_unq,clk, count51);
 count_mul_v2 x62(p0[52], p1[52], p2[52], p3[52], p4[52], p5[52], p6[52], p7[52], p8[52], p9[52], p10[52], p11[52], p12[52], p13[52], p14[52], p15[52], p16[52], p17[52], p18[52], p19[52], p20[52], p21[52], p22[52], p23[52], p24[52], p25[52], p26[52], p27[52], p28[52], p29[52], p30[52], p31[52], data,data_unq,clk, count52);
 count_mul_v2 x63(p0[53], p1[53], p2[53], p3[53], p4[53], p5[53], p6[53], p7[53], p8[53], p9[53], p10[53], p11[53], p12[53], p13[53], p14[53], p15[53], p16[53], p17[53], p18[53], p19[53], p20[53], p21[53], p22[53], p23[53], p24[53], p25[53], p26[53], p27[53], p28[53], p29[53], p30[53], p31[53], data,data_unq,clk, count53);
 count_mul_v2 x64(p0[54], p1[54], p2[54], p3[54], p4[54], p5[54], p6[54], p7[54], p8[54], p9[54], p10[54], p11[54], p12[54], p13[54], p14[54], p15[54], p16[54], p17[54], p18[54], p19[54], p20[54], p21[54], p22[54], p23[54], p24[54], p25[54], p26[54], p27[54], p28[54], p29[54], p30[54], p31[54], data,data_unq,clk, count54);
 count_mul_v2 x65(p0[55], p1[55], p2[55], p3[55], p4[55], p5[55], p6[55], p7[55], p8[55], p9[55], p10[55], p11[55], p12[55], p13[55], p14[55], p15[55], p16[55], p17[55], p18[55], p19[55], p20[55], p21[55], p22[55], p23[55], p24[55], p25[55], p26[55], p27[55], p28[55], p29[55], p30[55], p31[55], data,data_unq,clk, count55);
 count_mul_v2 x66(p0[56], p1[56], p2[56], p3[56], p4[56], p5[56], p6[56], p7[56], p8[56], p9[56], p10[56], p11[56], p12[56], p13[56], p14[56], p15[56], p16[56], p17[56], p18[56], p19[56], p20[56], p21[56], p22[56], p23[56], p24[56], p25[56], p26[56], p27[56], p28[56], p29[56], p30[56], p31[56], data,data_unq,clk, count56);
 count_mul_v2 x67(p0[57], p1[57], p2[57], p3[57], p4[57], p5[57], p6[57], p7[57], p8[57], p9[57], p10[57], p11[57], p12[57], p13[57], p14[57], p15[57], p16[57], p17[57], p18[57], p19[57], p20[57], p21[57], p22[57], p23[57], p24[57], p25[57], p26[57], p27[57], p28[57], p29[57], p30[57], p31[57], data,data_unq,clk, count57);
 count_mul_v2 x68(p0[58], p1[58], p2[58], p3[58], p4[58], p5[58], p6[58], p7[58], p8[58], p9[58], p10[58], p11[58], p12[58], p13[58], p14[58], p15[58], p16[58], p17[58], p18[58], p19[58], p20[58], p21[58], p22[58], p23[58], p24[58], p25[58], p26[58], p27[58], p28[58], p29[58], p30[58], p31[58], data,data_unq,clk, count58);
 count_mul_v2 x69(p0[59], p1[59], p2[59], p3[59], p4[59], p5[59], p6[59], p7[59], p8[59], p9[59], p10[59], p11[59], p12[59], p13[59], p14[59], p15[59], p16[59], p17[59], p18[59], p19[59], p20[59], p21[59], p22[59], p23[59], p24[59], p25[59], p26[59], p27[59], p28[59], p29[59], p30[59], p31[59], data,data_unq,clk, count59);
 count_mul_v2 x70(p0[60], p1[60], p2[60], p3[60], p4[60], p5[60], p6[60], p7[60], p8[60], p9[60], p10[60], p11[60], p12[60], p13[60], p14[60], p15[60], p16[60], p17[60], p18[60], p19[60], p20[60], p21[60], p22[60], p23[60], p24[60], p25[60], p26[60], p27[60], p28[60], p29[60], p30[60], p31[60], data,data_unq,clk, count60);
 count_mul_v2 x71(p0[61], p1[61], p2[61], p3[61], p4[61], p5[61], p6[61], p7[61], p8[61], p9[61], p10[61], p11[61], p12[61], p13[61], p14[61], p15[61], p16[61], p17[61], p18[61], p19[61], p20[61], p21[61], p22[61], p23[61], p24[61], p25[61], p26[61], p27[61], p28[61], p29[61], p30[61], p31[61], data,data_unq,clk, count61);
 count_mul_v2 x72(p0[62], p1[62], p2[62], p3[62], p4[62], p5[62], p6[62], p7[62], p8[62], p9[62], p10[62], p11[62], p12[62], p13[62], p14[62], p15[62], p16[62], p17[62], p18[62], p19[62], p20[62], p21[62], p22[62], p23[62], p24[62], p25[62], p26[62], p27[62], p28[62], p29[62], p30[62], p31[62], data,data_unq,clk, count62);
 count_mul_v2 x73(p0[63], p1[63], p2[63], p3[63], p4[63], p5[63], p6[63], p7[63], p8[63], p9[63], p10[63], p11[63], p12[63], p13[63], p14[63], p15[63], p16[63], p17[63], p18[63], p19[63], p20[63], p21[63], p22[63], p23[63], p24[63], p25[63], p26[63], p27[63], p28[63], p29[63], p30[63], p31[63], data,data_unq,clk, count63);
 
 
 
 /*
 #include <stdio.h>
 
 int main() {
     // Write C code here
     for (int i = 0; i<64; i++){
     printf("count_ones_new x%d(p0[%d], p1[%d], p2[%d], p3[%d], p4[%d], p5[%d], p6[%d], p7[%d], p8[%d], p9[%d], p10[%d], p11[%d], p12[%d], p13[%d], p14[%d], p15[%d], p16[%d], p17[%d], p18[%d], p19[%d], p20[%d], p21[%d], p22[%d], p23[%d], p24[%d], p25[%d], p26[%d], p27[%d], p28[%d], p29[%d], p30[%d], p31[%d], data,data_unq,clk, count%d); \n\r",10+i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i,i);
     }
 
     return 0;
 }

 
 */
 
 assign pps0 = {count63[0], count62[0], count61[0], count60[0], count59[0], count58[0], count57[0], count56[0], count55[0], count54[0], count53[0], count52[0], count51[0], count50[0], count49[0], count48[0], count47[0], count46[0], count45[0], count44[0], count43[0], count42[0], count41[0], count40[0], count39[0], count38[0], count37[0], count36[0], count35[0], count34[0], count33[0], count32[0], count31[0], count30[0], count29[0], count28[0], count27[0], count26[0], count25[0], count24[0], count23[0], count22[0], count21[0], count20[0], count19[0], count18[0], count17[0], count16[0], count15[0], count14[0], count13[0], count12[0], count11[0], count10[0], count9[0], count8[0], count7[0], count6[0], count5[0], count4[0], count3[0], count2[0], count1[0], count0[0]};
 assign pps1 = {count63[1], count62[1], count61[1], count60[1], count59[1], count58[1], count57[1], count56[1], count55[1], count54[1], count53[1], count52[1], count51[1], count50[1], count49[1], count48[1], count47[1], count46[1], count45[1], count44[1], count43[1], count42[1], count41[1], count40[1], count39[1], count38[1], count37[1], count36[1], count35[1], count34[1], count33[1], count32[1], count31[1], count30[1], count29[1], count28[1], count27[1], count26[1], count25[1], count24[1], count23[1], count22[1], count21[1], count20[1], count19[1], count18[1], count17[1], count16[1], count15[1], count14[1], count13[1], count12[1], count11[1], count10[1], count9[1], count8[1], count7[1], count6[1], count5[1], count4[1], count3[1], count2[1], count1[1], count0[1], 1'b0}; // sum = {sum,count0[0]}
 assign pps2 = {count63[2], count62[2], count61[2], count60[2], count59[2], count58[2], count57[2], count56[2], count55[2], count54[2], count53[2], count52[2], count51[2], count50[2], count49[2], count48[2], count47[2], count46[2], count45[2], count44[2], count43[2], count42[2], count41[2], count40[2], count39[2], count38[2], count37[2], count36[2], count35[2], count34[2], count33[2], count32[2], count31[2], count30[2], count29[2], count28[2], count27[2], count26[2], count25[2], count24[2], count23[2], count22[2], count21[2], count20[2], count19[2], count18[2], count17[2], count16[2], count15[2], count14[2], count13[2], count12[2], count11[2], count10[2], count9[2], count8[2], count7[2], count6[2], count5[2], count4[2], count3[2], count2[2], count1[2], count0[2], 1'b0, 1'b0};
 assign pps3 = {count63[3], count62[3], count61[3], count60[3], count59[3], count58[3], count57[3], count56[3], count55[3], count54[3], count53[3], count52[3], count51[3], count50[3], count49[3], count48[3], count47[3], count46[3], count45[3], count44[3], count43[3], count42[3], count41[3], count40[3], count39[3], count38[3], count37[3], count36[3], count35[3], count34[3], count33[3], count32[3], count31[3], count30[3], count29[3], count28[3], count27[3], count26[3], count25[3], count24[3], count23[3], count22[3], count21[3], count20[3], count19[3], count18[3], count17[3], count16[3], count15[3], count14[3], count13[3], count12[3], count11[3], count10[3], count9[3], count8[3], count7[3], count6[3], count5[3], count4[3], count3[3], count2[3], count1[3], count0[3], 1'b0, 1'b0, 1'b0};// sum = {sum,count0[2],1'b0,1'b0}
 assign pps4=  {count63[4], count62[4], count61[4], count60[4], count59[4], count58[4], count57[4], count56[4], count55[4], count54[4], count53[4], count52[4], count51[4], count50[4], count49[4], count48[4], count47[4], count46[4], count45[4], count44[4], count43[4], count42[4], count41[4], count40[4], count39[4], count38[4], count37[4], count36[4], count35[4], count34[4], count33[4], count32[4], count31[4], count30[4], count29[4], count28[4], count27[4], count26[4], count25[4], count24[4], count23[4], count22[4], count21[4], count20[4], count19[4], count18[4], count17[4], count16[4], count15[4], count14[4], count13[4], count12[4], count11[4], count10[4], count9[4], count8[4], count7[4], count6[4], count5[4], count4[4], count3[4], count2[4], count1[4], count0[4], 1'b0, 1'b0, 1'b0, 1'b0};// sum = {sum,count0[4],1'b0,1'b0,1'b0,1'b0}
 assign pps5 = {count63[5], count62[5], count61[5], count60[5], count59[5], count58[5], count57[5], count56[5], count55[5], count54[5], count53[5], count52[5], count51[5], count50[5], count49[5], count48[5], count47[5], count46[5], count45[5], count44[5], count43[5], count42[5], count41[5], count40[5], count39[5], count38[5], count37[5], count36[5], count35[5], count34[5], count33[5], count32[5], count31[5], count30[5], count29[5], count28[5], count27[5], count26[5], count25[5], count24[5], count23[5], count22[5], count21[5], count20[5], count19[5], count18[5], count17[5], count16[5], count15[5], count14[5], count13[5], count12[5], count11[5], count10[5], count9[5], count8[5], count7[5], count6[5], count5[5], count4[5], count3[5], count2[5], count1[5], count0[5], 1'b0, 1'b0, 1'b0, 1'b0, 1'b0}; //69 bit width
 /////// OBJECTIVE is : ppso+pps1+pps2+pps3+pps4+pps5
 assign actualsum_pps = pps0+pps1+pps2+pps3+pps4+pps5;
 
adder_64bit_re mod_ad64_0(clk,rst,1'b1,{1'b0,pps0[63:1]},pps1[64:1],64'b0,data,data_unq,sum_pps01,actual_sum01,final_flag01); // sum = {sum,count0[0]}
adder_64bit_re mod_ad64_1(clk,rst,1'b1,{1'b0,pps2[65:3]},pps3[66:3],64'b0,data,data_unq,sum_pps23,actual_sum23,final_flag23);// sum = {sum,count0[2],1'b0,1'b0}
adder_64bit_re mod_ad64_2(clk,rst,1'b1,{1'b0,pps4[67:5]},pps5[68:5],64'b0,data,data_unq,sum_pps45,actual_sum45,final_flag45);// sum = {sum,count0[4],1'b0,1'b0,1'b0,1'b0}

adder_68bit_re mod_ad68_0(clk,rst,1'b1,{ 1'b0, 1'b0,sum_pps01, count0[0]},{sum_pps23, count0[2], 1'b0, 1'b0},68'b0,data,data_unq,sum_pps0123,actual_sum0123,final_flag0123);// sum = {sum,count0[4],1'b0,1'b0,1'b0,1'b0}
adder_72bit_re mod_ad72_0(clk,rst,1'b1,{1'b0,1'b0,sum_pps45, count0[4], 1'b0, 1'b0, 1'b0, 1'b0},{1'b0,1'b0,1'b0,sum_pps0123},72'b0,data,data_unq,sum_pps012345,actual_sum012345,final_flag012345);// sum = {sum,count0[4],1'b0,1'b0,1'b0,1'b0}



//adder_68bit_re mod_ad72_0(clk,rst,1'b1,sum_pps45[63:0],sum_pps0123[63:0],72'b0,data,data_unq,sum_pps012345,actual_sum012345,final_flag012345);// sum = {sum,count0[4],1'b0,1'b0,1'b0,1'b0}



assign sum = sum_pps012345;



assign actualsum_pps01_23_45 = 
    {sum_pps01, count0[0]} + //65bit
    {sum_pps23, count0[2], 1'b0, 1'b0} +  //68bit
    {sum_pps45, count0[4], 1'b0, 1'b0, 1'b0, 1'b0}; //72bit

//assign sum = {actualsum_pps01_23_45,sum_pps01[0],count0[0]};







 /*
 
 assign ppk0 = { 
     sum16_ppk0[4:0], 
     sum15_ppk0[3:0], 
     sum14_ppk0[3:0], 
     sum13_ppk0[3:0], 
     sum12_ppk0[3:0], 
     sum11_ppk0[3:0], 
     sum10_ppk0[3:0], 
     sum9_ppk0[3:0], 
     sum8_ppk0[3:0], 
     sum7_ppk0[3:0], 
     sum6_ppk0[3:0], 
     sum5_ppk0[3:0], 
     sum4_ppk0[3:0], 
     sum3_ppk0[3:0], 
     sum2_ppk0[3:0], 
     sum1_ppk0[3:0], 
     sum0_ppk0[3:0]
 };
 */
endmodule
