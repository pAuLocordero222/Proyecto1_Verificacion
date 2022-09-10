`timescale 1ns/1ps
`include "FIFO.sv"


module testbench;
    FIFO f1;

    initial begin
        f1 = new(0, 5 , 0, 0);

        f1.push = 1;#2;
        f1.push = 0;
        f1.D_in = 3;#2
        f1.push = 1;#5;
        f1.pop = 1;#2;
        f1.pop = 0;

        $finish;


    end
endmodule
