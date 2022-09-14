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

class Fifo #(parameter pckg_size);
    bit [pckg_size-1:0]D_pop;
    bit pop;
    bit [pckg_size-1:0]q[$];
    bit [pckg_size-1:0]pndng;

    task run();
                //Funcionamiento de la FIFO
        fork 
            forever begin
                if(q.size()>0) begin
                    D_pop = q[-1];
                    pndng = 1;
                end

                else begin
                    pndng = 0;
                    D_pop = 0;
                end

                //POP
                if(pop) begin
                    if (q.size() != 0) begin
                        q.pop_back;
                    end
                end
            end
        join_none
    endtask
endclass
