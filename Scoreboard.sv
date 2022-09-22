class scoreborad #(parameter pckg_size, num_msg, drvrs, bits);


    mailbox chckr_2_scrbrd_mbx;
    //mailbox agnt_2_scrbrd_mbx;
    mailbox drvr_2_scrbrd_mbx;


    int t_total = 0;
    int t_promedio = 0;
    int fcsv;

    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_drvr_scrbrd;//[drvrs-1:0];
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_chckr_scrbrd;//[drvrs-1:0];

    task run();
        
        $display("[%g] El scoreboard fue inicializado.", $time);

        fcsv = $fopen("./resultados.csv", "w");

        $fwrite(fcsv,"T_envio,Disp_envio,T_recibido,Disp_recibido,Retraso \n");
        

        $display("Retardo promedio");

        msg_drvr_scrbrd = new;
        msg_chckr_scrbrd = new;



        for (int i = 0; i < num_msg; i++) begin
            //fork
                automatic int k = i;
                //*msg_drvr_scrbrd[k] = new();

                drvr_2_scrbrd_mbx.peek(msg_drvr_scrbrd);

                
                $fwrite(fcsv, "%d, %d, %d, %d, %d \n", 1,2,3,4,5);

                for (int j = 0; j < num_msg; j++) begin
                    
                    //$display("%0h", msg_drvr_scrbrd[k].message);
                    //msg_chckr_scrbrd[j] = new();

                    chckr_2_scrbrd_mbx.get(msg_chckr_scrbrd);
                    if (msg_drvr_scrbrd.message==msg_chckr_scrbrd.message) begin
                        drvr_2_scrbrd_mbx.get(msg_drvr_scrbrd);
                        chckr_2_scrbrd_mbx.get(msg_chckr_scrbrd);
                        $display("%0d", msg_drvr_scrbrd.tiempo_envio);
                        t_total = t_total + msg_chckr_scrbrd.tiempo_recibido - msg_drvr_scrbrd.tiempo_envio;
                        //$fwrite(fcsv, "%d %d %d %d %d", msg_drvr_scrbrd[k].tiempo_envio, msg_drvr_scrbrd[k].id_emisor, msg_chckr_scrbrd[j].tiempo_recibido, msg_drvr_scrbrd[k].id_dest, t_total);
                    end

                    $display("Mensaje %0h",msg_chckr_scrbrd.message);
                    $display("Tiempo %0d", msg_chckr_scrbrd.tiempo_recibido);

                end


                if (i == num_msg - 1) begin
                    t_promedio = t_total / num_msg;
                    $display("El retardo promedio para todos los paquetes es: %d", t_promedio);
                end

            //join_none

        end
/*
        forever begin
            if (drvr_2_scrbrd_mbx.num()!==0) begin
                
            end
        end*/
/*
        t_promedio = t_total / num_msg;
        $display("El retardo promedio para todos los paquetes es: %d", t_promedio);*/




    endtask

/*
    function new_row();
    endfunction*/

endclass