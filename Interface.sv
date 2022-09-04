//The interface allows verification components to access DUT signals
// using a virtual interface handle

interface bus_if 
    #(
        parameter bits = 1,
        parameter drvrs = 4,
        parameter pckg_sz = 16;
    )(input bit clk);

    logic clk;
    logic reset;
    logic pndng[bits-1:0][drvrs-1:0];
    logic push[bits-1:0][drvrs-1:0];
    logic pop[bits-1:0][drvrs-1:0];
    logic [pckg_sz-1:0]D_pop[bits-1:0][drvrs-1:0];
    logic [pckg_sz-1:0]D_push[bits-1:0][drvrs-1:0];

endinterface
