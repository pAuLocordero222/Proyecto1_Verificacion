module FIFO #(parameter pckg_sz = 4;)(
    input rst,
    input [pckg_sz-1:0]D_in,
    input push,
    input pop,
    output [pckg_sz-1:0]D_out
);

    q[$] = {};

    D_out = q[-1];

    //Funciones de la FIFO
    if(push)begin
        q.push_front(D_in);
    end
    else if(pop)begin
        q.pop_back;
    end
    else if(rst)begin
        q.delete();
    end

endmodule

