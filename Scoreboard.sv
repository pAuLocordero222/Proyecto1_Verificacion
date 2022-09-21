class scoreborad #(parameter pckg_size, num_msg, drvrs, bits);


    mailbox chckr_2_scrbrd_mbx;
    //mailbox agnt_2_scrbrd_mbx;
    mailbox drvr_2_scrbrd_mbx;

    int t_total = 0;
    int t_promedio = 0;

    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_drvr_scrbrd;
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_chckr_scrbrd;

    task run();
        msg_drvr_scrbrd = new;
        msg_chckr_scrbrd = new;
        $display("[%g] El scoreboard fue inicializado.", $time);

        $display("Retardo promedio");

        for (int i = 0; i < num_msg; i++) begin
            automatic int k = i;

            drvr_2_scrbrd_mbx.get(msg_drvr_scrbrd[k]);

            for (int j = 0; j < num_msg; j++) begin
                automatic int p = j;
                chckr_2_scrbrd_mbx.get(msg_chckr_scrbrd[p]);
                if (msg_drvr_scrbrd[k]==msg_chckr_scrbrd[p]) begin
                    t_total = t_total + msg_chckr_scrbrd[p].tiempo_recibido - msg_drvr_scrbrd[k].tiempo_envio;
                end
            end

        end

        t_promedio = t_total / num_msg;

        $display("El retardo promedio para todos los paquetes es: %d", t_promedio);




    endtask

    function new_row();


    endfunction

endclass