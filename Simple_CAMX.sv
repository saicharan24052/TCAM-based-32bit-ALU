module cam_simd (
  input bit clk,
  input logic write_en,
  input logic [3:0] pe_reg_L,
  input logic [3:0] pe_reg_R,
  input logic [1:0] controller, // instruction: 00 = and, 01 = or, 10 = xor, 11 = add
  input logic [3:0] data_L [7:0],
  input logic [3:0] data_R [7:0],
  input logic [3:0] data_and,
  input logic [7:0] data_or,
  input logic [11:0] data_xor,
 
  output logic [5:0] op_reg [7:0]
);

  logic [3:0] L_cam [7:0];
  logic [3:0] R_cam [7:0];
  logic  ALU_cam [11:0];
  logic data_flag_L, data_flag_R, data_flag_and, data_flag_or, data_flag_xor;
  logic match_flag_L, match_flag_R, match_flag_and, match_flag_or, match_flag_xor;
  logic [3:0]check_flag;
  logic [2:0] addr_L [7:0], addr_R [7:0];
  
  logic [2:0] addr_and [7:0];
  logic [2:0] addr_or [7:0];
  logic [3:0] addr_xor [7:0];
  
  logic [3:0] address_xor, address_or, address_and;
  logic [2:0] address_L, address_R;
  int i, j, k, l, n, j_and, j_or, j_xor, r, s, t, u,e,e1,e2;
  int a,a1,b,c;
  logic [15:0] comb;

  always_ff @(posedge clk) begin 
    if (write_en) begin
      for (j = 0; j < 8; j++) begin
        R_cam[j] = data_R[j];
      end
      data_flag_R = 1'b1;
    end 
  end 

  always_ff @(posedge clk) begin 
    if (write_en) begin
      for (i = 0; i < 8; i++) begin
        L_cam[i] = data_L[i];
      end
      data_flag_L = 1'b1;
    end
  end
  
  always_ff @(posedge clk) begin 
    if (!write_en && data_flag_L) begin 
      match_flag_L = 1'b0;
      for (k = 0; k < 8; k++) begin  
        if (L_cam[k] == pe_reg_L) begin
          addr_L[k] = k;
        end else begin
          addr_L[k] = 'bx;
        end
      end
      match_flag_L = 1'b1;
    end 
  end

  always_ff @(posedge clk) begin 
    if (!write_en && data_flag_R) begin 
      match_flag_R = 1'b0;
      for (l = 0; l < 8; l++) begin  
        if (R_cam[l] == pe_reg_R) begin
          addr_R[l] = l;
        end else begin
          addr_R[l] = 'bx;
        end
      end// for end
      match_flag_R = 1'b1;
    end // outer if
  end    //always
  
    always_ff @(posedge clk) begin   // and
    if (write_en) begin
      for (j_and = 0; j_and < 4; j_and++) begin
        ALU_cam[j_and] = data_and[j_and];
      end
      data_flag_and = 1'b1;
    end 
  end  
   
  always_ff @(posedge clk) begin // or
    if (write_en) begin
      for (j_or = 4; j_or < 8; j_or++) begin
        ALU_cam[j_or] = data_or[j_or];
      end
      data_flag_or = 1'b1;
    end 
  end     

  always_ff @(posedge clk) begin   // xor
    if (write_en) begin
      for (j_xor = 8; j_xor < 12; j_xor++) begin
        ALU_cam[j_xor] = data_xor[j_xor];
      end
      data_flag_xor = 1'b1;
    end 
  end  

  
  always_ff @(posedge clk) begin  
    if (match_flag_L && match_flag_R) begin
      for (n = 0; n < 8; n++) begin
        
        address_L = addr_L[n];
        address_R = addr_R[n];

        comb = { R_cam[address_R][7], L_cam[address_L][7],
         		 R_cam[address_R][6], L_cam[address_L][6], 
                 R_cam[address_R][5], L_cam[address_L][5],
                 R_cam[address_R][4], L_cam[address_L][4],
         		 R_cam[address_R][3], L_cam[address_L][3], 
                 R_cam[address_R][2], L_cam[address_L][2], 
                 R_cam[address_R][1], L_cam[address_L][1], 
                 R_cam[address_R][0], L_cam[address_L][0]}; 
        
      if (controller == 2'b00 && data_flag_and) begin
          match_flag_and = 1'b0;
            a= 0; 
        for (e=0; e<13; e++) begin 
           if(e %2 ==0) begin
          for (r = 0; r < 4; r++) begin
         
            if ({comb[e],comb[e+1]} == r) begin
              addr_and[a] = r[1:0];
              a = a+1;
               match_flag_and = 1'b1;
           break;
            end 
            
          end // for r
          end // if even
      end  // for e
        end  
                       
         // OR operation
                else if (controller == 2'b01 && data_flag_or) begin
                  match_flag_or = 1'b0; 
                  b = 0;
                  for (e1 = 0; e1 < 8; e1 += 2) begin
                  
                    for (s = 0; s < 4; s++) begin 
                      if ({comb[e1], comb[e1+1]} == {s[1], s[0]}) begin
                        addr_or[b] = {1'b1, s[1], s[0]};
                        b = b+ 1;
                        match_flag_or = 1'b1;
                        break;
                      end 
                    end
                  end  
                end

  // XOR operation
 else if (controller == 2'b10 && data_flag_xor) begin
      match_flag_xor = 1'b0;
       c = 0;
    for (e2 = 0; e2 < 16; e2 += 2) begin
       for (t = 0; t < 4; t++) begin
          if ({comb[e2], comb[e2+1]} == t[1:0]) begin
               addr_xor[c] = {2'b10, t[1:0]};
                c = c+1; 
                 match_flag_xor = 1'b1;
             break;
         end 
       end
      end  
 end   
        
          for (a1=0; a1 <8; a1++) begin
        address_and = addr_and[a1];
        address_or  = addr_or[a1];
        address_xor = addr_xor[a1];
            
        if (match_flag_and && match_flag_L && match_flag_R) begin
          op_reg[n][a1] = ALU_cam[address_and];
        end 
        
        else if (match_flag_or && match_flag_L && match_flag_R) begin
           op_reg[n][a1] = ALU_cam[address_or];        
        end 
        
        else if (match_flag_xor && match_flag_L && match_flag_R) begin
           op_reg[n][a1] = ALU_cam[address_xor];       
        end 
        
        else begin
          op_reg[n] = 'bx; // Single bit 'x' to represent unknown value
        end 
                
      end //for a1 end
    end   //if end                              
  end     // always               
  end // a1 for loop         
endmodule
