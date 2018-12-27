module part2(SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, LEDR);
  input [7:0] SW;
  input [1:0] KEY;
  output [5:0] LEDR;
  output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

  wire [7:0] store, sum;

  asyn_ff latch(SW[7:0], KEY[1], KEY[0], store);
  
  adder_8bit add(store, SW[7:0], 1'b0, sum, LEDR[0]);
  binary_7seg h0(SW[3:0], HEX0);
  binary_7seg h1(SW[7:4], HEX1);
  binary_7seg h2(store[3:0], HEX2);
  binary_7seg h3(store[7:4], HEX3);
  binary_7seg h4(sum[3:0], HEX4);
  binary_7seg h5(sum[7:4], HEX5);
endmodule

module asyn_ff(D, Clk, reset, Q);
	input Clk, reset;
	input [6:0] D;
	output reg [6:0] Q;
	always @(posedge Clk, negedge reset)
	begin
		if (reset==0)
			Q <= 7'b0;
		else
			Q <= D;
	end
endmodule

module fulladder(a, b, cin, s, cout);
	input a, b, cin;
	output s, cout;
	
	assign s = a^b^cin;
	assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module adder_8bit(A, B, cin, S, cout);
	input [7:0] A, B;
	input cin;
	output [7:0] S;
	output cout;

	wire c1, c2, c3, c4, c5, c6, c7;
	
	fulladder u0(A[0], B[0], cin, S[0], c1);
	fulladder u1(A[1], B[1], c1, S[1], c2);
	fulladder u2(A[2], B[2], c2, S[2], c3);
	fulladder u3(A[3], B[3], c3, S[3], c4);
	fulladder u4(A[4], B[4], c4, S[4], c5);
	fulladder u5(A[5], B[5], c5, S[5], c6);
	fulladder u6(A[6], B[6], c6, S[6], c7);
	fulladder u7(A[7], B[7], c7, S[7], cout);

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
