module part2(SW, KEY, LEDR);
  input [2:0] SW, KEY;
  output [9:0] LEDR;

  wire w, clk;
  (* syn_encoding = "user" *) reg [3:0] y_Q;
  (* syn_encoding = "user" *) reg [3:0] Y_D;
  parameter A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F = 4'b0101, G = 4'b110, H = 4'b0111, I = 4'b1000;

  assign w = SW[1];
  assign clk = SW[0];

  always @(w, y_Q)
  begin
    case(y_Q)
      A:  if(!w) Y_D = B;
          else Y_D = F;
      B:  if(!w) Y_D = C;
          else Y_D = F;
      C:  if(!w) Y_D = D;
          else Y_D = F;
      D:  if(!w) Y_D = E;
          else Y_D = F;
      E:  if(!w) Y_D = E;
          else Y_D = F;
      F:  if(!w) Y_D = B;
          else Y_D = G;
      G:  if(!w) Y_D = B;
          else Y_D = H;
      H:  if(!w) Y_D = B;
          else Y_D = I;
      I:  if(!w) Y_D = B;
          else Y_D = I;
      default: Y_D = 4'bxxxx;
    endcase
  end //state_table

  always @(posedge clk)
  begin
    if (!SW[0])
      y_Q <= A;
    else
      y_Q <= Y_D;
  end //state_FFs

  assign LEDR[3:0] = y_Q[3:0];
  assign LEDR[9] = ((y_Q == E) | (y_Q == I));

endmodule
