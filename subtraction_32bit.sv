`timescale 1ns / 1ps

parameter CAM_WIDTH = 4;  // 16-bit adder
parameter NUM_CELL = 8; 


module ff(
input bit clk,
input bit rst,
input logic [4:0] data_in,
output logic [4:0] data_out
);
always @(posedge clk or negedge rst) begin
if(!rst)  
data_out <= data_in;
else
data_out <= 1'bx;
end
endmodule



  
  
module CAMX_sub_4LSB (
   input bit clk,
   input logic write_en,
   input logic [3:0] a, b, c,
   input logic [1:0] data [NUM_CELL-1:0],
   output logic [4:0] sum,
   output logic carry,
   output logic [12:0] address,
   output logic result_LSB0_flag
 );
 
   logic [2:0] cam_mem [NUM_CELL-1:0]; // CAM cell 
   logic [4:0] carry_out;
   logic [4:0] cam_out;
   logic match_flag_0, match_flag_1, match_flag_2, match_flag_3;
   logic match_flag_carry_1, match_flag_carry_2, match_flag_carry_3;
   logic partial_carry_2, partial_carry_3, partial_carry_4, p_partial_carry_3, p_partial_carry_4,pk_partial_carry_4;
   logic data_flag, sum_flag, sum_flag_p, sum_flag_pp,sum_flag_ppck; 
   byte i, j, k, l, m, n, o, p, q, r, s,t,u,v,w,x,y;
   byte addr_0, addr_1, addr_2, addr_3, pp1, pp2, pp3, ppc2, ppc3, ppc4,ppcc3,ppcc4,ppcc5,ppcck4,ppcck5,ppcckk5;
   logic [4:0] sum_reg;
   logic [4:0] late_0,late_1,late_2;
  // logic [4:0] b_dumm; // except msb every thing is [4:0]
  // logic comp_2s_flag; // changes : newly added
   
   
   always_ff @(posedge clk) begin 
     if (write_en) begin
       for (i = 0; i < NUM_CELL; i++) begin
         cam_mem[i] = data[i];
       end
       data_flag = 1'b1;
     end 
   end
   
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  cycle1
   ///////////////////////////////////////////////////////////////// need optimisation
 
            
 
       

   always_ff @(posedge clk) begin 
     if (!write_en && data_flag) begin 
       match_flag_0 = 1'b0;
       addr_0 = 3'b0;
       
       for (j = 0; j < NUM_CELL; j++ ) begin  
         if ({a[0], b[0], c[0]} == j) begin
           match_flag_0 <= 1'b1;
           addr_0 <= j;
           break; // exit the loop once a match is found
         end
       end
     end 
   end       
     
   always_ff @(posedge clk) begin 
     if (!write_en && data_flag) begin 
       match_flag_1 <= 1'b0;
       addr_1 <= 3'b0;
       
       for (k = 0; k < NUM_CELL; k++ ) begin  
         if ({a[1], b[1], c[1]} == k) begin // changes : b to b_dumm
           match_flag_1 <= 1'b1;
           addr_1 <= k;
           break; // exit the loop once a match is found
         end
       end
     end 
   end       
 
   always_ff @(posedge clk) begin 
     if (!write_en && data_flag) begin 
       match_flag_2 <= 1'b0;
       addr_2 <= 3'b0;
       
       for (l = 0; l < NUM_CELL; l++ ) begin  
         if ({a[2], b[2], c[2]} == l) begin // changes : b to b_dumm
           match_flag_2 <= 1'b1;
           addr_2 <= l;
           break; // exit the loop once a match is found
         end
       end
     end 
   end   
   
   always_ff @(posedge clk) begin 
     if (!write_en && data_flag) begin 
       match_flag_3 <= 1'b0;
       addr_3 <= 3'b0;
       
       for (m = 0; m < NUM_CELL; m++ ) begin  
         if ({a[3], b[3], c[3]} == m) begin // changes : b to b_dumm
           match_flag_3<= 1'b1;
           addr_3 <= m;
           break; // exit the loop once a match is found
         end
       end
     end 
   end   
   
   always_comb begin
     sum_flag = 1'b0;
     if (match_flag_0 && match_flag_1 && match_flag_2 && match_flag_3) begin
       sum_flag = 1'b1;
     end
   end
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  2cycle
   always_ff @(posedge clk) begin 
     if (sum_flag) begin 
       match_flag_carry_1 = 1'b0;
       pp1 = 3'b0;
       
       for (n = 0; n < NUM_CELL; n++ ) begin  
         if ({cam_mem[addr_1][0], cam_mem[addr_0][1]} == n) begin
           match_flag_carry_1 <= 1'b1;
           pp1 <= n;
           break; // exit the loop once a match is found
         end
       end
     end 
   end 
   
   always_ff @(posedge clk) begin 
     if (sum_flag) begin 
       match_flag_carry_2 = 1'b0;
       pp2 = 3'b0;
       
       for (o = 0; o < NUM_CELL; o++ ) begin  
         if ({cam_mem[addr_2][0], cam_mem[addr_1][1]} == o) begin
           match_flag_carry_2 <= 1'b1;
           pp2 <= o;
           break; // exit the loop once a match is found
         end
       end
     end 
   end  
   
   always_ff @(posedge clk) begin 
     if (sum_flag) begin 
       match_flag_carry_3 = 1'b0;
       pp3 = 3'b0;
       
       for (p = 0; p < NUM_CELL; p++ ) begin  
         if ({cam_mem[addr_3][0], cam_mem[addr_2][1]} == p) begin
           match_flag_carry_3 <= 1'b1;
           pp3 <= p;
           break; // exit the loop once a match is found
         end
       end
     end 
   end 
   
   always_comb begin
     if (match_flag_carry_1 && match_flag_carry_2 && match_flag_carry_3) begin
       sum_flag_p = 1'b1;
     end else begin
       sum_flag_p = 1'b0;
     end
   end
   
   ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  3cycle
   
   always_ff @(posedge clk) begin 
     if (sum_flag_p) begin 
       partial_carry_2 <= 1'b0;
       ppc2 <= 3'b0;
       
       for (q = 0; q < NUM_CELL; q++ ) begin  
         if ({cam_mem[pp2][0], cam_mem[pp1][1]} == q) begin
           partial_carry_2 <= 1'b1;
           ppc2 <= q;
           break; // exit the loop once a match is found
         end
       end
     end 
   end
   
   always_ff @(posedge clk) begin 
     if (sum_flag_p) begin 
       partial_carry_3 <= 1'b0;
       ppc3 <= 3'b0;
       
       for (r = 0; r < NUM_CELL; r++ ) begin  
         if ({cam_mem[pp3][0], cam_mem[pp2][1]} == r) begin
           partial_carry_3 <= 1'b1;
           ppc3 <= r;
           break; // exit the loop once a match is found
         end
       end
     end 
   end
   
   always_ff @(posedge clk) begin 
     if (sum_flag_p) begin 
       partial_carry_4 <= 1'b0;
       ppc4 <= 3'b0;
       
       for (s = 0; s < NUM_CELL; s++ ) begin  
         if ({cam_mem[addr_3][1], cam_mem[pp3][1]} == s) begin 
           partial_carry_4 <= 1'b1;
           ppc4 <= s;
           break; // exit the loop once a match is found
         end
       end
     end 
   end
   

    always_comb begin
      if (partial_carry_4 && partial_carry_3 && partial_carry_2) begin
        sum_flag_pp = 1'b1;
      end else begin
        sum_flag_pp = 1'b0;
      end
    end
    
     ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  4cycle
    
    always_ff @(posedge clk) begin 
       if (sum_flag_pp) begin 
         p_partial_carry_3 <= 1'b0;
         ppcc3 <= 3'b0;
         
         for (t = 0; t < NUM_CELL; t++ ) begin  
           if ({cam_mem[ppc3][0], cam_mem[ppc2][1]} == t) begin
             p_partial_carry_3 <= 1'b1;
             ppcc3 <= t;
             break; // exit the loop once a match is found
           end
         end
       end 
     end 
     
     
   always_ff @(posedge clk) begin 
           if (sum_flag_pp) begin 
             p_partial_carry_4 <= 1'b0;
             ppcc4 <= 3'b0;
             
             for (u = 0; u < NUM_CELL; u++ ) begin  
               if ({cam_mem[ppc4][0], cam_mem[ppc3][1]} == u) begin
                 p_partial_carry_4 <= 1'b1;
                 ppcc4 <= u;
                 break; // exit the loop once a match is found
               end
             end
           end 
         end 
         

   always_comb begin
                    if (p_partial_carry_4 &&p_partial_carry_3) begin
                      sum_flag_ppck = 1'b1;
                    end else begin
                      sum_flag_ppck = 1'b0;
                    end
                  end
               ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  5cycle   
  
   always_ff @(posedge clk) begin 
                     if (sum_flag_ppck) begin 
                     pk_partial_carry_4 <= 1'b0;
                     ppcck4 <= 3'b0;
                                  
                     for (w = 0; w < NUM_CELL; w++ ) begin  
                   if ({cam_mem[ppcc4][0], cam_mem[ppcc3][1]} == w) begin
                     pk_partial_carry_4 <= 1'b1;
                           ppcck4 <= w;
                              break; // exit the loop once a match is found
                        end
                       end
                     end 
               end 

   always_comb begin
       if (pk_partial_carry_4) begin
         sum = {cam_mem[ppcck4][0],cam_mem[ppcc3][0] , cam_mem[ppc2][0], cam_mem[pp1][0], cam_mem[addr_0][0] };
         carry = cam_mem[ppcck4][0];
         result_LSB0_flag = 1'b1;
       end else begin
         sum <= {6{1'bx}}; // output x if no match
          result_LSB0_flag <= 1'b0;
       end
       address = {ppc4, ppc3, ppc2};
     end
endmodule 

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module CAMX_sub_4MID (
   input bit clk,
   input logic write_en,
   input logic [3:0] a, b, c,
   input logic carrym,
   input logic [1:0] data [NUM_CELL-1:0],
   output logic [4:0] sum,
   output logic carry,
   output logic [12:0] address,
   output logic result_MID0_flag
 );
 
   logic [2:0] cam_mem [NUM_CELL-1:0]; // CAM cell 
   logic [4:0] carry_out;
   logic [4:0] cam_out;
   logic match_flag_0, match_flag_1, match_flag_2, match_flag_3;
   logic match_flag_carry_1, match_flag_carry_2, match_flag_carry_3;
   logic partial_carry_2, partial_carry_3, partial_carry_4, p_partial_carry_3, p_partial_carry_4,pk_partial_carry_4;
   logic data_flag, sum_flag, sum_flag_p, sum_flag_pp,sum_flag_ppck; 
   byte i, j, k, l, m, n, o, p, q, r, s,t,u,v,w,x,y;
   byte addr_0, addr_1, addr_2, addr_3, pp1, pp2, pp3, ppc2, ppc3, ppc4,ppcc3,ppcc4,ppcc5,ppcck4,ppcck5,ppcckk5;
   logic [4:0] sum_reg;
   logic [4:0] late_0,late_1,late_2;
  // logic [4:0] b_dumm; // except msb every thing is [4:0]
  // logic comp_2s_flag; // changes : newly added
   
   
   always_ff @(posedge clk) begin 
     if (write_en) begin
       for (i = 0; i < NUM_CELL; i++) begin
         cam_mem[i] = data[i];
       end
       data_flag = 1'b1;
     end 
   end
   
   
   ///////////////////////////////////////////////////////////////// need optimisation
 
            
 
       

   always_ff @(posedge clk) begin 
     if (!write_en && data_flag) begin 
       match_flag_0 <= 1'b0;
       addr_0 <= 3'b0;
       
       for (j = 0; j < NUM_CELL; j++ ) begin  
         if ({a[0], b[0], carrym} == j) begin
           match_flag_0 <= 1'b1;
           addr_0 <= j;
           break; // exit the loop once a match is found
         end
       end
     end 
   end       
     
   always_ff @(posedge clk) begin 
     if (!write_en && data_flag) begin 
       match_flag_1 <= 1'b0;
       addr_1 <= 3'b0;
       
       for (k = 0; k < NUM_CELL; k++ ) begin  
         if ({a[1], b[1], c[1]} == k) begin // changes : b to b_dumm
           match_flag_1 <= 1'b1;
           addr_1 <= k;
           break; // exit the loop once a match is found
         end
       end
     end 
   end       
 
   always_ff @(posedge clk) begin 
     if (!write_en && data_flag) begin 
       match_flag_2 <= 1'b0;
       addr_2 <= 3'b0;
       
       for (l = 0; l < NUM_CELL; l++ ) begin  
         if ({a[2], b[2], c[2]} == l) begin // changes : b to b_dumm
           match_flag_2 <= 1'b1;
           addr_2 <= l;
           break; // exit the loop once a match is found
         end
       end
     end 
   end   
   
   always_ff @(posedge clk) begin 
     if (!write_en && data_flag) begin 
       match_flag_3 <= 1'b0;
       addr_3 <= 3'b0;
       
       for (m = 0; m < NUM_CELL; m++ ) begin  
         if ({a[3], b[3], c[3]} == m) begin // changes : b to b_dumm
           match_flag_3 <= 1'b1;
           addr_3 <= m;
           break; // exit the loop once a match is found
         end
       end
     end 
   end   
   
   always_comb begin
     sum_flag = 1'b0;
     if (match_flag_0 && match_flag_1 && match_flag_2 && match_flag_3) begin
       sum_flag = 1'b1;
     end
   end
   
   always_ff @(posedge clk) begin 
     if (sum_flag) begin 
       match_flag_carry_1 <= 1'b0;
       pp1 <= 3'b0;
       
       for (n = 0; n < NUM_CELL; n++ ) begin  
         if ({cam_mem[addr_1][0], cam_mem[addr_0][1]} == n) begin
           match_flag_carry_1 <= 1'b1;
           pp1 <= n;
           break; // exit the loop once a match is found
         end
       end
     end 
   end 
   
   always_ff @(posedge clk) begin 
     if (sum_flag) begin 
       match_flag_carry_2 <= 1'b0;
       pp2 <= 3'b0;
       
       for (o = 0; o < NUM_CELL; o++ ) begin  
         if ({cam_mem[addr_2][0], cam_mem[addr_1][1]} == o) begin
           match_flag_carry_2 <= 1'b1;
           pp2 <= o;
           break; // exit the loop once a match is found
         end
       end
     end 
   end  
   
   always_ff @(posedge clk) begin 
     if (sum_flag) begin 
       match_flag_carry_3 <= 1'b0;
       pp3 <= 3'b0;
       
       for (p = 0; p < NUM_CELL; p++ ) begin  
         if ({cam_mem[addr_3][0], cam_mem[addr_2][1]} == p) begin
           match_flag_carry_3 <= 1'b1;
           pp3 <= p;
           break; // exit the loop once a match is found
         end
       end
     end 
   end 
   
   always_comb begin
     if (match_flag_carry_1 && match_flag_carry_2 && match_flag_carry_3) begin
       sum_flag_p = 1'b1;
     end else begin
       sum_flag_p = 1'b0;
     end
   end
   
   always_ff @(posedge clk) begin 
     if (sum_flag_p) begin 
       partial_carry_2 <= 1'b0;
       ppc2 <= 3'b0;
       
       for (q = 0; q < NUM_CELL; q++ ) begin  
         if ({cam_mem[pp2][0], cam_mem[pp1][1]} == q) begin
           partial_carry_2 <= 1'b1;
           ppc2 <= q;
           break; // exit the loop once a match is found
         end
       end
     end 
   end
   
   always_ff @(posedge clk) begin 
     if (sum_flag_p) begin 
       partial_carry_3 <= 1'b0;
       ppc3 <= 3'b0;
       
       for (r = 0; r < NUM_CELL; r++ ) begin  
         if ({cam_mem[pp3][0], cam_mem[pp2][1]} == r) begin
           partial_carry_3 <= 1'b1;
           ppc3 <= r;
           break; // exit the loop once a match is found
         end
       end
     end 
   end
   
   always_ff @(posedge clk) begin 
     if (sum_flag_p) begin 
       partial_carry_4 <= 1'b0;
       ppc4 <= 3'b0;
       
       for (s = 0; s < NUM_CELL; s++ ) begin  
         if ({cam_mem[addr_3][1], cam_mem[pp3][1]} == s) begin 
           partial_carry_4 <= 1'b1;
           ppc4 <= s;
           break; // exit the loop once a match is found
         end
       end
     end 
   end
   

    always_comb begin
      if (partial_carry_4 && partial_carry_3 && partial_carry_2) begin
        sum_flag_pp = 1'b1;
      end else begin
        sum_flag_pp = 1'b0;
      end
    end
    
    
    
    always_ff @(posedge clk) begin 
       if (sum_flag_pp) begin 
         p_partial_carry_3 <= 1'b0;
         ppcc3 <= 3'b0;
         
         for (t = 0; t < NUM_CELL; t++ ) begin  
           if ({cam_mem[ppc3][0], cam_mem[ppc2][1]} == t) begin
             p_partial_carry_3 <= 1'b1;
             ppcc3 <= t;
             break; // exit the loop once a match is found
           end
         end
       end 
     end 
     
     
   always_ff @(posedge clk) begin 
           if (sum_flag_pp) begin 
             p_partial_carry_4 <= 1'b0;
             ppcc4 <= 3'b0;
             
             for (u = 0; u < NUM_CELL; u++ ) begin  
               if ({cam_mem[ppc4][0], cam_mem[ppc3][1]} == u) begin
                 p_partial_carry_4 <= 1'b1;
                 ppcc4 <= u;
                 break; // exit the loop once a match is found
               end
             end
           end 
         end 
         

   always_comb begin
                    if (p_partial_carry_4 &&p_partial_carry_3) begin
                      sum_flag_ppck = 1'b1;
                    end else begin
                      sum_flag_ppck = 1'b0;
                    end
                  end
                  
  
   always_ff @(posedge clk) begin 
                     if (sum_flag_ppck) begin 
                     pk_partial_carry_4 <= 1'b0;
                     ppcck4 <= 3'b0;
                                  
                     for (w = 0; w < NUM_CELL; w++ ) begin  
                   if ({cam_mem[ppcc4][0], cam_mem[ppcc3][1]} == w) begin
                     pk_partial_carry_4 <= 1'b1;
                           ppcck4 <= w;
                              break; // exit the loop once a match is found
                        end
                       end
                     end 
               end 

   always_comb begin
       if (pk_partial_carry_4) begin
         sum = {cam_mem[ppcck4][0],cam_mem[ppcc3][0] , cam_mem[ppc2][0], cam_mem[pp1][0], cam_mem[addr_0][0] };
         carry = cam_mem[ppcck4][0];
         result_MID0_flag = 1'b1;
       end else begin
         sum = {6{1'bx}}; // output x if no match
          result_MID0_flag = 1'b0;
       end
       address = {ppc4, ppc3, ppc2};
     end
endmodule 










///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


module CAMX_sub_4MSB (
  input bit clk,
  input logic write_en,
  input logic [3:0] a,
  input logic [4:0] b, 
  input logic [3:0]c,            //c= 0 a-b
  input logic carry,
  input logic [1:0] data [NUM_CELL-1:0],
  output logic [4:0] sum,
  output logic [12:0] address,
  output logic result_MSB_flag
);

  logic [2:0] cam_mem [NUM_CELL-1:0]; // CAM cell 
  logic [4:0] carry_out;
  logic [4:0] cam_out;
  logic match_flag_0, match_flag_1, match_flag_2, match_flag_3;
  logic match_flag_carry_1, match_flag_carry_2, match_flag_carry_3,match_flag_carry_4;
  logic partial_carry_2, partial_carry_3, partial_carry_4,partial_carry_5,partial_carry_6, p_partial_carry_3, p_partial_carry_4, p_partial_carry_5,p_partial_carry_6,pk_partial_carry_4,pk_partial_carry_5,pk_partial_carry_6,pkk_partial_carry_5,pkk_partial_carry_6,pkkk_partial_carry_6;
  logic data_flag, sum_flag, sum_flag_p, sum_flag_pp,sum_flag_ppck,sum_flag_ppckk; 
  byte i, j, k, l, m, n, o, p,p1,p2, q, r, s,s1,t,u,u1,u2,v,w,x,x1,y,y1,z;
  byte addr_0, addr_1, addr_2, addr_3, pp1, pp2, pp3,pp4,pp5, ppc2, ppc3, ppc4,ppc5,ppc6,ppcc3,ppcc4,ppcc5,ppcc6,ppcck4,ppcck5,ppcck6,ppcckk5,ppcckk6,ppcckkk6;
  logic [4:0] sum_reg;
  logic [4:0] late_0,late_1,late_2;
  //logic [4:0] b_dumm;
  //logic comp_2s_flag;
 // logic [6:0] sum_add;

  always_ff @(posedge clk) begin 
    if (write_en) begin
      for (i = 0; i < NUM_CELL; i++) begin
        cam_mem[i] = data[i];
      end
      data_flag = 1'b1;
    end 
  end
   

  
  always_ff @(posedge clk) begin 
    if (!write_en && data_flag) begin 
      match_flag_0 <= 1'b0;
      addr_0 <= 3'b0;
      
      for (j = 0; j < NUM_CELL; j++ ) begin  
        if ({a[0], b[0], carry} == j) begin // carry added to the LSB
          match_flag_0 <= 1'b1;
          addr_0 <= j;
          break; // exit the loop once a match is found
        end
      end
    end 
  end       
    
  always_ff @(posedge clk) begin 
    if (!write_en && data_flag)  begin 
      match_flag_1 <= 1'b0;
      addr_1 <= 3'b0;
      
      for (k = 0; k < NUM_CELL; k++ ) begin  
        if ({a[1], b[1], c[1]} == k) begin
          match_flag_1 <= 1'b1;
          addr_1 <= k;
          break; // exit the loop once a match is found
        end
      end
    end 
  end       

  always_ff @(posedge clk) begin 
    if (!write_en && data_flag ) begin 
      match_flag_2 <= 1'b0;
      addr_2 <= 3'b0;
      
      for (l = 0; l < NUM_CELL; l++ ) begin  
        if ({a[2], b[2], c[2]} == l) begin
          match_flag_2 <= 1'b1;
          addr_2 <= l;
          break; // exit the loop once a match is found
        end
      end
    end 
  end   
  
  always_ff @(posedge clk) begin 
    if (!write_en && data_flag) begin 
      match_flag_3 <= 1'b0;
      addr_3 <= 3'b0;
      
      for (m = 0; m < NUM_CELL; m++ ) begin  
        if ({a[3], b[3], c[3]} == m) begin
          match_flag_3 <= 1'b1;
          addr_3 <=  m;
          break; // exit the loop once a match is found
        end
      end
    end 
  end   
  
  
  
  
  always_comb begin
    sum_flag = 1'b0;
    if (match_flag_0 && match_flag_1 && match_flag_2 && match_flag_3 ) begin
      sum_flag = 1'b1;
    end
  end
  
  
  always_ff @(posedge clk) begin 
    if (sum_flag) begin 
      match_flag_carry_1 <= 1'b0;
      pp1 <= 3'b0;
      
      for (n = 0; n < NUM_CELL; n++ ) begin  
        if ({cam_mem[addr_1][0], cam_mem[addr_0][1]} == n) begin
          match_flag_carry_1 <= 1'b1;
          pp1 <= n;
          break; // exit the loop once a match is found
        end
      end
    end 
  end 
  
  always_ff @(posedge clk) begin 
    if (sum_flag) begin 
      match_flag_carry_2 <= 1'b0;
      pp2 <= 3'b0;
      
      for (o = 0; o < NUM_CELL; o++ ) begin  
        if ({cam_mem[addr_2][0], cam_mem[addr_1][1]} == o) begin
          match_flag_carry_2 <= 1'b1;
          pp2 <= o;
          break; // exit the loop once a match is found
        end
      end
    end 
  end  
  
  always_ff @(posedge clk) begin 
    if (sum_flag) begin 
      match_flag_carry_3 <= 1'b0;
      pp3 <= 3'b0;
      
      for (p = 0; p < NUM_CELL; p++ ) begin  
        if ({cam_mem[addr_3][0], cam_mem[addr_2][1]} == p) begin
          match_flag_carry_3 <= 1'b1;
          pp3 <= p;
          break; // exit the loop once a match is found
        end
      end
    end 
  end 
  
  
   always_ff @(posedge clk) begin 
     if (sum_flag) begin 
       match_flag_carry_4 <= 1'b0;
       pp4 <= 3'b0;
       
       for (p1 = 0; p1 < NUM_CELL; p1++ ) begin  
         if ({b[4], cam_mem[addr_3][1]} == p1) begin
           match_flag_carry_4 <= 1'b1;
           pp4 <= p1;
           break; // exit the loop once a match is found
         end
       end
     end 
   end 

  
  always_comb begin
    if (match_flag_carry_1 && match_flag_carry_2 && match_flag_carry_3 && match_flag_carry_4) begin
      sum_flag_p = 1'b1;
    end else begin
      sum_flag_p = 1'b0;
    end
  end
  
  always_ff @(posedge clk) begin 
    if (sum_flag_p) begin 
      partial_carry_2 <= 1'b0;
      ppc2 <= 3'b0;
      
      for (q = 0; q < NUM_CELL; q++ ) begin  
        if ({cam_mem[pp2][0], cam_mem[pp1][1]} == q) begin
          partial_carry_2 <= 1'b1;
          ppc2 <= q;
          break; // exit the loop once a match is found
        end
      end
    end 
  end
  
  always_ff @(posedge clk) begin 
    if (sum_flag_p) begin 
      partial_carry_3 <= 1'b0;
      ppc3 <= 3'b0;
      
      for (r = 0; r < NUM_CELL; r++ ) begin  
        if ({cam_mem[pp3][0], cam_mem[pp2][1]} == r) begin
          partial_carry_3 <= 1'b1;
          ppc3 <= r;
          break; // exit the loop once a match is found
        end
      end
    end 
  end
  
  always_ff @(posedge clk) begin 
    if (sum_flag_p) begin 
      partial_carry_4 <= 1'b0;
      ppc4 <= 3'b0;
      
      for (s = 0; s < NUM_CELL; s++ ) begin  
        if ({cam_mem[pp4][0], cam_mem[pp3][1]} == s) begin 
          partial_carry_4 <= 1'b1;
          ppc4 <= s;
          break; // exit the loop once a match is found
        end
      end
    end 
  end
  
  always_ff @(posedge clk) begin 
    if (sum_flag_p) begin 
      partial_carry_5 <= 1'b0;
      ppc5 <= 3'b0;
      
      for (s1 = 0; s1 < NUM_CELL; s1++ ) begin  
        if ({cam_mem[pp5][0], cam_mem[pp4][1]} == s1) begin 
          partial_carry_5 <= 1'b1;
          ppc5 <= s1;
          break; // exit the loop once a match is found
        end
      end
    end 
  end

   always_comb begin
     if (partial_carry_4 && partial_carry_3 && partial_carry_2 && partial_carry_5) begin
       sum_flag_pp = 1'b1;
     end else begin
       sum_flag_pp = 1'b0;
     end
   end
   
   
   
   always_ff @(posedge clk) begin 
      if (sum_flag_pp) begin 
        p_partial_carry_3 <= 1'b0;
        ppcc3 <= 3'b0;
        
        for (t = 0; t < NUM_CELL; t++ ) begin  
          if ({cam_mem[ppc3][0], cam_mem[ppc2][1]} == t) begin
            p_partial_carry_3 <= 1'b1;
            ppcc3 <= t;
            break; // exit the loop once a match is found
          end
        end
      end 
    end 
    
    
  always_ff @(posedge clk) begin 
          if (sum_flag_pp) begin 
            p_partial_carry_4 <= 1'b0;
            ppcc4 <= 3'b0;
            
            for (u = 0; u < NUM_CELL; u++ ) begin  
              if ({cam_mem[ppc4][0], cam_mem[ppc3][1]} == u) begin
                p_partial_carry_4 <= 1'b1;
                ppcc4 <= u;
                break; // exit the loop once a match is found
              end
            end
          end 
        end 
        
 
  always_ff @(posedge clk) begin 
                if (sum_flag_pp) begin 
                  p_partial_carry_5 <= 1'b0;
                  ppcc5 <= 3'b0;
                  
                  for (u1 = 0; u1 < NUM_CELL; u1++ ) begin  
                    if ({cam_mem[ppc5][0], cam_mem[ppc4][1]} == u1) begin
                      p_partial_carry_5 <= 1'b1;
                      ppcc5 <= u1;
                      break; // exit the loop once a match is found
                    end
                  end
                end 
              end
              


  always_ff @(posedge clk) begin 
                if (sum_flag_pp) begin 
                  p_partial_carry_6 <= 1'b0;
                  ppcc6 <= 3'b0;
                  
                  for (u2 = 0; u2 < NUM_CELL; u2++ ) begin  
                    if ({cam_mem[ppc5][1], cam_mem[pp5][1]} == u2) begin
                      p_partial_carry_6 <= 1'b1;
                      ppcc6 <= u2;
                      break; // exit the loop once a match is found
                    end
                  end
                end 
              end

                       

  always_comb begin
                   if (p_partial_carry_4 &&p_partial_carry_3 && p_partial_carry_5 && p_partial_carry_6) begin
                     sum_flag_ppck = 1'b1;
                   end else begin
                     sum_flag_ppck = 1'b0;
                   end
                 end
                 
 
  always_ff @(posedge clk) begin 
                    if (sum_flag_ppck) begin 
                    pk_partial_carry_4 <= 1'b0;
                    ppcck4 <= 3'b0;
                                 
                    for (w = 0; w < NUM_CELL; w++ ) begin  
                  if ({cam_mem[ppcc4][0], cam_mem[ppcc3][1]} == w) begin
                    pk_partial_carry_4 <= 1'b1;
                          ppcck4 <= w;
                             break; // exit the loop once a match is found
                       end
                      end
                    end 
              end 
               
  always_comb begin
    if (pk_partial_carry_4) begin
        sum = {cam_mem[ppcck4][0],cam_mem[ppcc3][0] , cam_mem[ppc2][0], cam_mem[pp1][0], cam_mem[addr_0][0] };
         result_MSB_flag = 1'b1;
      end else begin
        sum = {6{1'bx}}; // output x if no match
         result_MSB_flag = 1'b0;
      end
      address = {ppc4, ppc3, ppc2};
    end
  
 endmodule
 
module CAMX_sub8_plus(
    input bit clk,
    input logic write_en,
    input logic [31:0]a,b,c,
    input logic [1:0] data [NUM_CELL-1:0],
    output logic [32:0] sub,
    output logic result_LSB0_flag,result_MID1_flag,result_MID2_flag,result_MID3_flag,result_MID4_flag,result_MID5_flag,result_MID6_flag, result_MSB_flag,
    output logic [4:0] sumL,sumMid1,sumMid2,sumMid3,sumMid4,sumMid5,sumMid6,sumM
);

logic [3:0] a0,a1,a2,a3,a4,a5,a6,a7,b0,b1,b2,b3,b4,b5,b6,c0,c1,c2,c3,c4,c5,c6,c7; //32bit a0 to a7  4 bit width
logic [4:0] b7; // last MSB module compliment borrow it should be 5 bit
logic [32:0] comp_2_b;
logic carry,carrym0,carrym1,carrym2,carrym3,carrym4,carrym5,carrym6;
assign a0 = a[3:0];
assign a1 = a[7:4];
assign a2 = a[11:8];
assign a3 = a[15:12];
assign a4 = a[19:16];
assign a5 = a[23:20];
assign a6 = a[27:24];
assign a7 = a[31:28];

assign comp_2_b = ~b +1;  //change n+1 bit 

assign b0 = comp_2_b[3:0];
assign b1 = comp_2_b[7:4];
assign b2 = comp_2_b[11:8];
assign b3 = comp_2_b[15:12];
assign b4 = comp_2_b[19:16];
assign b5 = comp_2_b[23:20];
assign b6 = comp_2_b[27:24];
assign b7 = comp_2_b[32:28];  // 5-bit width



assign c0 = c[3:0];
assign c1 = c[7:4];
assign c2 = c[11:8];
assign c3 = c[15:12];
assign c4 = c[19:16];
assign c5 = c[23:20];
assign c6 = c[27:24];
assign c7 = c[31:28];


  //logic [4:0] sumL,sumM; // wite to logic
logic [32:0] address, address1, address2, address3, address4, address5, address6, address7;

 // logic [8:0] actual_sub;
  
 // logic [8:0] sub_dummy;

// LSB Module (4 LSB bits)
CAMX_sub_4LSB x0 (
    .clk(clk),
    .write_en(write_en),
    .a(a0),
    .b(b0),
    .c(c0),
    .data(data),
    .sum(sumL),
    .carry(carry),
    .address(address),
    .result_LSB0_flag(result_LSB0_flag)
);

// MID Modules (4 MID bits each)

// MID 0 Module
CAMX_sub_4MID x1 (
    .clk(clk),
    .write_en(write_en),
    .a(a1),
    .b(b1),
    .c(c1),
    .carrym(carry),   // change :carry
    .data(data),
    .sum(sumMid1),
    .carry(carrym1),
    .address(address1),
    .result_MID0_flag(result_MID1_flag)
);

// MID 1 Module
CAMX_sub_4MID x2 (
    .clk(clk),
    .write_en(write_en),
    .a(a2),
    .b(b2),
    .c(c2),
    .carrym(carrym1),
    .data(data),
    .sum(sumMid2),
    .carry(carrym2),
    .address(address2),
    .result_MID0_flag(result_MID2_flag)
);

// MID 2 Module
CAMX_sub_4MID x3 (
    .clk(clk),
    .write_en(write_en),
    .a(a3),
    .b(b3),
    .c(c3),
    .carrym(carrym2),
    .data(data),
    .sum(sumMid3),
    .carry(carrym3),
    .address(address3),
    .result_MID0_flag(result_MID3_flag)
);

// MID 3 Module
CAMX_sub_4MID x4 (
    .clk(clk),
    .write_en(write_en),
    .a(a4),
    .b(b4),
    .c(c4),
    .carrym(carrym3),
    .data(data),
    .sum(sumMid4),
    .carry(carrym4),
    .address(address4),
    .result_MID0_flag(result_MID4_flag)
);

// MID 4 Module
CAMX_sub_4MID x5 (
    .clk(clk),
    .write_en(write_en),
    .a(a5),
    .b(b5),
    .c(c5),
    .carrym(carrym4),
    .data(data),
    .sum(sumMid5),
    .carry(carrym5),
    .address(address5),
    .result_MID0_flag(result_MID5_flag)
);

// MID 5 Module
CAMX_sub_4MID x6 (
    .clk(clk),
    .write_en(write_en),
    .a(a6),
    .b(b6),
    .c(c6),
    .carrym(carrym5),
    .data(data),
    .sum(sumMid6),
    .carry(carrym6),
    .address(address6),
    .result_MID0_flag(result_MID6_flag)  // change result_MID0_flag is constant for all modukes
);

// MSB Module (4 MSB bits)
CAMX_sub_4MSB x7 (
    .clk(clk),
    .write_en(write_en),
    .a(a7),
    .b(b7),
    .c(c7),
    .carry(carrym6),
    .data(data),
    .sum(sumM),
    .address(address7),
    .result_MSB_flag(result_MSB_flag)
);

 /*
always @(sumM | sumL) begin
    sub_dummy = {sumM,sumL[3:0]};
  end
*/
assign sub = {sumM, sumMid6[3:0],sumMid5[3:0], sumMid4[3:0], sumMid3[3:0], sumMid2[3:0], sumMid1[3:0], sumL[3:0]}; // changes

endmodule
