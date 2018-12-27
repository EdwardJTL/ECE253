module part3 (SW,LEDR);
	input [9:0] SW;
	output [9:0] LEDR;
	
	wire [1:0] s,f,u,v,w,M;
	
	assign s = SW[9:8];
	assign u = SW[5:4];
	assign v = SW[3:2];
	assign w = SW[1:0];
	
	assign f[0] = (~s[0] & u[0]) | (s[0] & v[0]);
	assign f[1] = (~s[0] & u[1]) | (s[0] & v[1]);
	
	assign M[0] = (~s[1] & f[0]) | (s[1] & w[0]);
	assign M[1] = (~s[1] & f[1]) | (s[1] & w[1]);
	
	assign LEDR[1:0] = M;
endmodule 