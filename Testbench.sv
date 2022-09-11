`timescale 1ns/1ps


module tb;
  reg clk;

  always #5 clk = ~clk; //clock cycle


endmodule
