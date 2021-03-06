module part6 (SW,LEDR,HEX0,HEX1,HEX2,HEX3,HEX4,HEX5);
	input [9:0] SW;
	output [9:0] LEDR;
	output [0:6] HEX0;
	output [0:6] HEX1;
	output [0:6] HEX2;
	output [0:6] HEX3;
	output [0:6] HEX4;
	output [0:6] HEX5;
	
	assign LEDR[9:8] = SW[9:7];
	
	wire [1:0] M0, M1, M2, M3, M4, M5;
	
	mux_2bit_6to1 U0 (SW[9:7], SW[1:0], SW[2:1], SW[2:1], SW[2:1], SW[5:4], SW[3:2], M0);
	char_7seg H0 (M0, HEX0);
	
	mux_2bit_6to1 U1 (SW[9:7], SW[3:2], SW[1:0], SW[2:1], SW[2:1], SW[2:1], SW[5:4], M1);
	char_7seg H1 (M1, HEX1);
	
	mux_2bit_6to1 U2 (SW[9:7], SW[5:4], SW[3:2], SW[1:0], SW[2:1], SW[2:1], SW[2:1], M2);
	char_7seg H2 (M2, HEX2);
	
	mux_2bit_6to1 U3 (SW[9:7], SW[2:1], SW[5:4], SW[3:2], SW[1:0], SW[2:1], SW[2:1], M3);
	char_7seg H3 (M3, HEX3);
	
	mux_2bit_6to1 U4 (SW[9:7], SW[2:1], SW[2:1], SW[5:4], SW[3:2], SW[1:0], SW[2:1], M4);
	char_7seg H4 (M4, HEX4);
	
	mux_2bit_6to1 U5 (SW[9:7], SW[2:1], SW[2:1], SW[2:1], SW[5:4], SW[3:2], SW[1:0], M5);
	char_7seg H5 (M5, HEX5);
	
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