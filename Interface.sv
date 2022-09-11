//The interface allows verification components to access DUT signals
// using a virtual interface handle

interface bus_if #(parameter bits ,drvrs, pckg_sz)(input bit clk);

    bit reset;
    bit pndng[bits-1:0][drvrs-1:0];
    bit push[bits-1:0][drvrs-1:0];
    bit pop[bits-1:0][drvrs-1:0];
    bit [pckg_sz-1:0]D_pop[bits-1:0][drvrs-1:0];
    bit [pckg_sz-1:0]D_push[bits-1:0][drvrs-1:0];

endinterface
