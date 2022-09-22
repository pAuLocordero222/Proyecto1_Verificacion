`timescale 1ns/1ps
`include "Library.sv"
`include "Interface.sv"
`include "Trans.sv"
`include "Agent.sv"
`include "Driver.sv"
`include "Monitor.sv"
`include "Checker.sv"
`include "Scoreboard.sv"
`include "Environment.sv"





module tb;
  mailbox test_2_gen_mbx = new();//Se define mailbox que envia datos desde el testbench al agente

//Definicion de parametros de tamaño de paquete, numero de dispositivos conectados al DUT y numero de mensajes
  parameter pckg_size = 16;
  parameter drvrs = 4;
  parameter bits = 1;
  parameter num_msg = 4;

  tipo_test test;
  reg clk;

  always #5 clk = ~clk; //clock cycle

  bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) bus_interface(clk);// se define una instancia de la interface
  
  bs_gnrtr_n_rbtr #(.drvrs(drvrs), .pckg_sz(pckg_size), .broadcast({8{1'b1}})) uut	( //se instancia el dispositivo bajo prueba 
    .clk(clk), 
    .reset(bus_interface.reset), 
    .pndng(bus_interface.pndng), 
    .push(bus_interface.push), 
    .pop(bus_interface.pop), 
    .D_pop(bus_interface.D_pop), 
    .D_push(bus_interface.D_push)
  );
  
  
  Envi #(.pckg_size(pckg_size), .num_msg(num_msg), .drvrs(drvrs), .bits(bits)) inst_envi; //Se crea una instancia del environment

  initial begin 
    {clk, bus_interface.reset} <= 0;
    inst_envi = new();//se crea un nuevo objeto de tipo environment
    inst_envi.vif = bus_interface;//se conecta la interface del environment con la interfaz en el testbench
    inst_envi.run();//Se corre el task run del environment

          
      
    //Test1: envio de datos aleatorios desde dispositivos aleatorios hacia destinos aleatorios 
    //Test2: se envian datos aleatorios a destinos aleatorios pero pasando por cada uno de los dispositivos hasta que todos hayan enviado un mensaje
    test=test2;
    test_2_gen_mbx.put(test);
    #500000;$finish;
  end



endmodule