module part5(SW, HEX0, HEX1, HEX3, HEX5, LEDR);
	input [8:0] SW;
	output [6:0] HEX0, HEX1, HEX3, HEX5;
	output [8:0] LEDR;
	
	wire [3:0] B, A;
	wire c0;
	reg [3:0] S0, S1, c1;
	reg [4:0] Z, T, T1;
	
	assign c0 = SW[8];
	assign B = SW[3:0];
	assign A = SW[7:4];
	
	binary_7seg h0(S0, HEX0);
	binary_7seg h1(S1, HEX1);
	binary_7seg h3(B, HEX3);
	binary_7seg h5(A, HEX5);
	
	
	always @(B, A, c0)
	begin
		T = A + B + c0;
		if (T > 5'b01001) begin
			Z = 5'b01010;
			c1 = 4'b0001;
		end
		else begin
			Z = 5'b00000;
			c1 = 4'b0000;
		end
		T1 = T - Z;
		S0 = T1[3:0];
		S1 = c1;
	end
	
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