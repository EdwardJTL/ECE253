module part3(SW, LEDR);
	input [8:0] SW;
	output [4:0] LEDR;
	
	wire [3:0] S;
	
	adder_4bit add(SW[3:0], SW[7:4], SW[8], S, LEDR[4]);
	
	assign LEDR[3:0] = S;

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