module part1 (SW, HEX1, HEX0);
   input [9:0] SW;
   output [6:0] HEX1, HEX0;
   
   binary_7seg D1(SW[7:4], HEX1);
   binary_7seg D0(SW[3:0], HEX0);  
  
endmodule // part1

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

   

