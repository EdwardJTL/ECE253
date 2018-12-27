module part5(CLOCK_50, HEX0, SW);
  input CLOCK_50;
  input [9:0] SW;
  output [6:0] HEX0;

  wire [25:0] holder;
  wire [3:0] E;

  //50M is 10111110101111000010000000 in binary

  timed_09 mytimer(CLOCK_50, SW[0], holder, E);
  
  binary_7seg h0 (E, HEX0);

endmodule

module timed_09 (Clk, reset, hold, out);
	input Clk, reset;
	output reg [25:0] hold;
	output reg [3:0] out;
	
	always @(posedge Clk)
	begin
		if ((reset == 0) | (out == 4'b1010)) begin
			out = 4'b0;
			hold = 26'b0;
			end
		else if (hold == 26'b10111110101111000010000000) begin
			out <= out + 1;
			hold = 26'b0;
			end
		else
			hold <= hold + 1;
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
