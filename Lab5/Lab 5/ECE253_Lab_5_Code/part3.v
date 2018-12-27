module part3(SW, KEY, HEX0, HEX1, LEDR);
  input [1:0] SW;
  input [3:0] KEY;
  output [6:0] HEX0, HEX1;
  output [7:0] LEDR;
  wire [7:0] Q,E;
  
  assign E[0] = SW[1];
  assign E[1] = E[0] & Q[0];
  assign E[2] = E[1] & Q[1];
  assign E[3] = E[2] & Q[2];
  assign E[4] = E[3] & Q[3];
  assign E[5] = E[4] & Q[4];
  assign E[6] = E[5] & Q[5];
  assign E[7] = E[6] & Q[6];

  binary_7seg h0(Q[3:0], HEX0);
  binary_7seg h1(Q[7:4], HEX1);

  toggle_ff toggle_ff0(E[0], KEY[0], SW[0], Q[0]);
  toggle_ff toggle_ff1(E[1], KEY[0], SW[0], Q[1]);
  toggle_ff toggle_ff2(E[2], KEY[0], SW[0], Q[2]);
  toggle_ff toggle_ff3(E[3], KEY[0], SW[0], Q[3]);
  toggle_ff toggle_ff4(E[4], KEY[0], SW[0], Q[4]);
  toggle_ff toggle_ff5(E[5], KEY[0], SW[0], Q[5]);
  toggle_ff toggle_ff6(E[6], KEY[0], SW[0], Q[6]);
  toggle_ff toggle_ff7(E[7], KEY[0], SW[0], Q[7]);

  assign LEDR[7:0] = Q;
  
endmodule

module toggle_ff (T, Clk, reset, Q);
  input T, Clk, reset;
  output reg Q;
  always @(posedge Clk)
  begin
    if (reset == 0)
      Q <= 1'b0;
    else
      Q <= Q ^ T;
  end
endmodule

module binary_7seg ( C, Display);
   input [3:0] C;
   output reg [6:0] Display;
   always @(C)
   case(C)
      4'h0:
        Display = 7'b1000000;
      4'h1:
        Display = 7'b1111001;
      4'h2:
        Display = 7'b0100100;
      4'h3:
        Display = 7'b0110000;
      4'h4:
        Display = 7'b0011001;
      4'h5:
        Display = 7'b0010010;
      4'h6:
        Display = 7'b0000010;
      4'h7:
        Display = 7'b1111000;
      4'h8:
        Display = 7'b0000000;
      4'h9:
        Display = 7'b0011000;
      4'hA:
        Display = 7'b0001000;
      4'hB:
        Display = 7'b0000011;
      4'hC:
        Display = 7'b0100111;
      4'hD:
        Display = 7'b0100001;
      4'hE:
        Display = 7'b0000110;
      4'hF:
        Display = 7'b0001110;
      default:
        Display = 7'b1111111;
   endcase
endmodule // binary_7seg
