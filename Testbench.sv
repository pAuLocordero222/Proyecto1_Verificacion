`timescale 1ns/1ps
`include "Agent_Gen.sv"
`include "Trans.sv"
`include "Interface.sv"


module tb;

  parameter pckg_size = 8;
  parameter drvrs = 4;
  parameter bits = 1;
  parameter num_msg = 20;

  tipo_test test;
  reg clk;

  always #5 clk = ~clk; //clock cycle

  bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) bus_interface(clk);
  bs_gnrtr_n_rbtr DUT(.clk(clk), .reset(bus_interface.reset), .pndng(bus_interface.pndng), .push(bus_interface.push), .pop(bus_interface.pop), .D_pop(bus_interface.D_pop), .D_push(bus_interface.D_push));
  Envi #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs), .bits(bits)) inst_envi;

  initial begin
    {clk, bus_interface.reset} <= 0;
    inst_envi = new();
    inst_envi.bus_interface = bus_interface;
    inst_envi.run();

  end



endmodule
