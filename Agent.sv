class age_gen #(parameter pckg_size, num_msg, drvrs);

    

    tipo_test test; //tipos de test para el DUT

    mailbox test_2_gen_mbx;
    mailbox agnt_2_drvr_mbx;
    mailbox agnt_2_chckr_mbx;  
    



    task run();
      $display("Agente correctamente inicializado");
        tb.test_2_gen_mbx.get(test);
        case(test)
            test1:
                begin
                    for (int i = 0; i < num_msg; i++) begin
                        trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_2_drvr;
                        msg_2_drvr = new;
                        msg_2_drvr.randomize();
                      	msg_2_drvr.message={msg_2_drvr.id_dest, msg_2_drvr.payload};
                        agnt_2_drvr_mbx.put(msg_2_drvr);
                        agnt_2_chckr_mbx.put(msg_2_drvr);
                      	
                      	$display("");
                      	$display("Agente: Instruccion de Test1 creada");
                      	$display("payload=%b",msg_2_drvr.payload);
                      	$display("emisor=%d",msg_2_drvr.id_emisor);
                        $display("destino=",msg_2_drvr.id_dest);
                      	$display("");
                      
                      
                    end
                end

            test2:
                begin
                  $display("test2");   
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
