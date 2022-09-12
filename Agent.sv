

typedef enum{test1, test2, test3, test4, test5, test6, test7} tipo_test;

class trans_bus #(parameter pckg_size, drvrs);
    rand int retardo; //numero de ciclos de reloj que se deben esperar para ejecutar la instruccion
  rand bit [pckg_size-8-1:0]payload; //dato
  rand bit [7:0]id_dest; //direccion del dispositivo destino
    int tiempo;
  rand bit [7:0]id_emisor; //direccion del dispositivo del cual se envia el mensaje
  bit[pckg_size-1:0]D_push=0;
    int max_retardo=25;
  
    constraint const_retardo {retardo < max_retardo; retardo > 0;}
    constraint const_emisor {id_emisor < drvrs; id_emisor > 0;}
    constraint const_dest {id_dest < drvrs; id_dest > 0; id_dest != id_emisor;}
  
endclass
  


class age_gen #(parameter pckg_size, num_msg, drvrs);



    tipo_test test; //tipos de test para el DUT

    mailbox test_2_gen_mbx;
    mailbox agnt_2_drvr_mbx;  
    



    task run();
        tb.test_2_gen_mbx.get(test);
        case(test)
            test1:
                begin
                    for (int i = 0; i < num_msg; i++) begin
                        trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_2_drvr;
                        msg_2_drvr = new;
                        msg_2_drvr.randomize();
                      	msg_2_drvr.D_push={msg_2_drvr.id_dest, msg_2_drvr.payload};
                        agnt_2_drvr_mbx.put(msg_2_drvr);
                      	
                      	$display("");
                      	$display("Agente: Instruccion de Test1 creada");
                      	$display("payload=%b",msg_2_drvr.payload);
                      	$display("emisor=%b",msg_2_drvr.id_emisor);
                        $display("destino=",msg_2_drvr.id_dest);
                      	$display("");
                      
                      
                    end
                end

            test2:
                begin
                  $display("test2");   
                end

            test3:
                begin
                    
                end

            test4:
                begin
                    
                end

            test5:
                begin
                    
                end

            test6:
                begin
                    
                end

            test7:
                begin
                    
                end

        endcase


    endtask

endclass


/*
class agent #(parameter dr = 4, pkg = 16);
    //trans_bus_mbx agnt_drvr_mbx; //Mailbox agente driver
    cmd_test_agente_mbx test_agent_mbx; //Mailbox test agente

    int num_transacciones;
    int max_retardo;
    int ret_spec;
    tipo_trans tpo_spec;
    instrucciones_agente instruccion;
    trans_bus #(.pkg(pkg)) transaccion;

    function new;
        num_transacciones = 5;
        max_retardo = 15;
    endfunction

    task run;
        $display("[%g] El agente fue inicializado", $time);

        forever begin
            #1
            if (test_agent_mbx.num() > 0)begin
                $display("[%g] Agente: se recibe instruccion", $time);
                test_agent_mbx.get(instruccion);
                case(instruccion)
                    randem_randrec: begin
                        transaccion = new;
                        rand transaccion.retardo;
                        rand transaccion.payload;
                        rand transaccion.id_dest;
                        rand transaccion.tiempo;
                        rand transaccion.id_emisor;
                        rand transaccion.tipo;

                        constraint  const_retardo {retardo < max_retardo; retardo > 0;}
                    end
                endcase
            end
        end
    endtask
endclass
*/
