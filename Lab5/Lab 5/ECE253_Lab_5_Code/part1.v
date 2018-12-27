module part1(D, Clk, Qa, Qb, Qc);
  input D, Clk;
  output reg Qa, Qb, Qc;

  always @(D, Clk)
  begin
    if (Clk == 1)
      Qa = D;
  end

  always @(posedge Clk)
  begin
    Qb <= D;
  end

  always @(negedge Clk)
  begin
    Qc <= D;
  end

endmodule
