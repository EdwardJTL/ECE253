module part4(SW, HEX0, HEX1, HEX3, HEX5, LEDR);
	input [8:0] SW;
	output [6:0] HEX1, HEX0, HEX3, HEX5;
	output [9:0] LEDR;
	
	wire [4:0] X, Y, S, C1, C0, A, B, M;
	wire cout, Z;
	
	assign X[4:0] = SW[3:0];
	assign Y[4:0] = SW[7:4];
	
	assign LEDR[9] = ((X[1] & X[3]) | (~X[1] & X[2] & X[3])) | ((Y[1] & Y[3]) | (~Y[1] & Y[2] & Y[3])); 
	
	adder_4bit add(X, Y, SW[8], S, cout);
	
	assign LEDR[3:0] = S;
	assign LEDR[4] = cout;

	compare_9 gen_z(S, Z);
	assign C1[0] = Z | cout;
	assign C1[3:1] = 3'b000;
	
	circuit_a gen_A(S, A);
	
	circuit_b gen_B(S, B);
	
	mux_4bit_2to1 chooseA(Z, S, A, M);
	
	mux_4bit_2to1 chooseB(cout, M, B, C0);
	
	binary_7seg d1(C1, HEX1);
	binary_7seg d0(C0, HEX0);
	
	binary_7seg d3(X, HEX3);
	binary_7seg d5(Y, HEX5);
	
endmodule

module fulladder(a, b, cin, s, cout);
	input a, b, cin;
	output s, cout;
	
	assign s = a^b^cin;
	assign cout = (a & b) | (a & cin) | (b & cin);
	
endmodule 

module adder_4bit(A, B, cin, S, cout);
	input [3:0] A, B;
	input cin;
	output [3:0] S;
	output cout;
	
	wire c1, c2, c3;
	
	fulladder u0(A[0], B[0], cin, S[0], c1);
	fulladder u1(A[1], B[1], c1, S[1], c2);
	fulladder u2(A[2], B[2], c2, S[2], c3);
	fulladder u3(A[3], B[3], c3, S[3], cout);
	
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

//Circuit B
module circuit_b (V, A);
	input [3:0] V;
	output [3:0] A;
	
	assign A[3] = V[1];
	assign A[2] = ~V[1];
	assign A[1] = ~V[1];
	assign A[0] = V[0];
	
endmodule 
