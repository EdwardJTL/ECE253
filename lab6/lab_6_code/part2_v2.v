module part2_v2(SW, KEY, LEDR);

	input [2:0] SW, KEY;
	output [9:0] LEDR;
	
	FSM my_fsm(KEY[0], SW[1], SW[0], {LEDR[9], LEDR[3:0]});
	
endmodule

// Quartus Prime Verilog Template
// User-encoded state machine

module FSM
(
	input	clk, w, reset,
	output reg [4:0] out
);

	// Declare state register
	(* syn_encoding = "user" *) reg [3:0] state;

	// Declare states
	parameter A = 4'b0000, B = 4'b0001, C = 4'b0010, D = 4'b0011, E = 4'b0100, F = 4'b0101, G = 4'b110, H = 4'b0111, I = 4'b1000;

	// Output depends only on the state
	always @ (state) begin
		out = {((state == E) | (state == I)), state};
	end

	// Determine the next state
	always @ (posedge clk) begin
		if (~reset)
			state <= A;
		else
			case(state)
			A:  if(!w) state = B;
				 else state = F;
			B:  if(!w) state = C;
				 else state = F;
			C:  if(!w) state = D;
				 else state = F;
			D:  if(!w) state = E;
				 else state = F;
			E:  if(!w) state = E;
				 else state = F;
			F:  if(!w) state = B;
				 else state = G;
			G:  if(!w) state = B;
				 else state = H;
			H:  if(!w) state = B;
				 else state = I;
			I:  if(!w) state = B;
				 else state = I;
			default: state = 4'bxxxx;
			endcase
	end

endmodule
