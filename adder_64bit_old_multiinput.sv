`timescale 1ns / 1ps

parameter CAM_WIDTH = 4;  // 16-bit adder
parameter NUM_CELL = 8; 


module ff(
input bit clk,
input bit rst,
input logic [5:0] data_in,
output logic [5:0] data_out
);
always @(posedge clk or negedge rst) begin
if(!rst)  
data_out <= data_in;
else
data_out <= 1'bx;
end
endmodule




 module adder2bit(
  input logic [1:0] a, b,c,
  input logic [1:0] data [7:0],
  output logic [3:0] sum
);

  logic data_flag;
  logic match_flag_0, match_flag_1,match_flag_2,match_flag_3;
  logic [1:0] add [7:0]; // Adjusted the width of `add`
  logic [2:0] addr_0, addr_1,addr_2,addr_3;
  int m, n, i,o,p;
   
  // Populate the `add` array from the input `data`
  always_comb begin 
    for (i = 0; i < 8; i++) begin
      add[i] = data[i];  // Only assign the lower 2 bits to `add`
    end
    data_flag = 1'b1;
  end 

  // Find the match for the first bit-pair
  always_comb begin 
    if (data_flag) begin 
      match_flag_0 = 1'b0;
      addr_0 = 3'b0;
      
      for (m = 0; m < 8; m++) begin  
        if ({a[0], b[0], c[0]} == m[2:0]) begin
        
          addr_0 = m[2:0];
            match_flag_0 = 1'b1;
          break; // exit the loop once a match is found
        end
      end
    end
  end
//////////////////// LSB  = add[addr_0]/////////////////////////
  // Find the match for the second bit-pair
  always_comb begin 
    if (data_flag) begin 
      match_flag_1 = 1'b0;
      addr_1 = 3'b0;
      
      for (n = 0; n < 8; n++) begin  
        if ({a[1], b[1],c[1]} == n[2:0]) begin
       
          addr_1 = n[2:0];
             match_flag_1 = 1'b1;
          break; // exit the loop once a match is found
        end
      end
    end
  end 
 
 
 always_comb begin 
      if (data_flag && match_flag_0 && match_flag_1) begin 
        match_flag_2 = 1'b0;
        addr_2 = 3'b0;
        
        for (o = 0; o < 8; o++) begin  
          if ({1'b0,add[addr_1][0], add[addr_0][1]} == o[2:0]) begin
          
            addr_2 = o[2:0]; 
              match_flag_2 = 1'b1;
            break; // exit the loop once a match is found
          end
        end
      end
    end
    
    
    
  always_comb begin 
    if (data_flag && match_flag_0 && match_flag_1 && match_flag_2) begin 
           match_flag_3 = 1'b0;
           addr_3 = 3'b0;
           
           for (p = 0; p < 8; p++) begin  
             if ({1'b0,add[addr_2][1], add[addr_1][1]} == p[2:0]) begin
             
               addr_3 = p[2:0];
                 match_flag_3 = 1'b1;
               break; // exit the loop once a match is found
             end
           end
         end
       end     
 
             
  // Assign the result to `sum`
  //assign sum = {add[addr_3][1],add[addr_3][0] ,add[addr_2][0], add[addr_0][0]}; // `sum` is 3-bits   
  
always_comb begin
  if (match_flag_3 && match_flag_2 && match_flag_1 && match_flag_0) begin
        sum  = {add[addr_3][1],add[addr_3][0] ,add[addr_2][0], add[addr_0][0]}; 
      end else begin
        sum = {4{1'bx}}; // output x if no match
      end
    end

  

endmodule

module count_ones_new(
input logic a,b,c,d,e,f,g,h,i,
input logic [1:0] data [7:0],
output logic [3:0] out
    );
    
  logic [1:0] out0,out1,out2;
  logic out0_flag,out1_flag,out2_flag;
  logic [1:0] add [7:0];
  int j,k,l,u;
  logic [3:0] sum;
  logic data_flag;
  
  
    always_comb begin 
    for (u = 0; u< 8; u++) begin
      add[u] = data[u];  // Only assign the lower 2 bits to `add`
    end
    data_flag = 1'b1;
  end

always_comb begin 
out0 = 3'b0;
out0_flag = 1'b0;
if (data_flag) begin
  for(l=0; l<8;l++) begin
    if({a,b,c} == l[2:0]) begin
      out0 = add[l[2:0]];
out0_flag = 1'b1;
  break;
end
end
end
end


always_comb begin
out1 = 3'b0;
out1_flag = 1'b0;
if(out0_flag && data_flag) begin
for(j=0; j<8;j++) begin
if({d,e,f} == j[2:0]) begin
out1 = add[j[2:0]];
out1_flag = 1'b1;
  break;
end
end
end
end

always_comb begin 
out2 = 3'b0;
out2_flag = 1'b0;
  if(out1_flag && data_flag) begin
for(k=0; k<8;k++) begin
if({g,h,i} == k[2:0]) begin
out2 = add[k[2:0]];
out2_flag = 1'b1;
  break;
end
end
end
end


adder2bit x(out0,out1,out2,data,sum);

assign out = sum;

endmodule

module adder_4bit_LSB (
  input bit clk,
  input logic write_en,
  input logic [3:0] a, b, c,
  input logic [1:0] data [7:0],
  output logic [5:0] sum, actual_sum,
  output logic carry,
  output logic [12:0] address,
  output logic result_LSB_flag
);

  logic [1:0] cam_mem [7:0]; // CAM cell 
  logic match_flag_0, match_flag_1, match_flag_2, match_flag_3;
  logic match_flag_carry_1, match_flag_carry_2, match_flag_carry_3;
  logic partial_carry_2, partial_carry_3, partial_carry_4, p_partial_carry_3, p_partial_carry_4,pk_partial_carry_4;
  logic data_flag, sum_flag, sum_flag_p, sum_flag_pp,sum_flag_ppck; 
  int i, j, k, l, m, n, o, p, q, r, s,t,u,v,w,x,y,y1,z;
  int addr_0, addr_1, addr_2, addr_3, pp1, pp2, pp3, ppc2, ppc3, ppc4,ppcc3,ppcc4,ppcc5,ppcck4;
  //logic [5:0] sum_reg;
  //logic [5:0] late_0,late_1,late_2;

  always_ff @(posedge clk) begin 
    if (write_en) begin
      for (i = 0; i < NUM_CELL; i++) begin
        cam_mem[i] = data[i];
      end
      data_flag = 1'b1;
    end 
  end
   
  always_ff @(posedge clk) begin 
    if (data_flag) begin 
      match_flag_0 = 1'b0;
      addr_0 = 3'b0;
      
      for (j = 0; j < NUM_CELL; j++ ) begin  
        if ({a[0], b[0], c[0]} == j) begin
          match_flag_0 = 1'b1;
          addr_0 = j;
          break; // exit the loop once a match is found
        end
      end
    end 
  end       
    
  always_ff @(posedge clk) begin 
    if (data_flag) begin 
      match_flag_1 = 1'b0;
      addr_1 = 3'b0;
      
      for (k = 0; k < NUM_CELL; k++ ) begin  
        if ({a[1], b[1], c[1]} == k) begin
          match_flag_1 = 1'b1;
          addr_1 = k;
          break; // exit the loop once a match is found
        end
      end
    end 
  end       

  always_ff @(posedge clk) begin 
    if (data_flag) begin 
      match_flag_2 = 1'b0;
      addr_2 = 3'b0;
      
      for (l = 0; l < NUM_CELL; l++ ) begin  
        if ({a[2], b[2], c[2]} == l) begin
          match_flag_2 = 1'b1;
          addr_2 = l;
          break; // exit the loop once a match is found
        end
      end
    end 
  end   
  
  always_ff @(posedge clk) begin 
    if (data_flag) begin 
      match_flag_3 = 1'b0;
      addr_3 = 3'b0;
      
      for (m = 0; m < NUM_CELL; m++ ) begin  
        if ({a[3], b[3], c[3]} == m) begin
          match_flag_3 = 1'b1;
          addr_3 = m;
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
      match_flag_carry_1 = 1'b0;
      pp1 = 3'b0;
      
      for (n = 0; n < NUM_CELL; n++ ) begin  
        if ({cam_mem[addr_1][0], cam_mem[addr_0][1]} == n) begin
          match_flag_carry_1 = 1'b1;
          pp1 = n;
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
          match_flag_carry_2 = 1'b1;
          pp2 = o;
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
          match_flag_carry_3 = 1'b1;
          pp3 = p;
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
      partial_carry_2 = 1'b0;
      ppc2 = 3'b0;
      
      for (q = 0; q < NUM_CELL; q++ ) begin  
        if ({cam_mem[pp2][0], cam_mem[pp1][1]} == q) begin
          partial_carry_2 = 1'b1;
          ppc2 = q;
          break; // exit the loop once a match is found
        end
      end
    end 
  end
  
  always_ff @(posedge clk) begin 
    if (sum_flag_p) begin 
      partial_carry_3 = 1'b0;
      ppc3 = 3'b0;
      
      for (r = 0; r < NUM_CELL; r++ ) begin  
        if ({cam_mem[pp3][0], cam_mem[pp2][1]} == r) begin
          partial_carry_3 = 1'b1;
          ppc3 = r;
          break; // exit the loop once a match is found
        end
      end
    end 
  end
  
  always_ff @(posedge clk) begin 
    if (sum_flag_p) begin 
      partial_carry_4 = 1'b0;
      ppc4 = 3'b0;
      
      for (s = 0; s < NUM_CELL; s++ ) begin  
        if ({cam_mem[addr_3][1], cam_mem[pp3][1]} == s) begin 
          partial_carry_4 = 1'b1;
          ppc4 = s;
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
        p_partial_carry_3 = 1'b0;
        ppcc3 = 3'b0;
        
        for (t = 0; t < NUM_CELL; t++ ) begin  
          if ({cam_mem[ppc3][0], cam_mem[ppc2][1]} == t) begin
            p_partial_carry_3 = 1'b1;
            ppcc3 = t;
            break; // exit the loop once a match is found
          end
        end
      end 
    end 
    
    
  always_ff @(posedge clk) begin 
          if (sum_flag_pp) begin 
            p_partial_carry_4 = 1'b0;
            ppcc4 = 3'b0;
            
            for (u = 0; u < NUM_CELL; u++ ) begin  
              if ({cam_mem[ppc4][0], cam_mem[ppc3][1]} == u) begin
                p_partial_carry_4 = 1'b1;
                ppcc4 = u;
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
                    pk_partial_carry_4 = 1'b0;
                    ppcck4 = 3'b0;
                                 
                    for (w = 0; w < NUM_CELL; w++ ) begin  
                  if ({cam_mem[ppcc4][0], cam_mem[ppcc3][1]} == w) begin
                    pk_partial_carry_4 = 1'b1;
                          ppcck4 = w;
                             break; // exit the loop once a match is found
                       end
                      end
                    end 
              end 
 
 
               
  
  always_comb begin
      if (pk_partial_carry_4) begin
        sum = {cam_mem[ppcck4][0],cam_mem[ppcc3][0] , cam_mem[ppc2][0], cam_mem[pp1][0], cam_mem[addr_0][0] };
      carry = cam_mem[ppcck4][0];
       result_LSB_flag = 1'b1;
      end else begin
        sum = {6{1'bx}}; // output x if no match
         result_LSB_flag = 1'b0;
      end
      address = {ppc4, ppc3, ppc2};
    end

 //assign sum_reg = a + b + c;
// ff sai(clk,rst,sum_reg,late_0);
// ff y(clk,rst,late_0,late_1);
  //ff z(clk,rst,late_1,late_2);
  assign actual_sum = a + b + c;

endmodule

///////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module adder_4bit_MSB (
  input bit clk,
  input logic write_en,
  input logic [3:0] a, b, c,
  input logic carryin,
  input logic [1:0] data [7:0],
  output logic carryout,
  output logic [4:0] sum, actual_sum,
  output logic [12:0] address,
  output logic result_MSB_flag
);

  logic [1:0] cam_mem [7:0]; // CAM cell 
  logic match_flag_0, match_flag_1, match_flag_2, match_flag_3;
  logic match_flag_carry_1, match_flag_carry_2, match_flag_carry_3;
  logic partial_carry_2, partial_carry_3, partial_carry_4, p_partial_carry_3, p_partial_carry_4,pk_partial_carry_4;
  logic data_flag, sum_flag, sum_flag_p, sum_flag_pp,sum_flag_ppck; 
  int i, j, k, l, m, n, o, p, q, r, s,t,u,v,w,x,y,y1,z;
  int addr_0, addr_1, addr_2, addr_3, pp1, pp2, pp3, ppc2, ppc3, ppc4,ppcc3,ppcc4,ppcc5,ppcck4,ppcck5;
//  logic [5:0] sum_reg;
  //logic [5:0] late_0,late_1,late_2;

  always_ff @(posedge clk) begin 
    if (write_en) begin
      for (i = 0; i < NUM_CELL; i++) begin
        cam_mem[i] = data[i];
      end
      data_flag = 1'b1;
    end 
  end
   
  always_ff @(posedge clk) begin 
    if (data_flag) begin 
      match_flag_0 = 1'b0;
      addr_0 = 3'b0;
      
      for (j = 0; j < NUM_CELL; j++ ) begin  
        if ({a[0], b[0], carryin} == j[2:0]) begin
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
      
      for (k = 0; k < NUM_CELL; k++ ) begin  
        if ({a[1], b[1], c[1]} == k) begin
          match_flag_1 = 1'b1;
          addr_1 = k;
          break; // exit the loop once a match is found
        end
      end
    end 
  end       

  always_ff @(posedge clk) begin 
    if (data_flag) begin 
      match_flag_2 = 1'b0;
      addr_2 = 3'b0;
      
      for (l = 0; l < NUM_CELL; l++ ) begin  
        if ({a[2], b[2], c[2]} == l) begin
          match_flag_2 = 1'b1;
          addr_2 = l;
          break; // exit the loop once a match is found
        end
      end
    end 
  end   
  
  always_ff @(posedge clk) begin 
    if (data_flag) begin 
      match_flag_3 = 1'b0;
      addr_3 = 3'b0;
      
      for (m = 0; m < NUM_CELL; m++ ) begin  
        if ({a[3], b[3], c[3]} == m) begin
          match_flag_3 = 1'b1;
          addr_3 = m;
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
      match_flag_carry_1 = 1'b0;
      pp1 = 3'b0;
      
      for (n = 0; n < NUM_CELL; n++ ) begin  
        if ({cam_mem[addr_1][0], cam_mem[addr_0][1]} == n) begin
          match_flag_carry_1 = 1'b1;
          pp1 = n;
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
          match_flag_carry_2 = 1'b1;
          pp2 = o;
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
          match_flag_carry_3 = 1'b1;
          pp3 = p;
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
      partial_carry_2 = 1'b0;
      ppc2 = 3'b0;
      
      for (q = 0; q < NUM_CELL; q++ ) begin  
        if ({cam_mem[pp2][0], cam_mem[pp1][1]} == q) begin
          partial_carry_2 = 1'b1;
          ppc2 = q;
          break; // exit the loop once a match is found
        end
      end
    end 
  end
  
  always_ff @(posedge clk) begin 
    if (sum_flag_p) begin 
      partial_carry_3 = 1'b0;
      ppc3 = 3'b0;
      
      for (r = 0; r < NUM_CELL; r++ ) begin  
        if ({cam_mem[pp3][0], cam_mem[pp2][1]} == r) begin
          partial_carry_3 = 1'b1;
          ppc3 = r;
          break; // exit the loop once a match is found
        end
      end
    end 
  end
  
  always_ff @(posedge clk) begin 
    if (sum_flag_p) begin 
      partial_carry_4 = 1'b0;
      ppc4 = 3'b0;
      
      for (s = 0; s < NUM_CELL; s++ ) begin  
        if ({cam_mem[addr_3][1], cam_mem[pp3][1]} == s) begin 
          partial_carry_4 = 1'b1;
          ppc4 = s;
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
        p_partial_carry_3 = 1'b0;
        ppcc3 = 3'b0;
        
        for (t = 0; t < NUM_CELL; t++ ) begin  
          if ({cam_mem[ppc3][0], cam_mem[ppc2][1]} == t) begin
            p_partial_carry_3 = 1'b1;
            ppcc3 = t;
            break; // exit the loop once a match is found
          end
        end
      end 
    end 
    
    
  always_ff @(posedge clk) begin 
          if (sum_flag_pp) begin 
            p_partial_carry_4 = 1'b0;
            ppcc4 = 3'b0;
            
            for (u = 0; u < NUM_CELL; u++ ) begin  
              if ({cam_mem[ppc4][0], cam_mem[ppc3][1]} == u) begin
                p_partial_carry_4 = 1'b1;
                ppcc4 = u;
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
                    pk_partial_carry_4 = 1'b0;
                    ppcck4 = 3'b0;
                                 
                    for (w = 0; w < NUM_CELL; w++ ) begin  
                  if ({cam_mem[ppcc4][0], cam_mem[ppcc3][1]} == w) begin
                    pk_partial_carry_4 = 1'b1;
                          ppcck4 = w;
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
        sum = {5{1'bx}}; // output x if no match
        result_MSB_flag = 1'b0;
        
        
      end
      address = {ppc4, ppc3, ppc2};
    end


  assign carryout = sum[4];
  assign actual_sum = a + b + c+carryin;

endmodule










module bit64_adder(
input logic [63:0] a,b,c,d,e,f,g,h,i,
input logic [1:0] data [7:0],
input logic clk,
input logic write_en,
output logic [68:0] sum,
output logic carry,
output logic  [68:0] actualsum
    );
    
    

assign actualsum = a+b+c+d+e+f+g+h+i; 


 
logic [3:0] count0, count1, count2, count3, count4, count5, count6, count7, 
            count8, count9, count10, count11, count12, count13, count14, count15,
            count16, count17, count18, count19, count20, count21, 
            count22, count23, count24, count25, count26,count27, count28, count29, count30, 
            count31, count32, count33, count34, count35, count36, count37, count38, count39, 
            count40, count41, count42, count43, count44, count45, count46, count47, count48, 
            count49, count50, count51, count52, count53, count54, count55, count56, count57, 
            count58, count59, count60, count61, count62, count63;



  logic result_LSB_flag, result_MSB_flag,result_LSB_flag0_ppss0, result_MSB_flag1_ppss0, result_MSB_flag2_ppss0, 
  result_MSB_flag3_ppss0, result_MSB_flag4_ppss0, result_MSB_flag5_ppss0,result_MSB_flag6_ppss0, 
  result_MSB_flag7_ppss0, result_MSB_flag8_ppss0, result_MSB_flag9_ppss0, result_MSB_flag10_ppss0, 
  result_MSB_flag11_ppss0, result_MSB_flag12_ppss0, result_MSB_flag13_ppss0, result_MSB_flag14_ppss0,
   result_MSB_flag15_ppss0, result_MSB_flag16_ppss0, result_MSB_flag17_ppss0, result_MSB_flag18_ppss0, 
   result_MSB_flag19_ppss0, 
   result_LSB_flag0_ppss1, result_MSB_flag1_ppss1, result_MSB_flag2_ppss1, result_MSB_flag3_ppss1, result_MSB_flag4_ppss1, 
   result_MSB_flag5_ppss1,result_MSB_flag6_ppss1, result_MSB_flag7_ppss1, result_MSB_flag8_ppss1, result_MSB_flag9_ppss1,
    result_MSB_flag10_ppss1, result_MSB_flag11_ppss1, result_MSB_flag12_ppss1, result_MSB_flag13_ppss1, result_MSB_flag14_ppss1, 
    result_MSB_flag15_ppss1, result_MSB_flag16_ppss1, result_MSB_flag17_ppss1, result_MSB_flag18_ppss1, result_MSB_flag19_ppss1;

logic  result_LSB_flag0_ppk0, result_MSB_flag1_ppk0, result_MSB_flag2_ppk0, result_MSB_flag3_ppk0, result_MSB_flag4_ppk0, result_MSB_flag5_ppk0,
result_MSB_flag6_ppk0, result_MSB_flag7_ppk0, result_MSB_flag8_ppk0, result_MSB_flag9_ppk0, result_MSB_flag10_ppk0, result_MSB_flag11_ppk0, 
result_MSB_flag12_ppk0, result_MSB_flag13_ppk0, result_MSB_flag14_ppk0, result_MSB_flag15_ppk0, result_MSB_flag16_ppk0;

logic [4:0] sum0_ppss0, sum1_ppss0, sum2_ppss0, sum3_ppss0, sum4_ppss0, sum5_ppss0, sum6_ppss0, 
sum7_ppss0, sum8_ppss0, sum9_ppss0, sum10_ppss0, sum11_ppss0, sum12_ppss0, sum13_ppss0, sum14_ppss0, sum15_ppss0,sum16_ppss0;

logic [4:0] sum0_ppss1, sum1_ppss1, sum2_ppss1, sum3_ppss1, sum4_ppss1, sum5_ppss1, sum6_ppss1, sum7_ppss1, sum8_ppss1, 
sum9_ppss1, sum10_ppss1, sum11_ppss1, sum12_ppss1, sum13_ppss1, sum14_ppss1, sum15_ppss1,sum16_ppss1;

logic [4:0] sum0_ppk0, sum1_ppk0, sum2_ppk0, sum3_ppk0, sum4_ppk0, sum5_ppk0, sum6_ppk0, sum7_ppk0, 
sum8_ppk0, sum9_ppk0, sum10_ppk0, sum11_ppk0, sum12_ppk0, sum13_ppk0, sum14_ppk0, sum15_ppk0,sum16_ppk0;

     logic [7:0] sumLSB,sumMSB;
     logic [8:0] sumfinal;
    logic  [7:0] actualsum0,actualsum1,actualsum2;
    logic [3:0]zero;

 
 logic carry0_ppss0, carry1_ppss0, carry2_ppss0, carry3_ppss0, carry4_ppss0, carry5_ppss0, carry6_ppss0, carry7_ppss0, 
 carry8_ppss0, carry9_ppss0, carry10_ppss0, carry11_ppss0, carry12_ppss0, carry13_ppss0, carry14_ppss0, carry15_ppss0,carry16_ppss0;
 
logic carry0_ppss1, carry1_ppss1, carry2_ppss1, carry3_ppss1, carry4_ppss1, carry5_ppss1,carry6_ppss1, carry7_ppss1, 
carry8_ppss1, carry9_ppss1, carry10_ppss1, carry11_ppss1, carry12_ppss1, carry13_ppss1, carry14_ppss1, carry15_ppss1,carry16_ppss1;

  logic carry0_ppk0, carry1_ppk0, carry2_ppk0, carry3_ppk0, carry4_ppk0, carry5_ppk0, carry6_ppk0, carry7_ppk0, carry8_ppk0, 
  carry9_ppk0, carry10_ppk0, carry11_ppk0, carry12_ppk0, carry13_ppk0, carry14_ppk0, carry15_ppk0, carry16_ppk0;

   
  logic [12:0] address0_ppss0, address1_ppss0, address2_ppss0, address3_ppss0, address4_ppss0, address5_ppss0, address6_ppss0, 
  address7_ppss0, address8_ppss0, address9_ppss0, address10_ppss0, address11_ppss0, address12_ppss0, address13_ppss0, address14_ppss0, address15_ppss0,address16_ppss0;
  
logic [12:0] address0_ppss1, address1_ppss1, address2_ppss1, address3_ppss1, address4_ppss1, address5_ppss1, address6_ppss1, address7_ppss1, address8_ppss1,
 address9_ppss1, address10_ppss1, address11_ppss1, address12_ppss1, address13_ppss1, address14_ppss1, address15_ppss1,address16_ppss1;
 
logic [12:0] address0_ppk0, address1_ppk0, address2_ppk0, address3_ppk0, address4_ppk0, address5_ppk0, address6_ppk0, address7_ppk0, address8_ppk0, address9_ppk0, 
address10_ppk0, address11_ppk0, address12_ppk0, address13_ppk0, address14_ppk0, address15_ppk0, address16_ppk0;

logic [68:0] pps0, pps1, pps2, pps3;
  logic [68:0]ppss0,ppss1;
  logic[68:0] ppk0;
  
  

count_ones_new x10(a[0], b[0], c[0], d[0], e[0], f[0], g[0], h[0], i[0], data, count0);
  count_ones_new x11(a[1], b[1], c[1], d[1], e[1], f[1], g[1], h[1], i[1], data, count1);
  count_ones_new x12(a[2], b[2], c[2], d[2], e[2], f[2], g[2], h[2], i[2], data, count2);
  count_ones_new x13(a[3], b[3], c[3], d[3], e[3], f[3], g[3], h[3], i[3], data, count3);
  count_ones_new x14(a[4], b[4], c[4], d[4], e[4], f[4], g[4], h[4], i[4], data, count4);
  count_ones_new x15(a[5], b[5], c[5], d[5], e[5], f[5], g[5], h[5], i[5], data, count5);
  count_ones_new x16(a[6], b[6], c[6], d[6], e[6], f[6], g[6], h[6], i[6], data, count6);
  count_ones_new x17(a[7], b[7], c[7], d[7], e[7], f[7], g[7], h[7], i[7], data, count7);
  count_ones_new x18(a[8], b[8], c[8], d[8], e[8], f[8], g[8], h[8], i[8], data, count8);
  count_ones_new x19(a[9], b[9], c[9], d[9], e[9], f[9], g[9], h[9], i[9], data, count9);
  count_ones_new x20(a[10], b[10], c[10], d[10], e[10], f[10], g[10], h[10], i[10], data, count10);
  count_ones_new x21(a[11], b[11], c[11], d[11], e[11], f[11], g[11], h[11], i[11], data, count11);
  count_ones_new x22(a[12], b[12], c[12], d[12], e[12], f[12], g[12], h[12], i[12], data, count12);
  count_ones_new x23(a[13], b[13], c[13], d[13], e[13], f[13], g[13], h[13], i[13], data, count13);
  count_ones_new x24(a[14], b[14], c[14], d[14], e[14], f[14], g[14], h[14], i[14], data, count14);
  count_ones_new x25(a[15], b[15], c[15], d[15], e[15], f[15], g[15], h[15], i[15], data, count15);
  count_ones_new x26(a[16], b[16], c[16], d[16], e[16], f[16], g[16], h[16], i[16], data, count16);
  count_ones_new x27(a[17], b[17], c[17], d[17], e[17], f[17], g[17], h[17], i[17], data, count17);
  count_ones_new x28(a[18], b[18], c[18], d[18], e[18], f[18], g[18], h[18], i[18], data, count18);
  count_ones_new x29(a[19], b[19], c[19], d[19], e[19], f[19], g[19], h[19], i[19], data, count19);
  count_ones_new x30(a[20], b[20], c[20], d[20], e[20], f[20], g[20], h[20], i[20], data, count20);
  count_ones_new x31(a[21], b[21], c[21], d[21], e[21], f[21], g[21], h[21], i[21], data, count21);
  count_ones_new x32(a[22], b[22], c[22], d[22], e[22], f[22], g[22], h[22], i[22], data, count22);
  count_ones_new x33(a[23], b[23], c[23], d[23], e[23], f[23], g[23], h[23], i[23], data, count23);
  count_ones_new x34(a[24], b[24], c[24], d[24], e[24], f[24], g[24], h[24], i[24], data, count24);
  count_ones_new x35(a[25], b[25], c[25], d[25], e[25], f[25], g[25], h[25], i[25], data, count25);
  count_ones_new x36(a[26], b[26], c[26], d[26], e[26], f[26], g[26], h[26], i[26], data, count26);
  count_ones_new x37(a[27], b[27], c[27], d[27], e[27], f[27], g[27], h[27], i[27], data, count27);
  count_ones_new x38(a[28], b[28], c[28], d[28], e[28], f[28], g[28], h[28], i[28], data, count28);
  count_ones_new x39(a[29], b[29], c[29], d[29], e[29], f[29], g[29], h[29], i[29], data, count29);
  count_ones_new x40(a[30], b[30], c[30], d[30], e[30], f[30], g[30], h[30], i[30], data, count30);
  count_ones_new x41(a[31], b[31], c[31], d[31], e[31], f[31], g[31], h[31], i[31], data, count31);
  count_ones_new x42(a[32], b[32], c[32], d[32], e[32], f[32], g[32], h[32], i[32], data, count32);
  count_ones_new x43(a[33], b[33], c[33], d[33], e[33], f[33], g[33], h[33], i[33], data, count33);
  count_ones_new x44(a[34], b[34], c[34], d[34], e[34], f[34], g[34], h[34], i[34], data, count34);
  count_ones_new x45(a[35], b[35], c[35], d[35], e[35], f[35], g[35], h[35], i[35], data, count35);
  count_ones_new x46(a[36], b[36], c[36], d[36], e[36], f[36], g[36], h[36], i[36], data, count36);
  count_ones_new x47(a[37], b[37], c[37], d[37], e[37], f[37], g[37], h[37], i[37], data, count37);
  count_ones_new x48(a[38], b[38], c[38], d[38], e[38], f[38], g[38], h[38], i[38], data, count38);
  count_ones_new x49(a[39], b[39], c[39], d[39], e[39], f[39], g[39], h[39], i[39], data, count39);
  count_ones_new x50(a[40], b[40], c[40], d[40], e[40], f[40], g[40], h[40], i[40], data, count40);
  count_ones_new x51(a[41], b[41], c[41], d[41], e[41], f[41], g[41], h[41], i[41], data, count41);
  count_ones_new x52(a[42], b[42], c[42], d[42], e[42], f[42], g[42], h[42], i[42], data, count42);
  count_ones_new x53(a[43], b[43], c[43], d[43], e[43], f[43], g[43], h[43], i[43], data, count43);
  count_ones_new x54(a[44], b[44], c[44], d[44], e[44], f[44], g[44], h[44], i[44], data, count44);
  count_ones_new x55(a[45], b[45], c[45], d[45], e[45], f[45], g[45], h[45], i[45], data, count45);
  count_ones_new x56(a[46], b[46], c[46], d[46], e[46], f[46], g[46], h[46], i[46], data, count46);
  count_ones_new x57(a[47], b[47], c[47], d[47], e[47], f[47], g[47], h[47], i[47], data, count47);
  count_ones_new x58(a[48], b[48], c[48], d[48], e[48], f[48], g[48], h[48], i[48], data, count48);
  count_ones_new x59(a[49], b[49], c[49], d[49], e[49], f[49], g[49], h[49], i[49], data, count49);
  count_ones_new x60(a[50], b[50], c[50], d[50], e[50], f[50], g[50], h[50], i[50], data, count50);
  count_ones_new x61(a[51], b[51], c[51], d[51], e[51], f[51], g[51], h[51], i[51], data, count51);
  count_ones_new x62(a[52], b[52], c[52], d[52], e[52], f[52], g[52], h[52], i[52], data, count52);
  count_ones_new x63(a[53], b[53], c[53], d[53], e[53], f[53], g[53], h[53], i[53], data, count53);
  count_ones_new x64(a[54], b[54], c[54], d[54], e[54], f[54], g[54], h[54], i[54], data, count54);
  count_ones_new x65(a[55], b[55], c[55], d[55], e[55], f[55], g[55], h[55], i[55], data, count55);
  count_ones_new x66(a[56], b[56], c[56], d[56], e[56], f[56], g[56], h[56], i[56], data, count56);
  count_ones_new x67(a[57], b[57], c[57], d[57], e[57], f[57], g[57], h[57], i[57], data, count57);
  count_ones_new x68(a[58], b[58], c[58], d[58], e[58], f[58], g[58], h[58], i[58], data, count58);
  count_ones_new x69(a[59], b[59], c[59], d[59], e[59], f[59], g[59], h[59], i[59], data, count59);
  count_ones_new x70(a[60], b[60], c[60], d[60], e[60], f[60], g[60], h[60], i[60], data, count60);
  count_ones_new x71(a[61], b[61], c[61], d[61], e[61], f[61], g[61], h[61], i[61], data, count61);
  count_ones_new x72(a[62], b[62], c[62], d[62], e[62], f[62], g[62], h[62], i[62], data, count62);
  count_ones_new x73(a[63], b[63], c[63], d[63], e[63], f[63], g[63], h[63], i[63], data, count63);

 

//count_ones x(a,b,c,d,e,f,g,h,i,j,count0,count1,count2,count3);   
assign pps0 = {count63[0], count62[0], count61[0], count60[0], count59[0], count58[0], count57[0], count56[0], count55[0], count54[0], count53[0], count52[0], count51[0], count50[0], count49[0], count48[0], count47[0], count46[0], count45[0], count44[0], count43[0], count42[0], count41[0], count40[0], count39[0], count38[0], count37[0], count36[0], count35[0], count34[0], count33[0], count32[0], count31[0], count30[0], count29[0], count28[0], count27[0], count26[0], count25[0], count24[0], count23[0], count22[0], count21[0], count20[0], count19[0], count18[0], count17[0], count16[0], count15[0], count14[0], count13[0], count12[0], count11[0], count10[0], count9[0], count8[0], count7[0], count6[0], count5[0], count4[0], count3[0], count2[0], count1[0], count0[0]};
assign pps1 = {count63[1], count62[1], count61[1], count60[1], count59[1], count58[1], count57[1], count56[1], count55[1], count54[1], count53[1], count52[1], count51[1], count50[1], count49[1], count48[1], count47[1], count46[1], count45[1], count44[1], count43[1], count42[1], count41[1], count40[1], count39[1], count38[1], count37[1], count36[1], count35[1], count34[1], count33[1], count32[1], count31[1], count30[1], count29[1], count28[1], count27[1], count26[1], count25[1], count24[1], count23[1], count22[1], count21[1], count20[1], count19[1], count18[1], count17[1], count16[1], count15[1], count14[1], count13[1], count12[1], count11[1], count10[1], count9[1], count8[1], count7[1], count6[1], count5[1], count4[1], count3[1], count2[1], count1[1], count0[1], 1'b0};
assign pps2 = {count63[2], count62[2], count61[2], count60[2], count59[2], count58[2], count57[2], count56[2], count55[2], count54[2], count53[2], count52[2], count51[2], count50[2], count49[2], count48[2], count47[2], count46[2], count45[2], count44[2], count43[2], count42[2], count41[2], count40[2], count39[2], count38[2], count37[2], count36[2], count35[2], count34[2], count33[2], count32[2], count31[2], count30[2], count29[2], count28[2], count27[2], count26[2], count25[2], count24[2], count23[2], count22[2], count21[2], count20[2], count19[2], count18[2], count17[2], count16[2], count15[2], count14[2], count13[2], count12[2], count11[2], count10[2], count9[2], count8[2], count7[2], count6[2], count5[2], count4[2], count3[2], count2[2], count1[2], count0[2], 1'b0, 1'b0};
assign pps3 = {count63[3], count62[3], count61[3], count60[3], count59[3], count58[3], count57[3], count56[3], count55[3], count54[3], count53[3], count52[3], count51[3], count50[3], count49[3], count48[3], count47[3], count46[3], count45[3], count44[3], count43[3], count42[3], count41[3], count40[3], count39[3], count38[3], count37[3], count36[3], count35[3], count34[3], count33[3], count32[3], count31[3], count30[3], count29[3], count28[3], count27[3], count26[3], count25[3], count24[3], count23[3], count22[3], count21[3], count20[3], count19[3], count18[3], count17[3], count16[3], count15[3], count14[3], count13[3], count12[3], count11[3], count10[3], count9[3], count8[3], count7[3], count6[3], count5[3], count4[3], count3[3], count2[3], count1[3], count0[3], 1'b0, 1'b0, 1'b0};

      logic [12:0] address, address1, address2, address3, address4;
      
      
      
      /////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////////////////////////////////////////////
            
            
            
      assign zero = 4'b0000;
      adder_4bit_LSB mod_0 (
          .clk(clk),
          .write_en(write_en),
          .a(pps0[3:0]),
          .b(pps1[3:0]),
          .c(zero),
          .data(data),
          .sum(sum0_ppss0),
          .carry(carry0_ppss0),
          .address(address0_ppss0),
          .result_LSB_flag(result_LSB_flag0_ppss0)
      );
      
      adder_4bit_MSB mod_1 (
          .clk(clk),
          .write_en(write_en),
          .a(pps0[7:4]),
          .b(pps1[7:4]),
          .c(zero),
          .carryin(carry0_ppss0),
          .data(data),
          .sum(sum1_ppss0),
          .carryout(carry1_ppss0),
          .address(address1_ppss0),
          .result_MSB_flag(result_MSB_flag1_ppss0)
      );
      
       adder_4bit_MSB mod_2 (
             .clk(clk),
             .write_en(write_en),
             .a(pps0[11:8]),
             .b(pps1[11:8]),
             .c(zero),
              .carryin(carry1_ppss0),
                .data(data),
                .sum(sum2_ppss0),
                .carryout(carry2_ppss0),
                .address(address2_ppss0),
                .result_MSB_flag(result_MSB_flag2_ppss0)
            );
            
      adder_4bit_MSB mod_3 (
                .clk(clk),
                .write_en(write_en),
                .a(pps0[15:12]),
                .b(pps1[15:12]),
                .c(zero),
                .carryin(carry2_ppss0),
                .data(data),
                .sum(sum3_ppss0),
                .carryout(carry3_ppss0),
                .address(address3_ppss0),
                .result_MSB_flag(result_MSB_flag3_ppss0)
            );
                  
 
       adder_4bit_MSB mod_4 (
                      .clk(clk),
                      .write_en(write_en),
                      .a(pps0[19:16]),
                      .b(pps1[19:16]),
                      .c(zero),
                      .carryin(carry3_ppss0),
                      .data(data),
                      .sum(sum4_ppss0),
                      .carryout(carry4_ppss0),
                      .address(address4_ppss0),
                      .result_MSB_flag(result_MSB_flag4_ppss0)
                  );
                  
                  
       adder_4bit_MSB mod_5(
                                 .clk(clk),
                                 .write_en(write_en),
                                 .a(pps0[23:20]),
                                 .b(pps1[23:20]),
                                 .c(zero),
                                 .carryin(carry4_ppss0),
                                 .data(data),
                                 .sum(sum5_ppss0),
                                 .carryout(carry5_ppss0),
                                 .address(address5_ppss0),
                                 .result_MSB_flag(result_MSB_flag5_ppss0)
                             ); 
                             
      adder_4bit_MSB mod_6(
                        .clk(clk),
                        .write_en(write_en),
                        .a(pps0[27:24]),
                        .b(pps1[27:24]),
                        .c(zero),
                        .carryin(carry5_ppss0),
                        .data(data),
                        .sum(sum6_ppss0),
                        .carryout(carry6_ppss0),
                        .address(address6_ppss0),
                       .result_MSB_flag(result_MSB_flag6_ppss0)
 );                                               
                
      adder_4bit_MSB mod_7(
                    .clk(clk),
                    .write_en(write_en),
                    .a(pps0[31:28]),
                    .b(pps1[31:28]),
                    .c(zero),
                    .carryin(carry6_ppss0),
                    .data(data),
                    .sum(sum7_ppss0),
                    .carryout(carry7_ppss0),
                    .address(address7_ppss0),
                   .result_MSB_flag(result_MSB_flag7_ppss0)
);                                               
            
      adder_4bit_MSB mod_8(
              .clk(clk),
              .write_en(write_en),
              .a(pps0[35:32]),
              .b(pps1[35:32]),
              .c(zero),
              .carryin(carry7_ppss0),
              .data(data),
              .sum(sum8_ppss0),
              .carryout(carry8_ppss0),
              .address(address8_ppss0),
             .result_MSB_flag(result_MSB_flag8_ppss0)
);                                               

      adder_4bit_MSB mod_9(
              .clk(clk),
              .write_en(write_en),
              .a(pps0[39:36]),
              .b(pps1[39:36]),
              .c(zero),
              .carryin(carry8_ppss0),
              .data(data),
              .sum(sum9_ppss0),
              .carryout(carry9_ppss0),
              .address(address9_ppss0),
             .result_MSB_flag(result_MSB_flag9_ppss0)
);                                               
              
      adder_4bit_MSB mod_10(
              .clk(clk),
              .write_en(write_en),
              .a(pps0[43:40]),
              .b(pps1[43:40]),
              .c(zero),
              .carryin(carry9_ppss0),
              .data(data),
              .sum(sum10_ppss0),
              .carryout(carry10_ppss0),
              .address(address10_ppss0),
             .result_MSB_flag(result_MSB_flag10_ppss0)
);                                               
              
      adder_4bit_MSB mod_11(
              .clk(clk),
              .write_en(write_en),
              .a(pps0[47:44]),
              .b(pps1[47:44]),
              .c(zero),
              .carryin(carry10_ppss0),
              .data(data),
              .sum(sum11_ppss0),
              .carryout(carry11_ppss0),
              .address(address11_ppss0),
             .result_MSB_flag(result_MSB_flag11_ppss0)
);                                               
              
      adder_4bit_MSB mod_12(
              .clk(clk),
              .write_en(write_en),
              .a(pps0[51:48]),
              .b(pps1[51:48]),
              .c(zero),
              .carryin(carry11_ppss0),
              .data(data),
              .sum(sum12_ppss0),
              .carryout(carry12_ppss0),
              .address(address12_ppss0),
             .result_MSB_flag(result_MSB_flag12_ppss0)
);                                               
              
      adder_4bit_MSB mod_13(
              .clk(clk),
              .write_en(write_en),
              .a(pps0[55:52]),
              .b(pps1[55:52]),
              .c(zero),
              .carryin(carry12_ppss0),
              .data(data),
              .sum(sum13_ppss0),
              .carryout(carry13_ppss0),
              .address(address13_ppss0),
             .result_MSB_flag(result_MSB_flag13_ppss0)
);                                               
              
      adder_4bit_MSB mod_14(
              .clk(clk),
              .write_en(write_en),
              .a(pps0[59:56]),
              .b(pps1[59:56]),
              .c(zero),
              .carryin(carry13_ppss0),
              .data(data),
              .sum(sum14_ppss0),
              .carryout(carry14_ppss0),
              .address(address14_ppss0),
             .result_MSB_flag(result_MSB_flag14_ppss0)
);                                               
              
      adder_4bit_MSB mod_15(
              .clk(clk),
              .write_en(write_en),
              .a(pps0[63:60]),
              .b(pps1[63:60]),
              .c(zero),
              .carryin(carry14_ppss0),
              .data(data),
              .sum(sum15_ppss0),
              .carryout(carry15_ppss0),
              .address(address15_ppss0),
             .result_MSB_flag(result_MSB_flag15_ppss0)
);

adder_4bit_MSB mod_16(
      .clk(clk),
      .write_en(write_en),
      .a(pps0[67:64]),
      .b(pps1[67:64]),
      .c(zero),
      .carryin(carry15_ppss0),
      .data(data),
      .sum(sum16_ppss0),
      .carryout(carry16_ppss0),
      .address(address16_ppss0),
     .result_MSB_flag(result_MSB_flag16_ppss0)
);


assign ppss0 = { 
    sum16_ppss0[4:0],
    sum15_ppss0[3:0], 
    sum14_ppss0[3:0], 
    sum13_ppss0[3:0], 
    sum12_ppss0[3:0], 
    sum11_ppss0[3:0], 
    sum10_ppss0[3:0], 
    sum9_ppss0[3:0], 
    sum8_ppss0[3:0], 
    sum7_ppss0[3:0], 
    sum6_ppss0[3:0], 
    sum5_ppss0[3:0], 
    sum4_ppss0[3:0], 
    sum3_ppss0[3:0], 
    sum2_ppss0[3:0], 
    sum1_ppss0[3:0], 
    sum0_ppss0[3:0]
};
       
      /////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////////////////////////////
            ////////////////////////////////////////////////////////////////////////////////////// 
            /////////////////////////////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////////////////////////////////////////////
            /////////////////////////////////////////////////////////////////////////////////////////
                  //////////////////////////////////////////////////////////////////////////////////////
       adder_4bit_LSB mod_00 (
    .clk(clk),
    .write_en(write_en),
    .a(pps2[3:0]),
    .b(pps3[3:0]),
    .c(zero),
    .data(data),
    .sum(sum0_ppss1),
    .carry(carry0_ppss1),
    .address(address0_ppss1),
    .result_LSB_flag(result_LSB_flag0_ppss1)
);

adder_4bit_MSB mod_d11 (
    .clk(clk),
    .write_en(write_en),
    .a(pps2[7:4]),
    .b(pps3[7:4]),
    .c(zero),
    .carryin(carry0_ppss1),
    .data(data),
    .sum(sum1_ppss1),
    .carryout(carry1_ppss1),
    .address(address1_ppss1),
    .result_MSB_flag(result_MSB_flag1_ppss1)
);

 adder_4bit_MSB mod_22 (
       .clk(clk),
       .write_en(write_en),
       .a(pps2[11:8]),
       .b(pps3[11:8]),
       .c(zero),
        .carryin(carry1_ppss1),
          .data(data),
          .sum(sum2_ppss1),
          .carryout(carry2_ppss1),
          .address(address2_ppss1),
          .result_MSB_flag(result_MSB_flag2_ppss1)
      );
      
adder_4bit_MSB mod_33 (
          .clk(clk),
          .write_en(write_en),
          .a(pps2[15:12]),
          .b(pps3[15:12]),
          .c(zero),
          .carryin(carry2_ppss1),
          .data(data),
          .sum(sum3_ppss1),
          .carryout(carry3_ppss1),
          .address(address3_ppss1),
          .result_MSB_flag(result_MSB_flag3_ppss1)
      );
            

 adder_4bit_MSB mod_44 (
                .clk(clk),
                .write_en(write_en),
                .a(pps2[19:16]),
                .b(pps3[19:16]),
                .c(zero),
                .carryin(carry3_ppss1),
                .data(data),
                .sum(sum4_ppss1),
                .carryout(carry4_ppss1),
                .address(address4_ppss1),
                .result_MSB_flag(result_MSB_flag4_ppss1)
            );
            
            
 adder_4bit_MSB mod_55(
                           .clk(clk),
                           .write_en(write_en),
                           .a(pps2[23:20]),
                           .b(pps3[23:20]),
                           .c(zero),
                           .carryin(carry4_ppss1),
                           .data(data),
                           .sum(sum5_ppss1),
                           .carryout(carry5_ppss1),
                           .address(address5_ppss1),
                           .result_MSB_flag(result_MSB_flag5_ppss1)
                       ); 
                       
adder_4bit_MSB mod_66(
                  .clk(clk),
                  .write_en(write_en),
                  .a(pps2[27:24]),
                  .b(pps3[27:24]),
                  .c(zero),
                  .carryin(carry5_ppss1),
                  .data(data),
                  .sum(sum6_ppss1),
                  .carryout(carry6_ppss1),
                  .address(address6_ppss1),
                 .result_MSB_flag(result_MSB_flag6_ppss1)
);                                               
          
adder_4bit_MSB mod_77(
              .clk(clk),
              .write_en(write_en),
              .a(pps2[31:28]),
              .b(pps3[31:28]),
              .c(zero),
              .carryin(carry6_ppss1),
              .data(data),
              .sum(sum7_ppss1),
              .carryout(carry7_ppss1),
              .address(address7_ppss1),
             .result_MSB_flag(result_MSB_flag7_ppss1)
);                                               
    
adder_4bit_MSB mod_88(
        .clk(clk),
        .write_en(write_en),
        .a(pps2[35:32]),
        .b(pps3[35:32]),
        .c(zero),
        .carryin(carry7_ppss1),
        .data(data),
        .sum(sum8_ppss1),
        .carryout(carry8_ppss1),
        .address(address8_ppss1),
       .result_MSB_flag(result_MSB_flag8_ppss1)
); 
 
      adder_4bit_MSB mod_99(
      .clk(clk),
      .write_en(write_en),
      .a(pps2[39:36]),
      .b(pps3[39:36]),
      .c(zero),
      .carryin(carry8_ppss1),
      .data(data),
      .sum(sum9_ppss1),
      .carryout(carry9_ppss1),
      .address(address9_ppss1),
     .result_MSB_flag(result_MSB_flag9_ppss1)
);                                               
        
adder_4bit_MSB mod_1010(
      .clk(clk),
      .write_en(write_en),
      .a(pps2[43:40]),
      .b(pps3[43:40]),
      .c(zero),
      .carryin(carry9_ppss1),
      .data(data),
      .sum(sum10_ppss1),
      .carryout(carry10_ppss1),
      .address(address10_ppss1),
     .result_MSB_flag(result_MSB_flag10_ppss1)
);                                               
        
adder_4bit_MSB mod_1111(
      .clk(clk),
      .write_en(write_en),
      .a(pps2[47:44]),
      .b(pps3[47:44]),
      .c(zero),
      .carryin(carry10_ppss1),
      .data(data),
      .sum(sum11_ppss1),
      .carryout(carry11_ppss1),
      .address(address11_ppss1),
     .result_MSB_flag(result_MSB_flag11_ppss1)
);                                               
        
adder_4bit_MSB mod_1212(
      .clk(clk),
      .write_en(write_en),
      .a(pps2[51:48]),
      .b(pps3[51:48]),
      .c(zero),
      .carryin(carry11_ppss1),
      .data(data),
      .sum(sum12_ppss1),
      .carryout(carry12_ppss1),
      .address(address12_ppss1),
     .result_MSB_flag(result_MSB_flag12_ppss1)
);                                               
        
adder_4bit_MSB mod_1313(
      .clk(clk),
      .write_en(write_en),
      .a(pps2[55:52]),
      .b(pps3[55:52]),
      .c(zero),
      .carryin(carry12_ppss1),
      .data(data),
      .sum(sum13_ppss1),
      .carryout(carry13_ppss1),
      .address(address13_ppss1),
     .result_MSB_flag(result_MSB_flag13_ppss1)
);                                               
        
adder_4bit_MSB mod_1414(
      .clk(clk),
      .write_en(write_en),
      .a(pps2[59:56]),
      .b(pps3[59:56]),
      .c(zero),
      .carryin(carry13_ppss1),
      .data(data),
      .sum(sum14_ppss1),
      .carryout(carry14_ppss1),
      .address(address14_ppss1),
     .result_MSB_flag(result_MSB_flag14_ppss1)
);                                               
        
adder_4bit_MSB mod_1515(
      .clk(clk),
      .write_en(write_en),
      .a(pps2[63:60]),
      .b(pps3[63:60]),
      .c(zero),
      .carryin(carry14_ppss1),
      .data(data),
      .sum(sum15_ppss1),
      .carryout(carry15_ppss1),
      .address(address15_ppss1),
     .result_MSB_flag(result_MSB_flag15_ppss1)
);

adder_4bit_MSB mod_1616(
      .clk(clk),
      .write_en(write_en),
      .a(pps2[67:64]),
      .b(pps3[67:64]),
      .c(zero),
      .carryin(carry15_ppss1),
      .data(data),
      .sum(sum16_ppss1),
      .carryout(carry16_ppss1),
      .address(address16_ppss1),
     .result_MSB_flag(result_MSB_flag16_ppss1)
);

assign ppss1 = { 
    sum16_ppss1[4:0],
    sum15_ppss1[3:0], 
    sum14_ppss1[3:0], 
    sum13_ppss1[3:0], 
    sum12_ppss1[3:0], 
    sum11_ppss1[3:0], 
    sum10_ppss1[3:0], 
    sum9_ppss1[3:0], 
    sum8_ppss1[3:0], 
    sum7_ppss1[3:0], 
    sum6_ppss1[3:0], 
    sum5_ppss1[3:0], 
    sum4_ppss1[3:0], 
    sum3_ppss1[3:0], 
    sum2_ppss1[3:0], 
    sum1_ppss1[3:0], 
    sum0_ppss1[3:0]
};
       

      
      /////////////////////////////////////////////////////////////////////////////////////////
      //////////////////////////////////////////////////////////////////////////////////////
      /////////////////////////////////////////////////////////////////////////////////////////
            //////////////////////////////////////////////////////////////////////////////////////
  

       adder_4bit_LSB mod_000 (
    .clk(clk),
    .write_en(write_en),
    .a(ppss0[3:0]),
    .b(ppss1[3:0]),
    .c(zero),
    .data(data),
    .sum(sum0_ppk0),
    .carry(carry0_ppk0),
    .address(address0_ppk0),
    .result_LSB_flag(result_LSB_flag0_ppk0)
);

adder_4bit_MSB mod_111 (
    .clk(clk),
    .write_en(write_en),
    .a(ppss0[7:4]),
    .b(ppss1[7:4]),
    .c(zero),
    .carryin(carry0_ppk0),
    .data(data),
    .sum(sum1_ppk0),
    .carryout(carry1_ppk0),
    .address(address1_ppk0),
    .result_MSB_flag(result_MSB_flag1_ppk0)
);

 adder_4bit_MSB mod_222 (
       .clk(clk),
       .write_en(write_en),
       .a(ppss0[11:8]),
       .b(ppss1[11:8]),
       .c(zero),
        .carryin(carry1_ppk0),
          .data(data),
          .sum(sum2_ppk0),
          .carryout(carry2_ppk0),
          .address(address2_ppk0),
          .result_MSB_flag(result_MSB_flag2_ppk0)
      );
      
adder_4bit_MSB mod_333 (
          .clk(clk),
          .write_en(write_en),
          .a(ppss0[15:12]),
          .b(ppss1[15:12]),
          .c(zero),
          .carryin(carry2_ppk0),
          .data(data),
          .sum(sum3_ppk0),
          .carryout(carry3_ppk0),
          .address(address3_ppk0),
          .result_MSB_flag(result_MSB_flag3_ppk0)
      );
            

 adder_4bit_MSB mod_444 (
                .clk(clk),
                .write_en(write_en),
                .a(ppss0[19:16]),
                .b(ppss1[19:16]),
                .c(zero),
                .carryin(carry3_ppk0),
                .data(data),
                .sum(sum4_ppk0),
                .carryout(carry4_ppk0),
                .address(address4_ppk0),
                .result_MSB_flag(result_MSB_flag4_ppk0)
            );
            
            
 adder_4bit_MSB mod_555(
                           .clk(clk),
                           .write_en(write_en),
                           .a(ppss0[23:20]),
                           .b(ppss1[23:20]),
                           .c(zero),
                           .carryin(carry4_ppk0),
                           .data(data),
                           .sum(sum5_ppk0),
                           .carryout(carry5_ppk0),
                           .address(address5_ppk0),
                           .result_MSB_flag(result_MSB_flag5_ppk0)
                       ); 
                       
adder_4bit_MSB mod_666(
                  .clk(clk),
                  .write_en(write_en),
                  .a(ppss0[27:24]),
                  .b(ppss1[27:24]),
                  .c(zero),
                  .carryin(carry5_ppk0),
                  .data(data),
                  .sum(sum6_ppk0),
                  .carryout(carry6_ppk0),
                  .address(address6_ppk0),
                 .result_MSB_flag(result_MSB_flag6_ppk0)
);                                               
          
adder_4bit_MSB mod_777(
              .clk(clk),
              .write_en(write_en),
              .a(ppss0[31:28]),
              .b(ppss1[31:28]),
              .c(zero),
              .carryin(carry6_ppk0),
              .data(data),
              .sum(sum7_ppk0),
              .carryout(carry7_ppk0),
              .address(address7_ppk0),
             .result_MSB_flag(result_MSB_flag7_ppk0)
);                                               
      
adder_4bit_MSB mod_888(
        .clk(clk),
        .write_en(write_en),
        .a(ppss0[35:32]),
        .b(ppss1[35:32]),
        .c(zero),
        .carryin(carry7_ppk0),
        .data(data),
        .sum(sum8_ppk0),
        .carryout(carry8_ppk0),
        .address(address8_ppk0),
       .result_MSB_flag(result_MSB_flag8_ppk0)
); 


/*
adder_4bit_MSB mod_999(
        .clk(clk),
        .write_en(write_en),
        .a(ppss0[37:36]),
        .b(ppss1[37:36]),
        .c(zero),
        .carryin(carry8_ppk0),
        .data(data),
        .sum(sum9_ppk0),
        .carryout(carry9_ppk0),
        .address(address9_ppk0),
       .result_MSB_flag(result_MSB_flag9_ppk0)
); 

*/ 


      adder_4bit_MSB mod_999(
            .clk(clk),
            .write_en(write_en),
            .a(ppss0[39:36]),
            .b(ppss1[39:36]),
            .c(zero),
            .carryin(carry8_ppk0),
            .data(data),
            .sum(sum9_ppk0),
            .carryout(carry9_ppk0),
            .address(address9_ppk0),
           .result_MSB_flag(result_MSB_flag9_ppk0)
);                                               
              
      adder_4bit_MSB mod_101010(
            .clk(clk),
            .write_en(write_en),
            .a(ppss0[43:40]),
            .b(ppss1[43:40]),
            .c(zero),
            .carryin(carry9_ppk0),
            .data(data),
            .sum(sum10_ppk0),
            .carryout(carry10_ppk0),
            .address(address10_ppk0),
           .result_MSB_flag(result_MSB_flag10_ppk0)
);                                               
              
      adder_4bit_MSB mod_111111(
            .clk(clk),
            .write_en(write_en),
            .a(ppss0[47:44]),
            .b(ppss1[47:44]),
            .c(zero),
            .carryin(carry10_ppk0),
            .data(data),
            .sum(sum11_ppk0),
            .carryout(carry11_ppk0),
            .address(address11_ppk0),
           .result_MSB_flag(result_MSB_flag11_ppk0)
);                                               
              
      adder_4bit_MSB mod_121212(
            .clk(clk),
            .write_en(write_en),
            .a(ppss0[51:48]),
            .b(ppss1[51:48]),
            .c(zero),
            .carryin(carry11_ppk0),
            .data(data),
            .sum(sum12_ppk0),
            .carryout(carry12_ppk0),
            .address(address12_ppk0),
           .result_MSB_flag(result_MSB_flag12_ppk0)
);                                               
              
      adder_4bit_MSB mod_131313(
            .clk(clk),
            .write_en(write_en),
            .a(ppss0[55:52]),
            .b(ppss1[55:52]),
            .c(zero),
            .carryin(carry12_ppk0),
            .data(data),
            .sum(sum13_ppk0),
            .carryout(carry13_ppk0),
            .address(address13_ppk0),
           .result_MSB_flag(result_MSB_flag13_ppk0)
);                                               
              
      adder_4bit_MSB mod_141414(
            .clk(clk),
            .write_en(write_en),
            .a(ppss0[59:56]),
            .b(ppss1[59:56]),
            .c(zero),
            .carryin(carry13_ppk0),
            .data(data),
            .sum(sum14_ppk0),
            .carryout(carry14_ppk0),
            .address(address14_ppk0),
           .result_MSB_flag(result_MSB_flag14_ppk0)
);                                               
              
      adder_4bit_MSB mod_151515(
            .clk(clk),
            .write_en(write_en),
            .a(ppss0[63:60]),
            .b(ppss1[63:60]),
            .c(zero),
            .carryin(carry14_ppk0),
            .data(data),
            .sum(sum15_ppk0),
            .carryout(carry15_ppk0),
            .address(address15_ppk0),
           .result_MSB_flag(result_MSB_flag15_ppk0)
);

      adder_4bit_MSB mod_161616(
            .clk(clk),
            .write_en(write_en),
            .a(ppss0[67:64]),
            .b(ppss1[67:64]),
            .c(zero),
            .carryin(carry15_ppk0),
            .data(data),
            .sum(sum16_ppk0),
            .carryout(carry16_ppk0),
            .address(address16_ppk0),
           .result_MSB_flag(result_MSB_flag16_ppk0)
); 

//assign ppk0 = {sum8_ppk0[4:0], sum7_ppk0[3:0], sum6_ppk0[3:0], sum5_ppk0[3:0], sum4_ppk0[3:0], sum3_ppk0[3:0], sum2_ppk0[3:0], sum1_ppk0[3:0], sum0_ppk0[3:0]};
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
       
 
 
 
 
 
  //assign sum = pps0+pps1+pps2+pps3;
//assign sum =ppss1+ppss0;
assign sum =ppk0;
//assign sum = sumLSB;
  assign carry = sum16_ppk0[4];  

    
endmodule
