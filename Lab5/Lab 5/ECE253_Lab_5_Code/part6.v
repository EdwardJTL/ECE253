module part6(CLOCK_50, SW, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	input CLOCK_50;
	input [9:0] SW;
	output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;

	wire [1:0] M0, M1, M2, M3, M4, M5;
	
	wire [2:0] my_sw;

	wire [25:0] holder;

//50M is 10111110101111000010000000 in binary

	timed_SW mytimer(CLOCK_50, SW[0], holder, my_sw);

	mux_2bit_6to1 U0 (my_sw, 2'b10, 2'b11, 2'b11, 2'b11, 2'b00, 2'b01, M0);
	char_7seg H0 (M0, HEX0);

	mux_2bit_6to1 U1 (my_sw, 2'b01, 2'b10, 2'b11, 2'b11, 2'b11, 2'b00, M1);
	char_7seg H1 (M1, HEX1);

	mux_2bit_6to1 U2 (my_sw, 2'b00, 2'b01, 2'b10, 2'b11, 2'b11, 2'b11, M2);
	char_7seg H2 (M2, HEX2);

	mux_2bit_6to1 U3 (my_sw, 2'b11, 2'b00, 2'b01, 2'b10, 2'b11, 2'b11, M3);
	char_7seg H3 (M3, HEX3);

	mux_2bit_6to1 U4 (my_sw, 2'b11, 2'b11, 2'b00, 2'b01, 2'b10, 2'b11, M4);
	char_7seg H4 (M4, HEX4);

	mux_2bit_6to1 U5 (my_sw, 2'b11, 2'b11, 2'b11, 2'b00, 2'b01, 2'b10, M5);
	char_7seg H5 (M5, HEX5);

endmodule

module timed_SW (Clk, reset, hold, out);

	input Clk, reset;
	output reg [25:0] hold;
	output reg [2:0] out;
	
	always @(posedge Clk)
	begin
		if ((reset == 0) | (out == 3'b110)) begin
			out = 3'b0;
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

//2-bit wide 6 to 1 mux
module mux_2bit_6to1 (S, U, V, W, X, Y, Z, M);
	input [1:0] U, V, W, X, Y, Z;
	input [2:0] S;
	output [1:0] M;

	wire [1:0] f,g,h,l;

	assign f[0] = (~S[0] & U[0]) | (S[0] & V[0]);
	assign f[1] = (~S[0] & U[1]) | (S[0] & V[1]);

	assign g[0] = (~S[0] & W[0]) | (S[0] & X[0]);
	assign g[1] = (~S[0] & W[1]) | (S[0] & X[1]);

	assign h[0] = (~S[0] & Y[0]) | (S[0] & Z[0]);
	assign h[1] = (~S[0] & Y[1]) | (S[0] & Z[1]);

	assign l[0] = (~S[1] & f[0]) | (S[1] & g[0]);
	assign l[1] = (~S[1] & f[1]) | (S[1] & g[1]);

	assign M[0] = (~S[2] & l[0]) | (S[2] & h[0]);
	assign M[1] = (~S[2] & l[1]) | (S[2] & h[1]);
endmodule

//7-seg decoder for d, E, 1 and 'blank'
module char_7seg(C, Display);
	input [1:0] C;
	output [0:6] Display;

	assign Display[0] = C[1] | (~C[0]);
	assign Display[1] = C[0];
	assign Display[2] = C[0];
	assign Display[3] = C[1];
	assign Display[4] = C[1];
	assign Display[5] = C[1] | (~C[0]);
	assign Display[6] = C[1];

endmodule
