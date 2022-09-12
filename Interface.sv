



interface bus_if#(parameter bits ,drvrs, pckg_size)(input bit clk);

    logic reset;
    logic pndng[bits-1:0][drvrs-1:0];
    logic push[bits-1:0][drvrs-1:0];
    logic pop[bits-1:0][drvrs-1:0];
  logic [pckg_size-1:0]D_pop[bits-1:0][drvrs-1:0];
  logic [pckg_size-1:0]D_push[bits-1:0][drvrs-1:0];

endinterface

