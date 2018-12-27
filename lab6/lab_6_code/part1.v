module part1(SW, LEDR, KEY);
  input [2:0] SW, KEY;
  output [9:0] LEDR;

  wire w, out;
  wire [8:0] y, Y;

  assign w = SW[1];
  assign Y[0] = 0;
  assign Y[1] = ~w & (y[0] + y[8] + y[7] + y[6] + y[5]);
  assign Y[2] = ~w & (y[1]);
  assign Y[3] = ~w & (y[2]);
  assign Y[4] = ~w & (y[3]+ y[4]);
  assign Y[5] = w & (y[0] + y[1] + y[2] + y[3] + y[4]);
  assign Y[6] = w & y[5];
  assign Y[7] = w & y[6];
  assign Y[8] = w & (y[7] + y[8]);

  assign out = y[4] + y[8];

  flip_synch_A A(Y[0], KEY[0], SW[0], y[0]);
  flip_synch B(Y[1], KEY[0], SW[0], y[1]);
  flip_synch C(Y[2], KEY[0], SW[0], y[2]);
  flip_synch D(Y[3], KEY[0], SW[0], y[3]);
  flip_synch E(Y[4], KEY[0], SW[0], y[4]);
  flip_synch F(Y[5], KEY[0], SW[0], y[5]);
  flip_synch G(Y[6], KEY[0], SW[0], y[6]);
  flip_synch H(Y[7], KEY[0], SW[0], y[7]);
  flip_synch I(Y[8], KEY[0], SW[0], y[8]);

  assign LEDR[8:0] = y[8:0];
  assign LEDR[9] = out;

endmodule

module flip_synch(D, clock, reset, Q);
  input D, clock, reset;
  output reg Q;

  always @(posedge clock)
  begin
    if (reset == 0)
      Q <= 1'b0;
    else
      Q <= D;
  end
endmodule

module flip_synch_A(D, clock, reset, Q);
  input D, clock, reset;
  output reg Q;

  always @(posedge clock)
   Q <= ~reset;

endmodule
