class age_gen #(parameter pckg_size, drvrs, broadcast);
    
    test tipo_test; //tipos de test para el DUT

    task run();
        tb.test_2_gen_mbx.get(tipo_test);
        case(tipo_test):
            test1:
                begin
                    
                end

            test2:
                begin
                    
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

