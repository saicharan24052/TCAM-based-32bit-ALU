`timescale 1ns/1ps

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



module 4bit_cam_adder_v2 (
  input bit clk,
  input logic write_en,
  input logic [4:0] a, b, c,
  input logic [1:0] data [NUM_CELL-1:0],
  output logic [7:0] sum, actual_sum,
  output logic [12:0] address
);

  logic [2:0] cam_mem [NUM_CELL-1:0]; // CAM cell 
  logic [4:0] carry_out;
  logic [4:0] cam_out;
  logic match_flag_0, match_flag_1, match_flag_2, match_flag_3;
  logic match_flag_carry_1, match_flag_carry_2, match_flag_carry_3;
  logic partial_carry_2, partial_carry_3, partial_carry_4, p_partial_carry_3, p_partial_carry_4, p_partial_carry_5,pk_partial_carry_4,pk_partial_carry_5,pkk_partial_carry_5,pkk_partial_carry_6,ppkk_partial_carry_6;
  logic data_flag, sum_flag, sum_flag_p, sum_flag_pp,sum_flag_ppck,sum_flag_ppckk,sum_flag_ppckkk; 
  int i, j, k, l, m, n, o, p, q, r, s,t,u,v,w,x,y,y1,z;
  int addr_0, addr_1, addr_2, addr_3, pp1, pp2, pp3, ppc2, ppc3, ppc4,ppcc3,ppcc4,ppcc5,ppcck4,ppcck5,ppcckk5,ppcckk6,ppcckkk6;
  logic [5:0] sum_reg;
  logic [5:0] late_0,late_1,late_2;

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
    if (!write_en && data_flag) begin 
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
    if (!write_en && data_flag) begin 
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
    if (!write_en && data_flag) begin 
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
        
        
 /*      
   always_ff @(posedge clk) begin 
                 if (sum_flag_pp) begin 
                   p_partial_carry_5 = 1'b0;
                   ppcc5 = 3'b0;
                   
                   for (v = 0; v < NUM_CELL; v++ ) begin  
                     if ({cam_mem[ppc4][1], cam_mem[ppc4][1]} == v) begin
                       p_partial_carry_5 = 1'b1;
                       ppcc5 = v;
                       break; // exit the loop once a match is found
                     end
                   end
                 end 
               end 
 
 
 */
 
 
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
 
 
      always_ff @(posedge clk) begin 
              if (sum_flag_ppck) begin 
                  pk_partial_carry_5 = 1'b0;
                       ppcck5 = 3'b0;
                                               
       for (x = 0; x < NUM_CELL; x++ ) begin  
            if ({cam_mem[ppcc4][1], cam_mem[ppc4][1]} == x) begin
                   pk_partial_carry_5 = 1'b1;
                      ppcck5 = x;
                       break; // exit the loop once a match is found
                         end
                       end
                   end 
               end 
                     
always_comb begin
       if (pk_partial_carry_5 && pk_partial_carry_4) begin
             sum_flag_ppckk = 1'b1;
                end else begin
              sum_flag_ppckk = 1'b0;
                 end
             end 
             
             

 always_ff @(posedge clk) begin 
      if (sum_flag_ppckk) begin 
           pkk_partial_carry_5 = 1'b0;
               ppcckk5 = 3'b0;
                                               
       for (y = 0; y < NUM_CELL; y++ ) begin  
            if ({cam_mem[ppcck5][0], cam_mem[ppcck4][1]} == y) begin
                   pkk_partial_carry_5 = 1'b1;
                      ppcckk5 = y;
                       break; // exit the loop once a match is found
                         end
                       end
                   end 
               end
               
/*
 always_ff @(posedge clk) begin 
         if (sum_flag_ppckk) begin 
              pkk_partial_carry_6 = 1'b0;
                  ppcckk6 = 3'b0;
                                                  
          for (y1 = 0; y1 < NUM_CELL; y1++ ) begin  
               if ({cam_mem[ppcck5][1], cam_mem[ppcc5][1]} == y1) begin
                      pkk_partial_carry_6 = 1'b1;
                         ppcckk6 = y1;
                          break; // exit the loop once a match is found
                            end
                          end
                      end 
                  end

*/             
                     
 /*
  always_comb begin
    if (pkk_partial_carry_5 && pkk_partial_carry_6) begin
   sum_flag_ppckkk = 1'b1;
    end else begin
      sum_flag_ppckkk = 1'b0;
    end
  end
  
  
  
always_ff @(posedge clk) begin 
        if (sum_flag_ppckkk) begin 
             ppkk_partial_carry_6 = 1'b0;
                 ppcckkk6 = 3'b0;
                                                 
         for (z = 0; z < NUM_CELL; z++ ) begin  
              if ({cam_mem[ppcckk6][0], cam_mem[ppcckk5][1]} == z) begin
                     ppkk_partial_carry_6 = 1'b1;
                        ppcckkk6 = z;
                         break; // exit the loop once a match is found
                           end
                         end
                     end 
                 end  
  
  
  */
  
  always_comb begin
      if (pkk_partial_carry_5) begin
        sum = {cam_mem[ppcckk5][0],cam_mem[ppcck4][0],cam_mem[ppcc3][0] , cam_mem[ppc2][0], cam_mem[pp1][0], cam_mem[addr_0][0] };
      end else begin
        sum = {6{1'bx}}; // output x if no match
      end
      address = {ppc4, ppc3, ppc2};
    end

 //assign sum_reg = a + b + c;
// ff sai(clk,rst,sum_reg,late_0);
// ff y(clk,rst,late_0,late_1);
  //ff z(clk,rst,late_1,late_2);
  assign actual_sum = a + b + c;

endmodule
