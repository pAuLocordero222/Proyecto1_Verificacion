class checker #(parameter pckg_size, num_msg, drvrs, bits);

    bit [pckg_size-1:0]q_chkr[$]={}; //Queue para guardar los mensajes del monitor

    //Definicion de mailboxes
    mailbox mntr_2_chckr_mbx;
    mailbox agnt_2_chckr_mbx;
    mailbox chckr_2_scrbrd_mbx;
    mailbox drvr_2_chckr_mbx;


    //Objetos usados para el checker  
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_agnt_chckr;
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_mntr_chckr;
    trans_bus #(.pckg_size(pckg_size), .drvrs(drvrs)) msg_drvr_chckr;

    chkr_scrbrd #(.pckg_size(pckg_size)) ob_scrbrd;
    
    task run();
        $display("[%g] El checker fue inicializado.", $time);
        msg_agnt_chckr = new;//Inicializacion del objeto
        msg_mntr_chckr = new;//Inicializacion del objeto
        ob_scrbrd = new;

        //Ciclo for para guardar los mensajes del monitor en el queue
        for (int i = 0; i < num_msg; i++) begin
            mntr_2_chckr_mbx.peek(msg_mntr_chckr);//Toma los mensajes proveinentes del monitor
            //chckr_2_scrbrd_mbx.put(msg_mntr_chckr);//Envia los mensajes recibidos en el monitor al scoreboard
            q_chkr.push_back(msg_mntr_chckr.message);//Guarda los mensajes en un queue
        end


        for (int i = 0; i < num_msg; i++) begin//for para tomar todos los mensajes generados en el agente
            agnt_2_chckr_mbx.get(msg_agnt_chckr); //Se obtiene el dato desde el agente
            mntr_2_chckr_mbx.get(msg_mntr_chckr);
            $display("---------------------------");
            $display("Checker");
            $display("Se recibieron los mensajes desde el agente y desde el monitor");
            

            for (int j = 0; j < $size(q_chkr); j++) begin//Se recorre el queue con los mensajes del monitor
                if (q_chkr[j] == msg_agnt_chckr.message) begin//Se compara el mensaje del queue con el tomado del agente
                    $display("La transaccion %0d fue realizada correctamente", i); //Se imprime esto si los mensajes coinciden
                    $display("---------------------------");
                    drvr_2_chckr_mbx.get(msg_drvr_chckr);
                    ob_scrbrd.tiempo_envio = msg_drvr_chckr.tiempo_envio;
                    ob_scrbrd.tiempo_recibido = msg_mntr_chckr.tiempo_recibido;
                    ob_scrbrd.id_emisor = msg_drvr_chckr.id_emisor;
                    ob_scrbrd.id_dest = msg_drvr_scrbrd.id_dest;
                    ob_scrbrd.message = msg_agnt_chckr.message;
                    chckr_2_scrbrd_mbx.put(ob_scrbrd);
                end
            end


        end

    
    endtask


endclass