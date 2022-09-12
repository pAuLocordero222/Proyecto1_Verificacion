

interface bus_if#(parameter bits ,drvrs, pckg_size)(input bit clk);

    bit reset;
    bit pndng[bits-1:0][drvrs-1:0];
    bit push[bits-1:0][drvrs-1:0];
    bit pop[bits-1:0][drvrs-1:0];
  bit [pckg_size-1:0]D_pop[bits-1:0][drvrs-1:0];
  bit [pckg_size-1:0]D_push[bits-1:0][drvrs-1:0];

endinterface
