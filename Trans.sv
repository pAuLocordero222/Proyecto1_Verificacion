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

    bit [pckg_size-1:0]q[$];
    int k;

    virtual bus_if #(.bits(bits), .drvrs(drvrs), .pckg_size(pckg_size)) vif;

    task run();
                //Funcionamiento de la FIFO
            forever begin
                
                @(posedge vif.clk)
                                 
                    if(q.size()>0) begin


                        vif.D_pop[0][k]= q[0];
                        vif.pndng[0][k]= 1'b1;
                        
                        $display("contenido en fifo %0d es de %0d",k, q.size());
                        $display("contenido en la primera posicion de la fifo %0d es %0b",k, q[0]);
                        $display("D_pop en %0d es:%0b",k, vif.D_pop[0][k]);
                        $display("pndng %0d esta en %0d",k, vif.pndng[0][k]);
                        


                    end
                    //Fifo vacia
                    else begin
                        vif.pndng[0][k] <= 1'b0;
                    end

                    //POP
                    if(vif.pop[0][k]) begin
                        //$display("si se lee esto el pop deberia estar en 1:", vif.pop[0][k]);
                        if (q.size() != 0) begin
                            q.pop_front;
                        end
                    end
            end
    endtask
endclass
