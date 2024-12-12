`timescale 1ns / 1ps

parameter CAM_WIDTH = 4;  // 16-bit adder
parameter NUM_CELL = 8; 


/*
data[0] = 3'b000;
data[1] = 3'b001;


*/
//seems no chnages requried no change in data
 module adder2bit(
  input logic [1:0] a, b,c,
  input logic [2:0] data [31:0],
  output logic [3:0] sum
);
logic [3:0] sum_actual;
  logic data_flag;
  logic match_flag_0, match_flag_1,match_flag_2,match_flag_3;
  logic [1:0] add [7:0]; // Adjusted the width of `add`
  logic [2:0] addr_0, addr_1,addr_2,addr_3;
  int m, n, i,o,p;
   assign sum_actual = a+b+c;
  // Populate the `add` array from the input `data`
  always_comb begin 
    for (i = 0; i < 32; i++) begin
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

// no changes requried no change in data
module bit4_cam_adder_v2 (
  input bit clk,
  input logic write_en,
  input logic [3:0] a, b, c,
  input logic [2:0] data [31:0],
  output logic [6:0] sum, actual_sum,
  output logic [12:0] address
);

  logic [1:0] cam_mem [7:0]; // CAM cell 
  logic [3:0] carry_out;
  logic [3:0] cam_out;
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
      for (i = 0; i < 8; i++) begin
        cam_mem[i] = data[i];
      end
      data_flag = 1'b1;
    end 
  end
   
  always_ff @(posedge clk) begin 
    if ( data_flag) begin 
      match_flag_0 = 1'b0;
      addr_0 = 3'b0;
      
      for (j = 0; j < 8; j++ ) begin  
        if ({a[0], b[0], c[0]} == j) begin
          match_flag_0 = 1'b1;
          addr_0 = j;
          break; // exit the loop once a match is found
        end
      end
    end 
  end       
    
  always_ff @(posedge clk) begin 
    if (  data_flag) begin 
      match_flag_1 = 1'b0;
      addr_1 = 3'b0;
      
      for (k = 0; k < 8; k++ ) begin  
        if ({a[1], b[1], c[1]} == k) begin
          match_flag_1 = 1'b1;
          addr_1 = k;
          break; // exit the loop once a match is found
        end
      end
    end 
  end       

  always_ff @(posedge clk) begin 
    if (  data_flag) begin 
      match_flag_2 = 1'b0;
      addr_2 = 3'b0;
      
      for (l = 0; l < 8; l++ ) begin  
        if ({a[2], b[2], c[2]} == l) begin
          match_flag_2 = 1'b1;
          addr_2 = l;
          break; // exit the loop once a match is found
        end
      end
    end 
  end   
  
  always_ff @(posedge clk) begin 
    if (  data_flag) begin 
      match_flag_3 = 1'b0;
      addr_3 = 3'b0;
      
      for (m = 0; m < 8; m++ ) begin  
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
      
      for (n = 0; n < 8; n++ ) begin  
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
      
      for (o = 0; o < 8; o++ ) begin  
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
      
      for (p = 0; p < 8; p++ ) begin  
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
      
      for (q = 0; q < 8; q++ ) begin  
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
      
      for (r = 0; r < 8; r++ ) begin  
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
      
      for (s = 0; s < 8; s++ ) begin  
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
        
        for (t = 0; t < 8; t++ ) begin  
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
            
            for (u = 0; u < 8; u++ ) begin  
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
                                 
                    for (w = 0; w < 8; w++ ) begin  
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
                                               
       for (x = 0; x < 8; x++ ) begin  
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
                                               
       for (y = 0; y < 8; y++ ) begin  
            if ({cam_mem[ppcck5][0], cam_mem[ppcck4][1]} == y) begin
                   pkk_partial_carry_5 = 1'b1;
                      ppcckk5 = y;
                       break; // exit the loop once a match is found
                         end
                       end
                   end 
               end
               
  
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


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// count ones in coloum of 7 length
//seems no chnages requried || change in data
module count_ones_sub(
input logic a,b,c,d,e,f,g,
input logic [2:0] data [31:0],
output logic [3:0] sub_out // 3 bit output 1+1+1+1+1+1= 110
    );
    
  logic [2:0] sub_out0,sub_out1,sub_out2; // 3 bit output 1+1+1+1 = 100
  logic out0_flag,out1_flag,out2_flag;
  logic [2:0] add [31:0];
  int j,k,l,u;
  logic [3:0] sub_sum;
  logic data_flag;
  logic [3:0] sub_out_actual;
  assign sub_out_actual = a+b+c+d+e+f+g;
  
  
    always_comb begin 
    for (u = 0; u< 32; u++) begin
      add[u] = data[u];  // Only assign the lower 2 bits to `add`
    end
    data_flag = 1'b1;
  end

always_comb begin 
sub_out0 = 2'b0;
out0_flag = 1'b0;
if (data_flag) begin
  for(l=0; l<8;l++) begin
    if({a,b,c} == l[2:0]) begin
      sub_out0 = add[l[2:0]]; // add[1111]
out0_flag = 1'b1;
  break;
end
end
end
end


always_comb begin
sub_out1 = 2'b0;
out1_flag = 1'b0;
if( data_flag) begin
for(j=0; j<8;j++) begin
if({d,e} == j) begin
sub_out1 = add[j[2:0]];// add[1111]
out1_flag = 1'b1;
  break;
end
end
end
end

always_comb begin
sub_out2 = 2'b0;
out2_flag = 1'b0;
if(data_flag) begin
for(k=0; k<8;k++) begin
if({f,g} == k) begin
sub_out2 = add[k[2:0]];// add[1111]
out2_flag = 1'b1;
  break;
end
end
end
end


//out0(2bit) +out1(3bit)
adder2bit x(sub_out0,sub_out1,sub_out2,add,sub_sum);

assign sub_out = sub_sum;

endmodule


///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//8 cycles
module count_ones_new(
input logic p0, p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21, p22, p23, p24, p25, p26, p27, p28, p29, p30, p31,
input logic [2:0] data [31:0],
input logic clk,
output logic [6:0] out //7 bit output becaus 32 x1  = 32 
    );
    
  logic [2:0] out0, out1, out2, out3, out4, out5, out6, out7, out8, out9, out10,out11,out12; // adding 5 single bits  = 3 bit output
  logic out0_flag, out1_flag, out2_flag, out3_flag, out4_flag, out5_flag, out6_flag, out7_flag, out8_flag, out9_flag, out10_flag,out11_flag,out12_flag;
  logic [2:0] add [31:0];
  int loop_0, loop_1, loop_2, loop_3, loop_4, loop_5, loop_6, loop_7, loop_8, loop_9, loop_10,loop_11,loop_12,loop_data;
  logic [6:0] sum;
  logic [2:0] sum0,sum1,sum2;
  logic data_flag;
   logic [6:0] actual_sum_v2;
   logic [12:0] address_v2;
  
  
  
   always_ff @(posedge clk) begin 
    for (loop_data = 0; loop_data< 32; loop_data++) begin
      add[loop_data] = data[loop_data];  // Only assign the lower 2 bits to `add`
    end
    data_flag = 1'b1;
  end

 always_ff @(posedge clk) begin
  out0 = 3'b0;
    out0_flag = 1'b0;
    if (data_flag) begin
     for(loop_0=0; loop_0<32;loop_0++) begin
        if({p0,p1,p2,p3,p4} == loop_0[4:0]) begin
     out0 = add[loop_0[4:0]];
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
     for(loop_1=0; loop_1<32;loop_1++) begin
        if({p5,p6,p7,p8,p9} == loop_1[4:0]) begin
     out1 = add[loop_1[4:0]];
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
     for(loop_2=0; loop_2<32;loop_2++) begin
        if({p10,p11,p12,p13,p14} == loop_2[4:0]) begin
     out2 = add[loop_2[4:0]];
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
     for(loop_3=0; loop_3<32;loop_3++) begin
        if({p15,p16,p17,p18,p19} == loop_3[4:0]) begin
     out3 = add[loop_3[4:0]];
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
     for(loop_4=0; loop_4<32;loop_4++) begin
        if({p20,p21,p22,p23,p24} == loop_4[4:0]) begin
     out4 = add[loop_4[4:0]];
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
     for(loop_5=0; loop_5<32;loop_5++) begin
        if({p25,p26,p27,p28,p29} == loop_5[4:0]) begin
     out5 = add[loop_5[4:0]];
      out5_flag = 1'b1;
      break;
    end
  end
  end
end
 always_ff @(posedge clk) begin
  out6 = 3'b0;
    out6_flag = 1'b0;
    if (data_flag) begin
     for(loop_6=0; loop_6<32;loop_6++) begin
        if({1'b0,1'b0,1'b0,p30,p31} == loop_6[4:0]) begin
     out6 = add[loop_6[4:0]];
      out6_flag = 1'b1;
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
    .g(out6[0]),
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
    .g(out6[1]),
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
    .g(out6[2]),
    .data(add),
    .sub_out(sum2)
);

 

  bit4_cam_adder_v2 s1(
    .clk(clk),
    .write_en(1'b1),
    .a({2'b0,sum0[2:1]}),
    .b({1'b0,sum1}),
    .c({sum2,1'b0}),
    .data(add),
    .sum(sum),
    .actual_sum(actual_sum_v2),
    .address(address_v2)
  );

assign out = {sum,sum0[0]};

endmodule