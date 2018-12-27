module part3(SW, KEY, LEDR, CLOCK_50);

	input [2:0] SW;
	input [1:0] KEY;
	input CLOCK_50;
	output [3:0] LEDR;
	
	wire en_sr, sr_out;
	wire [1:0] my_clk;
	wire [10:0] blink_code;
	wire [25:0] holder;
	
	timed_quarter_sec my_timer(CLOCK_50, KEY[0], holder, my_clk);
	selector letter_select(SW[2:0], blink_code);
	shift_reg s_r(blink_code, my_clk[0], en_sr, KEY[0], sr_out);
	FSM my_FSM(KEY[1], my_clk[0], KEY[0], sr_out, en_sr, LEDR[0]);
	
endmodule

module FSM(enable, clk, reset, s_r, en_out, ledr_out);

	input enable, clk, reset, s_r;
	output reg en_out, ledr_out;
	
	(* syn_encoding = "user" *) reg [1:0] state;

	always @(state) begin
		en_out <= ~state[1];
		ledr_out <= state[0];
	end
	
	always @ (posedge clk or negedge enable or negedge reset) begin
		if (reset == 0)
			state <= 2'b0;
		else
			if (enable == 0)
				state <= 2'b10;
			else
				state <= {1'b0, s_r};
	end

endmodule 

module asyn_ff(D, clock, reset, Q);
  input D, clock, reset;
  output reg Q;

  always @(posedge clock, negedge reset)
  begin
    if (reset == 0)
      Q <= 1'b0;
    else
      Q <= D;
  end
  
endmodule

module timed_quarter_sec (Clk, reset, hold, out);
	input Clk, reset;
	output reg [25:0] hold;
	output reg [1:0]out;
	
	always @(posedge Clk or negedge reset)
	begin
		if (reset == 0) begin
			out <= 1'b0;
			hold <= 26'b0;
			end
		else if (out == 2'b10) begin
			out <= 1'b0;
			hold <= 26'b0;
			end
		else if (hold == 26'D12500000) begin
			out <= out + 1;
			hold <= 26'b0;
			end
		else
			hold <= hold + 1;
	end
	
endmodule //counts half a second (25M clicks), out is 2 bit binary
//out is 00 for quarter a second, 01 for quarter a second, needs to re-map

module selector(in, out);
	
	input [2:0] in;
	output reg [10:0] out;
	
	always @(in) begin
	case(in)
		3'D0: out <= 11'b00000011101;
		3'D1: out <= 11'b00101010111;
		3'D2: out <= 11'b10111010111;
		3'D3: out <= 11'b00001010111;
		3'D4: out <= 11'b00000000001;
		3'D5: out <= 11'b00101110101;
		3'D6: out <= 11'b00101110111;
		3'D7: out <= 11'b00001010101;
		default: out <= 11'bxxxxxxxxx;
	endcase
	end
endmodule //logic circuit to select 11 digit blink code (fliped) based on SW2-0

module mux_2_to_1(in, s, out);

	input [1:0] in;
	input s;
	output out;
	
	assign out = ((~s & in[1]) | (s & in[0]));

endmodule // a 2 to 1 mux that has in[1] on 0 and in[0] on 1, made as reference

module asyn_FF(D, prev, enable, clk, reset, Q);
	
	input D, prev, clk, enable, reset;
	output reg Q;
	
	always @(posedge clk or negedge reset)
	begin
		if (reset == 0)
			Q <= 1'b0;
		else
			Q <= ((~enable & D) | (enable & prev));
	end
	
endmodule //one unit of the shifter, mux is implemented into the input

module shift_reg(blink, clk, enable, reset, out);
	
	//11 bit shift register
	//gets blink code from selector logic, keeps that in the mux inputs
	//enable should be from FSM, it should only tick once
	//reset and clock is shared with everyone else
	//out is 1/0, is fed to the FSM, and turns on/off LEDR

	input [10:0] blink;
	input clk, reset, enable;
	
	output out;
	
	wire [9:0] holder;
	
	asyn_FF reg10(blink[10], 1'b0, enable, clk, reset, holder[9]);
	asyn_FF reg9(blink[9], holder[9], enable, clk, reset, holder[8]);
	asyn_FF reg8(blink[8], holder[8], enable, clk, reset, holder[7]);
	asyn_FF reg7(blink[7], holder[7], enable, clk, reset, holder[6]);
	asyn_FF reg6(blink[6], holder[6], enable, clk, reset, holder[5]);
	asyn_FF reg5(blink[5], holder[5], enable, clk, reset, holder[4]);
	asyn_FF reg4(blink[4], holder[4], enable, clk, reset, holder[3]);
	asyn_FF reg3(blink[3], holder[3], enable, clk, reset, holder[2]);
	asyn_FF reg2(blink[2], holder[2], enable, clk, reset, holder[1]);
	asyn_FF reg1(blink[1], holder[1], enable, clk, reset, holder[0]);
	asyn_FF reg0(blink[0], holder[0], enable, clk, reset, out);
	
endmodule 