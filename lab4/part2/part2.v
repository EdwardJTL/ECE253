module part2(SW, HEX1, HEX0);
   input [3:0] SW;
   output [6:0] HEX1, HEX0;
	
	wire Z;
	wire [3:0] A, C1, C0;
	
	compare_9 gen_z(SW[3:0], Z);
	assign C1[0] = Z;
	assign C1[3:1] = 3'b000;
	
	circuit_a gen_A(SW[3:0], A);
	
	mux_4bit_2to1 choose(Z, SW[3:0], A, C0);
	
	binary_7seg d1(C1, HEX1);
	binary_7seg d0(C0, HEX0);

endmodule 

module binary_7seg ( C, Display);
   input [3:0] C;
   output [6:0] Display;
   assign Display[0] = (~C[3] & ~C[2] & ~C[1] & C[0]) | (C[2] & ~C[1] & ~C[0]);
   assign Display[1] = (C[2] & ~C[1] & C[0]) | (C[2] & C[1] & ~C[0]);
   assign Display[2] = ~C[2] & C[1] & ~C[0];
   assign Display[3] = (~C[2] & ~C[1] & C[0]) | (C[2] & ~C[1] & ~C[0]) | (C[2] & C[1] & C[0]);
   assign Display[4] = C[0] | (~C[1] & C[2]);
   assign Display[5] = (C[1] & C[0]) | (C[0] & ~C[2] & ~C[3]) | (C[1] & ~C[0] & ~C[2]);
   assign Display[6] = (~C[1] & ~C[2] & ~C[3]) | (C[1] & C[0] & C[2]);
endmodule // binary_7seg

module compare_9 (V,Z);
	input [3:0] V;
	output Z;
	assign Z = (V[2] & V[3]) | (V[1] & V[3]);
endmodule //compare if V is greater than 9

//4-bit wide 2 to 1 mux
module mux_4bit_2to1 (S, U, V, M);
	input [3:0] U, V;
	input S;
	output [3:0] M;
	
	assign M[0] = (~S & U[0]) | (S & V[0]);
	assign M[1] = (~S & U[1]) | (S & V[1]);
	assign M[2] = (~S & U[2]) | (S & V[2]);
	assign M[3] = (~S & U[3]) | (S & V[3]);
endmodule 

//Circuit A
module circuit_a (V, A);
	input [3:0] V;
	output [3:0] A;
	
	assign A[3] = 1'b0;
	assign A[2] = V[1] & V[2];
	assign A[1] = ~V[1];
	assign A[0] = V[0];
	
endmodule 