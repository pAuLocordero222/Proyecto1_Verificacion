typedef enum{test1, test2, test3, test4, test5, test6, test7} tipo_test;

class trans_bus #(parameter pckg_size, drvrs);
    rand int retardo; //numero de ciclos de reloj que se deben esperar para ejecutar la instruccion
    rand bit [pckg_size-8-1:0]payload; //dato
    rand bit [7:0]id_dest; //direccion del dispositivo destino
    int tiempo;
    rand int id_emisor; //direccion del dispositivo del cual se envia el mensaje
    bit[pckg_size-1:0]message=0;
    int max_retardo=25;
  
    constraint const_retardo {retardo < max_retardo; retardo > 0;}
    constraint const_emisor {id_emisor < drvrs; id_emisor >= 0;}
    constraint const_dest {id_dest < drvrs; id_dest >= 0; id_dest != id_emisor;}
  
endclass

class Fifo #(parameter pckg_size, drvrs, bits);
    //bit [pckg_size-1:0]D_pop;
    //bit pop;
    bit [pckg_size-1:0]q[$];
    int k;
    //bit [pckg_size-1:0]pndng;
    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) vif;
/*
    vif.D_pop = D_pop;
    vif.pop = pop;
    vif.pndng = pndng;*/

    task run();
                //Funcionamiento de la FIFO
            forever begin
                @(posedge vif.clk)
                    if(q.size()>0) begin
                        vif.D_pop[0][k] = q[0];
                        vif.pndng[0][k] = 1;
                    end
                    //Fifo vacia
                    else begin
                        vif.pndng[0][k] = 0;
                        vif.D_pop[0][k] = 0;
                    end

                    //POP
                    if(vif.pop[0][k]) begin
                        if (q.size() != 0) begin
                            q.pop_front;
                        end
                    end
            end
    endtask
endclass
