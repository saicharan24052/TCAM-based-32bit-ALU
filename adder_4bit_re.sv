`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2024 01:50:27 PM
// Design Name: 
// Module Name: adder_4bit_re
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
  input logic [1:0] data_add [7:0],
  input logic [4:0] data [127:0],
  output logic [5:0] sum, actual_sum,
  output logic  final_stage_flag

    );
    
 logic [4:0] cam_mem [127:0]; // CAM cell 
  logic [1:0] cam_mem_add [7:0]; // CAM cell 
      logic match_flag_0, match_flag_1, match_flag_2, match_flag_3,match_flag_4;
      logic match_flag_carry_1, match_flag_carry_2, match_flag_carry_3,match_flag_carry_4;
      logic data_flag,data_flag_1, sum_flag,sum_reg_flag,final_flag; 
      int i,i1, j, k, l, m, n, o, p, q, r;
      int addr_0, addr_1, addr_2, addr_3, pp1;
      logic [5:0] sum_reg;

      
      
      /////////   writing data into cam_mem ///////////////////////
       always_ff @(posedge clk) begin 
         if (write_en) begin
           for (i = 0; i < 128; i++) begin
             cam_mem[i] = data[i];
            
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
      final_flag = 1'b0;
      pp1 = 3'b0;
      
     if( {cam_mem_add[addr_3][0], cam_mem_add[addr_2][0]} == 2'b00) begin
          for (n = 0; n < 32; n = n + 1) begin  
              if ({cam_mem_add[addr_1][0], cam_mem_add[addr_3][1], cam_mem_add[addr_2][1], cam_mem_add[addr_1][1], cam_mem_add[addr_0][1]} ==  n[4:0]) begin
                  match_flag_carry_1 = 1'b1;
                  pp1 = {2'b00, n[4:0]};
                  final_flag = 1'b1;
                  break; // exit the loop once a match is found
              end
          end
      end
      
      if( {cam_mem_add[addr_3][0], cam_mem_add[addr_2][0]} == 2'b01) begin
          for (o = 0; o < 32; o = o + 1) begin  
              if ({cam_mem_add[addr_1][0], cam_mem_add[addr_3][1], cam_mem_add[addr_2][1], cam_mem_add[addr_1][1], cam_mem_add[addr_0][1]} ==  o[4:0]) begin
                  match_flag_carry_2 = 1'b1;
                  pp1 = {2'b01, o[4:0]};
                  final_flag = 1'b1;
                  break; // exit the loop once a match is found
              end
          end
      end
      
      if( {cam_mem_add[addr_3][0], cam_mem_add[addr_2][0]} == 2'b10) begin
          for (p = 0; p < 32; p = p + 1) begin  
              if ({cam_mem_add[addr_1][0], cam_mem_add[addr_3][1], cam_mem_add[addr_2][1], cam_mem_add[addr_1][1], cam_mem_add[addr_0][1]} ==  p[4:0]) begin
                  match_flag_carry_3 = 1'b1;
                  pp1 = {2'b10, p[4:0]};
                  final_flag = 1'b1;
                  break; // exit the loop once a match is found
              end
          end
      end
      
      if( {cam_mem_add[addr_3][0], cam_mem_add[addr_2][0]} == 2'b11) begin
          for (q = 0; q < 32; q = q + 1) begin  
              if ({cam_mem_add[addr_1][0], cam_mem_add[addr_3][1], cam_mem_add[addr_2][1], cam_mem_add[addr_1][1], cam_mem_add[addr_0][1]} ==  q[4:0]) begin
                  match_flag_carry_4 = 1'b1;
                  pp1 = {2'b11, q[4:0]};
                  final_flag = 1'b1;
                  break; // exit the loop once a match is found
              end
          end
      end
    

  end 
 end
 
always_comb begin
sum_reg_flag = 1'b0;
if (final_flag) begin
sum_reg <={cam_mem[pp1],cam_mem_add[addr_0][0] };
sum_reg_flag = 1'b1;
end
end
  assign final_stage_flag = sum_reg_flag;
  assign actual_sum = a+b+c;
  assign sum = {cam_mem[pp1],cam_mem_add[addr_0][0] };
         
endmodule
