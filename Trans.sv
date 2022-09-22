typedef enum{test1, test2} tipo_test;

class trans_bus #(parameter pckg_size, drvrs);
    rand int retardo; //numero de ciclos de reloj que se deben esperar para ejecutar la instruccion
    rand bit [pckg_size-8-1:0]payload; //dato
    rand bit [7:0]id_dest; //direccion del dispositivo destino
    int tiempo_envio;
    int tiempo_recibido;
    rand int id_emisor; //direccion del dispositivo del cual se envia el mensaje
    bit[pckg_size-1:0]message=0;
    int max_retardo=25;
  
    constraint const_retardo {retardo < max_retardo; retardo > 0;}
    constraint const_emisor {id_emisor < drvrs; id_emisor >= 0;}
    constraint const_dest {id_dest < drvrs; id_dest >= 0; id_dest != id_emisor;}
endclass

class Fifo #(parameter pckg_size, drvrs, bits);

    bit [pckg_size-1:0]q[$]={};
    int k;
    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) vif;
    
    task run();
            //Funcionamiento de la FIFO'
            vif.pndng[0][k]= 1'b0;
            forever begin
                               
                @(posedge vif.clk)
                vif.D_pop[0][k]= q[0];             
                   if(q.size()!=0) begin
                        vif.pndng[0][k]= 1'b1;

                    end
                    //Fifo vacia
                    else begin
                        vif.pndng[0][k] <= 1'b0;
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

class chkr_scrbrd #(parameter pckg_size = 16);
    int tiempo_envio;
    int tiempo_recibido;
    bit [pckg_size-9:0]id_emisor;
    bit [7:0]id_dest;
    bit [pckg_size-1:0]message;

endclass
