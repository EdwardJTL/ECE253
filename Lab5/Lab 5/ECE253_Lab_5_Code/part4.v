module part4(SW, KEY, HEX0, HEX1, HEX2, HEX3);
  input [1:0] SW;
  input [3:0] KEY;
  output [6:0] HEX0, HEX1, HEX2, HEX3;
  wire [15:0] Q;

	toggle t1(SW[1], KEY[0], SW[0], Q);

  binary_7seg h0(Q[3:0], HEX0);
  binary_7seg h1(Q[7:4], HEX1);
  binary_7seg h2(Q[11:8], HEX2);
  binary_7seg h3(Q[15:12], HEX3);

endmodule

module toggle(T, Clk, reset, Q);
	input T, Clk, reset;
	output reg [15:0] Q;
	always @(posedge Clk)
	begin
		if (reset == 0)
			Q = 16'b0;
		else
			Q <= Q + T;
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
